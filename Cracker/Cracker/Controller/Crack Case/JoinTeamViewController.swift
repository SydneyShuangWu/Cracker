//
//  JoinTeamViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/19.
//

import UIKit
import FirebaseAuth
import AVFoundation
import PKHUD

protocol NavigateToGameDelegate: AnyObject {
    
    func canNavigate(gameId: String)
}

class JoinTeamViewController: UIViewController {
    
    // UI
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var joinLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    
    // Pass value
    var closeJoinTeam: ((Bool) -> Void)?
    weak var delegate: NavigateToGameDelegate?
    
    // Firebase
    let firestoreManager = FirestoreManager.shared
    var player = CrackerPlayer()
    var currentUid = Auth.auth().currentUser?.uid
    var currentUser = CrackerUser(id: "")
    
    // QR Code
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    var teamId = ""

    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        prepareToScanQrCode()
        
        fetchUserData()
    }
    
    func prepareToScanQrCode() {
        
        // Gain access to back camera
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        
        // Capture input and output
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set up delegate
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            
            print(error)
            
            return
        }
        
        // Set up preview
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Arrange subview layer
        view.bringSubviewToFront(topView)
        view.bringSubviewToFront(closeBtn)
        view.bringSubviewToFront(joinLabel)
        
        // Start video capturing
        captureSession.startRunning()
        
        // Highlight QR Code
        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView {
            
            qrCodeFrameView.layer.borderColor = UIColor.O?.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }
    
    @IBAction func closeJoinTeamPage(_ sender: Any) {
        
        closeJoinTeam?(true)
    }
    
    func fetchUserData() {
        
        let document = firestoreManager.getCollection(name: .crackerUser).document(currentUid!)
        
        firestoreManager.readSingle(document, dataType: CrackerUser.self) { (result) in
            
            switch result {
            
            case .success(let crackerUser):
                
                self.currentUser = crackerUser
                
                // Fetch player data
                self.player.image = self.currentUser.image
                self.player.name = self.currentUser.name
            
            case .failure(let error):
                
                print("Failed to read current user: ", error.localizedDescription)
            }
        }
    }
    
    func fetchTeamId() {

        let document = firestoreManager.getCollection(name: .crackerGame).document("\(teamId.prefix(20))")

        // Save teammates as players
        let newplayer = document.collection("Players").document(currentUid!)
        player.id = newplayer.documentID
        player.teamId = teamId
        firestoreManager.save(to: newplayer, data: self.player)
        
        self.closeJoinTeam?(true)
        
        HUD.flash(.labeledSuccess(title: nil, subtitle: "Joined!"), delay: 0.5)
        
        // Listen to game status
        firestoreManager.getCollection(name: .crackerGame).document("\(teamId.prefix(20))").addSnapshotListener { (documentSnapshot, error) in

            guard let status = documentSnapshot?.data()?["gameDidStart"] as? Bool else { return }

            if status == true {

                print("😎 Game status fetched")

                self.delegate?.canNavigate(gameId: String(self.teamId.prefix(20)))
            }

            if let err = error {

                print(err)
            }
        }
    }
}

// MARK: - Fetch output
extension JoinTeamViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.isEmpty == true {
            
            qrCodeFrameView?.frame = CGRect.zero
            
            return
        }
        
        // Fetch metadata
        if let metaDataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
            
            if supportedCodeTypes.contains(metaDataObj.type) {
                
                let qrCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metaDataObj)
                
                qrCodeFrameView?.frame = qrCodeObject!.bounds
                
                if metaDataObj.stringValue != nil {
                    
                    print(metaDataObj.stringValue ?? "😕 No qrcode is detected")
                    
                    teamId = metaDataObj.stringValue ?? ""
                    
                    fetchTeamId()
                }
            }
            
        } else { return }
    }
}
