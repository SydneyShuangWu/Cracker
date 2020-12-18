//
//  CreateCaseViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/7.
//

import UIKit

class CreateCaseViewController: UIViewController {
    
    var selectedCaseCategory: CaseCategory?
    var crackerCase = CrackerCase()

    var imagePickerController: UIImagePickerController?
    
    @IBOutlet weak var caseImage: UIImageView!
    @IBOutlet weak var caseNameTF: UITextField!
    @IBOutlet weak var caseLocationTF: UITextField!
    @IBOutlet weak var caseDurationTF: UITextField!
    @IBOutlet weak var startTimeTF: UITextField!
    @IBOutlet weak var endTimeTF: UITextField!
    @IBOutlet weak var minHeadCountTF: UITextField!
    @IBOutlet weak var maxHeadCountTF: UITextField!
    @IBOutlet weak var contentCountLabel: UILabel!
    @IBOutlet weak var contentCountTF: UITextField!
    @IBOutlet weak var introTV: UITextView!
    @IBOutlet weak var scriptLabel: UILabel!
    @IBOutlet weak var scriptTV: UITextView!
    @IBOutlet weak var finalStageLabel: UILabel!
    @IBOutlet weak var finalStageTF: UITextField!
    @IBOutlet weak var finalStageCoordinate: UILabel!
    @IBOutlet weak var longitudeTF: UITextField!
    @IBOutlet weak var latitudeTF: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var charCountLimit: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(with: "Create Your Case")
        setupCloseButton()
        setupBackButton()
        
        setupUI()
        setupLabel()
    }
    
    // MARK: - UI
    func setupUI() {
        
        continueBtn.setupCornerRadius()

        introTV.setupCornerRadius()
        introTV.setupTextFieldBorder()
        
        scriptTV.setupCornerRadius()
        scriptTV.setupTextFieldBorder()
        
        if selectedCaseCategory == CaseCategory.linear {
            
            showLinear()
            hideRPG()
            
        } else {
            
            hideLinear()
            showRPG()
        }
    }
    
    func setupLabel() {
        
        if selectedCaseCategory == CaseCategory.linear {
            
            contentCountLabel.text = "關卡數量"
            charCountLimit.isHidden = true
            
        } else {
            
            contentCountLabel.text = "NPC 數量"
            charCountLimit.isHidden = false
        }
    }
    
    func showLinear() {
        
        finalStageLabel.isHidden = false
        finalStageTF.isHidden = false
        finalStageCoordinate.isHidden = false
        longitudeTF.isHidden = false
        latitudeTF.isHidden = false
    }
    
    func hideLinear() {
        
        finalStageLabel.isHidden = true
        finalStageTF.isHidden = true
        finalStageCoordinate.isHidden = true
        longitudeTF.isHidden = true
        latitudeTF.isHidden = true
    }
    
    func showRPG() {
        
        scriptLabel.isHidden = false
        scriptTV.isHidden = false
    }
    
    func hideRPG() {
        
        scriptLabel.isHidden = true
        scriptTV.isHidden = true
    }
    
    // MARK: - Upload Image
    @IBAction func uploadCaseImage(_ sender: Any) {
        
        imagePickerController = UIImagePickerController()
        
        imagePickerController?.delegate = self
        
        imagePickerController?.allowsEditing = true
        
        let imagePickerAlert = UIAlertController(title: "Select Photo", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                self.imagePickerController?.sourceType = .camera
                
                self.present(self.imagePickerController!, animated: true, completion: nil)
            }
        }
        
        let photosAction = UIAlertAction(title: "Photos", style: .default) { _ in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                self.imagePickerController?.sourceType = .photoLibrary
                
                self.present(self.imagePickerController!, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
            self.imagePickerController?.dismiss(animated: true, completion: nil)
        }
        
        imagePickerAlert.addAction(cameraAction)
        imagePickerAlert.addAction(photosAction)
        imagePickerAlert.addAction(cancelAction)
        
        present(imagePickerAlert, animated: true, completion: nil)
    }
    
    // MARK: - Navigate To Next Page
    @IBAction func navigateToDesignCaseVc(_ sender: Any) {
        
        let vc = myStoryboard.instantiateViewController(withIdentifier: "DesignCaseVc") as! DesignCaseViewController
        
        guard getCaseData() else {
            
            showAlert(withTitle: "請填寫所有資訊", withActionTitle: "OK", message: nil)
            
            return
        }
        
        vc.selectedCaseCategory = selectedCaseCategory
        vc.caseImage = caseImage.image
        vc.crackerCase = crackerCase

        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getCaseData() -> Bool {
        
        guard let name = caseNameTF.text,
              let location = caseLocationTF.text,
              let duration = caseDurationTF.text,
              let startTime = startTimeTF.text,
              let endTime = endTimeTF.text,
              let minCount = minHeadCountTF.text,
              let maxCount = maxHeadCountTF.text,
              let contentCount = contentCountTF.text,
              let introduction = introTV.text,
              let finalStageName = finalStageTF.text,
              let finalLongitude = longitudeTF.text,
              let finalLatitude = latitudeTF.text,
              let script = scriptTV.text
        
        else { return false }
        
        if !name.isEmpty, !location.isEmpty, !duration.isEmpty, !startTime.isEmpty, !endTime.isEmpty, !minCount.isEmpty, !maxCount.isEmpty, !contentCount.isEmpty, !introduction.isEmpty, caseImage.image != nil {
            
            crackerCase.name = name
            crackerCase.location = location
            crackerCase.duration = duration
            crackerCase.startTime = startTime
            crackerCase.endTime = endTime
            crackerCase.minHeadCount = Int(minCount) ?? -1
            crackerCase.maxHeadCount = Int(maxCount) ?? -1
            crackerCase.contentCount = Int(contentCount) ?? -1
            crackerCase.introduction = introduction
            
            if selectedCaseCategory == CaseCategory.linear {
                
                if !finalStageName.isEmpty, !finalLongitude.isEmpty, !finalLatitude.isEmpty {
                    
                    crackerCase.finalStageName = finalStageName
                    crackerCase.finalStageLongitude = Double(finalLongitude)
                    crackerCase.finalStageLatitude = Double(finalLatitude)
                    
                } else { return false }
                
            } else {
                
                if !script.isEmpty {
                    
                    crackerCase.script = script
                    
                } else { return false }
            }
            
            return true
            
        } else {
            
            return false
        }
    }
}

extension CreateCaseViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            
            caseImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}
