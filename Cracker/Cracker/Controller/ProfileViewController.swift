//
//  ProfileViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/4.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileId: UILabel!
    @IBOutlet weak var profileRank: UILabel!
    @IBOutlet weak var myFriendsBtn: UIButton!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchCaseTableView: UITableView!
    
    let selectionView = SelectionView()
    
    private var cases = [MockCase]()
    
    var isBinBtnEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(with: "Profile")
        setupCloseButton()
        setupToolBoxButton()
        
        setupUI()
        
        setupSelecionView()
        
//        setupUserProfile()
    }
    
    func setupToolBoxButton() {
        
        let toolBoxBtn = UIButton(type: .custom)
        
        toolBoxBtn.setImage(UIImage(named: "Tool Box"), for: .normal)
        
        toolBoxBtn.addTarget(self, action: #selector(toolBoxButtonTap), for: .touchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem(customView: toolBoxBtn)
        
        NSLayoutConstraint.activate([leftBarButtonItem.customView!.widthAnchor.constraint(equalToConstant: 35), leftBarButtonItem.customView!.heightAnchor.constraint(equalToConstant: 35)])
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func toolBoxButtonTap(sender: UIButton) {
    }
    
    func setupUI() {

        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        profileRank.layer.cornerRadius = profileRank.frame.size.width / 2
        profileRank.clipsToBounds = true
        
        myFriendsBtn.setupCornerRadius()
        myFriendsBtn.setupBorder()
        
        editProfileBtn.setupCornerRadius()
        editProfileBtn.setupBorder()
        
        searchBtn.setupCornerRadius()
        
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
            selectionView.topAnchor.constraint(equalTo: editProfileBtn.bottomAnchor, constant: 15),
            selectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            selectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            selectionView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
//    func setupUserProfile() {
//
//        profileImage.image = sydney.image
//        profileId.text = sydney.id
//        profileRank.text = "\(sydney.rank)"
//    }
    
    func setupTableView() {
        
        searchCaseTableView.delegate = self
        searchCaseTableView.dataSource = self
    }
}

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
            cases = crackedCases
            searchCaseTableView.reloadData()
            isBinBtnEnabled = false
            
        case 1:
            cases = createdCases
            searchCaseTableView.reloadData()
            isBinBtnEnabled = false
            
        case 2:
            cases = treasuredCases
            searchCaseTableView.reloadData()
            isBinBtnEnabled = true
            
        default:
            break
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCaseTBCell") as! ProfileCaseTBCell
        
        cell.setupCellWith(cases: cases[indexPath.row])
        
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
