//
//  DesignCaseViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/8.
//

import UIKit
import PKHUD
import FirebaseAuth

class DesignCaseViewController: UIViewController {
    
    // Value passed from create case vc
    var selectedCaseCategory: CaseCategory?
    var caseImage: UIImage?
    var crackerCase = CrackerCase()
    
    // Expandable sections
    var sectionDataList: [Int] = []
    var isExpandList: [Bool] = []
    var sectionCount = 0
    
    // Upload image
    var imagePickerController: UIImagePickerController?
    var selectedImages: [UIImage] = []
    var selectUploadBtnIndex: Int?
    
    // Firebase
    let firestoreManager = FirestoreManager.shared
    let storageManager = StorageManager.shared
    
    @IBOutlet weak var designCaseTableView: UITableView!
    @IBOutlet weak var bottomBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupNavigationBar(with: "Design Your Case")
        setupBackButton()
        setupCloseButton()
        
        configureButtons()
        setupTableView()
        registerNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        configureSections()
    }
    
    func configureSections() {
        
        sectionCount = crackerCase.contentCount
        
        for index in 1...sectionCount {
            
            sectionDataList.append(index)
            isExpandList.append(false)
            selectedImages.append(UIImage())
        }
    }
    
    func configureButtons() {
        
        bottomBtn.setupCornerRadius()
        
        if selectedCaseCategory == CaseCategory.linear {
            
            bottomBtn.setTitle("COMPLETE", for: .normal)
            
        } else {
            
            bottomBtn.setTitle("CONTINUE", for: .normal)
        }
    }
    
    func setupTableView() {
        
        designCaseTableView.delegate = self
        designCaseTableView.dataSource = self
    }
    
    func registerNib() {
        
        let sectionViewNib: UINib = UINib(nibName: "SectionView", bundle: nil)
        designCaseTableView.register(sectionViewNib, forHeaderFooterViewReuseIdentifier: "SectionView")
        
        let stageViewNib: UINib = UINib(nibName: "StageViewCell", bundle: nil)
        designCaseTableView.register(stageViewNib, forCellReuseIdentifier: "StageViewCell")
        
        let rpgViewNib: UINib = UINib(nibName: "RPGViewCell", bundle: nil)
        designCaseTableView.register(rpgViewNib, forCellReuseIdentifier: "RPGViewCell")
    }
    
    @IBAction func navigate(_ sender: Any) {
        
        guard crackerCase.stages?.count == sectionCount else {
            
            showAlert(withTitle: "請填寫所有資訊", withActionTitle: "OK", message: nil)
            
            return
        }
        
        if selectedCaseCategory == CaseCategory.linear {
            
            HUD.flash(.labeledSuccess(title: nil, subtitle: "Case Created!"), delay: 0.3) { _ in
                
                self.addLinearCase()
                
                self.navigateToLobby()
            }
            
        } else {
            
            let vc = myStoryboard.instantiateViewController(withIdentifier: "DesignTestVc") as! DesignTestViewController

            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getCaseImageUrl(id: String, handler: @escaping (String) -> Void) {
        
        storageManager.uploadImage(image: caseImage!, folder: .caseImage, id: id) { (result) in
            
            switch result {
            
            case .success(let url):
                
                handler(url)
                
            case .failure(let error):
                
                print("Failed to upload image: ", error.localizedDescription)
            }
        }
    }
    
    func addLinearCase() {
        
        let document = firestoreManager.getCollection(name: .crackerCase).document()
        
        crackerCase.id = document.documentID
        crackerCase.creator = CrackerUser(id: String(Auth.auth().currentUser!.uid))
        crackerCase.category = selectedCaseCategory!.rawValue
        
        // Upload image to Storage
        getCaseImageUrl(id: document.documentID) { (imageUrl) in
            
            self.crackerCase.image = imageUrl
            self.firestoreManager.save(to: document, data: self.crackerCase)
        }
    }
}

extension DesignCaseViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isExpandList[section] == true ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let stageCell = tableView.dequeueReusableCell(withIdentifier: "StageViewCell") as? StageViewCell
        
        stageCell?.callback = { stage in
            
            self.crackerCase.stages?.append(stage)
        }
        
        let rpgCell = tableView.dequeueReusableCell(withIdentifier: "RPGViewCell") as? RPGViewCell
        
        rpgCell?.delegate = self
        
        rpgCell?.uploadBtn.tag = indexPath.section
    
        rpgCell?.renderImage(with: selectedImages[indexPath.section])
        
        if selectedCaseCategory == CaseCategory.linear {
            return stageCell ?? UITableViewCell()
        }
        
        return rpgCell ?? UITableViewCell()
    }
}

extension DesignCaseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 780
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionView") as! SectionView
        
        sectionView.isExpand = isExpandList[section]
        sectionView.buttonTag = section
        sectionView.delegate = self
        
        // Switch button image
        sectionView.toggleBtn.setImage(isExpandList[section] == true ? UIImage(named: "Down Arrow") : UIImage(named: "Right Arrow"), for: .normal)
        
        // Configure section title
        if selectedCaseCategory == CaseCategory.linear {
            sectionView.sectionTitle.text = "Stage " + "\(sectionDataList[section])"
        } else {
            sectionView.sectionTitle.text = "Character " + "\(sectionDataList[section])"
        }
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 60
    }
}

extension DesignCaseViewController: SectionViewDelegate {
    
    func sectionView(_ sectionView: SectionView, _ didPressTag: Int, _ isExpand: Bool) {
        
        isExpandList[didPressTag] = !isExpand
        designCaseTableView.reloadSections(IndexSet(integer: didPressTag), with: .automatic)
    }
}

extension DesignCaseViewController: RPGViewCellDelegate {
    
    func uploadBtnDidPress(_ didPress: Bool, index: Int) {
        
        selectUploadBtnIndex = index
        
        if didPress == true {
            
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
}

extension DesignCaseViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            
            guard let index = selectUploadBtnIndex else { return }
            
            selectedImages[index] = selectedImage
            
            designCaseTableView.reloadData()
        }
        
        dismiss(animated: true, completion: nil)
    }
}
