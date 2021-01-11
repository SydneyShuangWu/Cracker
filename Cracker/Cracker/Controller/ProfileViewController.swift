//
//  ProfileViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/4.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {
    
    // UI
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileRank: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchCaseTableView: UITableView!
    @IBOutlet weak var editNamePage: UIView!
    
    // Upload Profile Image
    var imagePickerController: UIImagePickerController?
    let storageManager = StorageManager.shared
    var editedImage: UIImage?
    
    // Selection
    let selectionView = SelectionView()
    var profileSource: [SelectionModel] = []
    
    // MARK: - Modification Required
    // Data
    private var filteredCases = [CrackerCase]()
    private var createdCases = [CrackerCase]()
    private var crackedCases = [CrackerCase]()
    private var treasuredCases = [CrackerCase]()
    var isBinBtnEnabled = false
    
    // Firestore
    let authManager = FirebaseAuthManager()
    let firestoreManager = FirestoreManager.shared
    var currentUid = Auth.auth().currentUser?.uid
    var currentUser = CrackerUser(id: "") {
        didSet {
            
            if currentUser.image.isEmpty {
                
                profileImage.image = UIImage(named: "Ginger Bread Man")
                
            } else {
                
                profileImage.loadImage(currentUser.image)
            }
            
            profileName.text = currentUser.name
            profileRank.text = String(currentUser.rank)
        }
    }
    
    // Fetch cracked game record
    var crackedGames: [CrackerGame] = [] {
        didSet {
            
            fetchCrackedCases()
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        profileSource = [
            SelectionModel(title: "Created", data: createdCases),
            SelectionModel(title: "Cracked", data: crackedCases),
            SelectionModel(title: "Treasured", data: treasuredCases)
        ]
        
        setupUI()
        
        setupSelecionView()
        
        fetchUserData()
    }
    
    // MARK: - Fetch Profile Data
    func fetchUserData() {
        
        let document = firestoreManager.getCollection(name: .crackerUser).document(String(currentUid!))
        
        firestoreManager.readSingle(document, dataType: CrackerUser.self) { (result) in
            
            switch result {
            
            case .success(let crackerUser):
                
                self.currentUser = crackerUser
                
                self.fetchCreatedCases()
                
                self.fetchCrackedGames()
                
            case .failure(let error):
                
                print("Failed to read current user: ", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Edit Profile Data
    @IBAction func editBtnDidTap(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
            
            self.editNamePage.frame = CGRect(x: (UIScreen.main.bounds.width  - self.editNamePage.bounds.width) / 2, y: self.editNamePage.frame.minY, width: self.editNamePage.bounds.width, height: self.editNamePage.bounds.height)
        }
    }
    
    func hideEditNamePage() {
        
        UIView.animate(withDuration: 0.5) {
            self.editNamePage.frame = CGRect(x: UIScreen.main.bounds.width, y: self.editNamePage.frame.minY, width: self.editNamePage.bounds.width, height: self.editNamePage.bounds.height)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toEditNamePage" {
            
            let nextVc = segue.destination as? EditNameViewController
            
            nextVc?.didEditName = { (didEdit, editedName) in
                
                if didEdit == false {
                    
                    self.hideEditNamePage()
                    
                } else {
                    
                    self.profileName.text = editedName
                    self.currentUser.name = editedName!
                    
                    // Post edited profile name to Firestore
                    self.firestoreManager.update(collectionName: .crackerUser, documentId: self.currentUid!, fields: ["name" : editedName!])
                }
            }
        }
    }
    
    // MARK: - Fetch Created Cases
    func fetchCreatedCases() {
        
        firestoreManager.read(collectionName: .crackerCase, dataType: CrackerCase.self, filter: .init(key: "creator", value: currentUid!)) { (result) in
            
            switch result {
            
            case .success(let crackerCases):
                
                self.filteredCases = crackerCases
                self.searchCaseTableView.reloadData()
                self.profileSource[0].data = crackerCases
                
            case .failure(let error):
                
                print("Failed to read created cases: ", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Fetch Cracked Games
    func filterPlayer(crackerGames: [CrackerGame]) {
        
        var crackedGames: [CrackerGame] = []
        
        for crackerGame in crackerGames {
            
            let collection = firestoreManager.getCollection(name: .crackerGame).document(crackerGame.id).collection("Players")
            
            collection.getDocuments { (querySnapshot, error) in
                
                guard let docs = querySnapshot?.documents else { return }
                
                for doc in docs where doc.documentID == self.currentUid {
                    
                    crackedGames.append(crackerGame)
                }
                
                if let err = error {
                    
                    print(err)
                }
            }
        }
        
        self.crackedGames = crackedGames
    }
    
    func fetchCrackedGames() {
        
        firestoreManager.read(collectionName: .crackerGame, dataType: CrackerGame.self) { (result) in
            
            switch result {
            
            case .success(let crackerGames):
                
                self.filterPlayer(crackerGames: crackerGames)

            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Fetch Cracked Cases
    func fetchCrackedCases() {
        
        for game in crackedGames {
            
            let caseCollection = firestoreManager.getCollection(name: .crackerGame).document(game.id).collection("CrackerCase")
            
            firestoreManager.read(collection: caseCollection, dataType: CrackerCase.self) { (result) in
                
                switch result {
                
                case .success(let crackerCases):
                    
                    self.profileSource[1].data = crackerCases
                    
                case .failure(let error):
                    
                    print("Failed to read cases: ", error.localizedDescription)
                }
            }
//            let playerCo = firestoreManager.getCollection(name: .crackerGame).document(game.id).collection("Players").document(currentUid!)
//
//            firestoreManager.readSingle(playerCo, dataType: <#T##(Decodable & Encodable).Protocol#>, handler: <#T##(Result<Decodable & Encodable>) -> Void#>)
        }
    }
    
    // MARK: - UI
    func setupToolBoxButton() {
        
        let toolBoxBtn = UIButton(type: .custom)
        
        toolBoxBtn.setImage(UIImage(named: "Tool Box"), for: .normal)
        
        toolBoxBtn.addTarget(self, action: #selector(toolBoxButtonTap), for: .touchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem(customView: toolBoxBtn)
        
        NSLayoutConstraint.activate([leftBarButtonItem.customView!.widthAnchor.constraint(equalToConstant: 28), leftBarButtonItem.customView!.heightAnchor.constraint(equalToConstant: 28)])
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func toolBoxButtonTap(sender: UIButton) {
    }
    
    func setupUI() {
        
        setupNavigationBar(with: "Profile")
        setupCloseButton()
//        setupToolBoxButton()

        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        profileRank.layer.cornerRadius = profileRank.frame.size.width / 2
        profileRank.clipsToBounds = true

        searchBtn.setupCornerRadius()
        
        editNamePage.setupCornerRadius()
        
        setupTableView()
    }
    
    func setupSelecionView() {
        
        view.addSubview(selectionView)
        
        setupSelectionViewConstraints()
        
        selectionView.delegate = self
        selectionView.dataSource = self
    }
    
    func setupSelectionViewConstraints() {
        
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectionView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15),
            selectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            selectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            selectionView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func setupTableView() {
        
        searchCaseTableView.delegate = self
        searchCaseTableView.dataSource = self
    }
    
    // MARK: - Upload Profile Image
    @IBAction func uploadProfileImage(_ sender: Any) {
        
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

// MARK: - Selection View
extension ProfileViewController: SelectionViewDataSource {
    
    func numberOfButtons(in selectionView: SelectionView) -> Int {
        
        return profileSource.count
    }
    
    func buttonTitle(in selectionView: SelectionView, titleForButtonAt index: Int) -> String {
        
        return profileSource[index].title
    }
}

extension ProfileViewController: SelectionViewDelegate {
    
    func didSelectButton(_ selectionView: SelectionView, at index: Int) {
        
        switch index {
        
        case 0:
            filteredCases = profileSource[index].data
            searchCaseTableView.reloadData()
            isBinBtnEnabled = false
            
        case 1:
            filteredCases = profileSource[index].data
            searchCaseTableView.reloadData()
            isBinBtnEnabled = false
            
        case 2:
            filteredCases = profileSource[index].data
            searchCaseTableView.reloadData()
            isBinBtnEnabled = true
            
        default:
            break
        }
    }
}

// MARK: - Table View
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCaseTBCell") as! ProfileCaseTBCell
        
        cell.setupCellWith(cases: filteredCases[indexPath.row])
        
        if isBinBtnEnabled == true {
            cell.enableBinBtn()
        } else {
            cell.disableBinBtn()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
}

// MARK: - Upload Image to Storage
extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            
            profileImage.image = selectedImage
            editedImage = selectedImage
        }
        
        getProfileImageUrl(id: currentUid!) { url in
            
            self.currentUser.image = url
            self.firestoreManager.update(collectionName: .crackerUser, documentId: self.currentUid!, fields: ["image" : url])
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func getProfileImageUrl(id: String, handler: @escaping (String) -> Void) {
        
        storageManager.uploadImage(image: editedImage!, folder: .userImage, id: id) { (result) in
            
            switch result {
            
            case .success(let url):
                
                handler(url)
                
            case .failure(let error):
                
                print("Failed to upload image: ", error.localizedDescription)
            }
        }
    }
}
