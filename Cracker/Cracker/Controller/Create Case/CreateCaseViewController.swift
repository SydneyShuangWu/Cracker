//
//  CreateCaseViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/7.
//

import UIKit

class CreateCaseViewController: UIViewController {
    
    var selectedCaseCategory: CaseCategory?

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(with: "Create Your Case")
        setupCloseButton()
        setupBackButton()
        
        setupUI()
        setupLabel()
    }
    
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
        } else {
            contentCountLabel.text = "NPC 數量"
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
    
    @IBAction func navigateToDesignCaseVc(_ sender: Any) {
        
        let vc = myStoryboard.instantiateViewController(withIdentifier: "DesignCaseVc") as! DesignCaseViewController
        
        vc.selectedCaseCategory = selectedCaseCategory

        navigationController?.pushViewController(vc, animated: true)
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
