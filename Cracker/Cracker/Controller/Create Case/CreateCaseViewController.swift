//
//  CreateCaseViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/7.
//

import UIKit

class CreateCaseViewController: UIViewController {
    
    var caseCategory: CaseCategory?

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
    @IBOutlet weak var openingTV: UITextView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(with: "Create A Case")
        setupCloseButton()
        setupBackButton()
        
        setupUI()
        setupLabel()
    }
    
    func setupUI() {
        
        continueBtn.setupCornerRadius()
        
        openingTV.layer.borderWidth = 1.5
        openingTV.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func setupLabel() {
        
        if caseCategory == CaseCategory.linear {
            contentCountLabel.text = "關卡數量"
        } else {
            contentCountLabel.text = "NPC 數量"
        }
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
}

extension CreateCaseViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            
            caseImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}
