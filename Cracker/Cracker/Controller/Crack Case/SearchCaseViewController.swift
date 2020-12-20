//
//  SearchCaseViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/1.
//

import UIKit
import PKHUD

class SearchCaseViewController: UIViewController {
    
    // UI
    @IBOutlet weak var findCaseBtn: UIButton!
    @IBOutlet weak var searchCaseTableView: UITableView!
    @IBOutlet weak var orangeView: UIView!
    @IBOutlet weak var joinTeamView: UIView!
    
    // Selection
    let selectionView = SelectionView()
    var searchSource: [SelectionModel] = []
    
    // Data
    private var classicCases = [CrackerCase]()
    private var filteredCases = [CrackerCase]()
    var selectedCase =  CrackerCase()
    let firestoreManager = FirestoreManager.shared
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Listen for realtime cases
        firestoreManager.listen(collectionName: .crackerCase) {
            
            self.fetchAllCases()
            self.searchCaseTableView.reloadData()
        }
        
        searchSource = [
            SelectionModel(title: "Popular Cases", data: []),
            SelectionModel(title: "Classic Cases", data: classicCases)
        ]
        
        setupUI()
    }
    
    func setupUI() {
        
        setupNavigationBar(with: "CASES")
        setupCloseButton()
        setupJoinButton()
        
        findCaseBtn.setupCornerRadius()
        joinTeamView.setupCornerRadius()
        
        setupSelecionView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        HUD.flash(.label("Loading..."), delay: 1.5)
    }
    
    @IBAction func findCase(_ sender: Any) {
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
            selectionView.topAnchor.constraint(equalTo: orangeView.bottomAnchor),
            selectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            selectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            selectionView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func setupTableView() {
        
        searchCaseTableView.delegate = self
        searchCaseTableView.dataSource = self
    }
    
    func setupJoinButton() {
        
        let joinBtn = UIButton(type: .custom)
        
        joinBtn.setImage(UIImage(named: "Join"), for: .normal)
        
        joinBtn.addTarget(self, action: #selector(showJoinTeamVc), for: .touchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem(customView: joinBtn)
        
        NSLayoutConstraint.activate([leftBarButtonItem.customView!.widthAnchor.constraint(equalToConstant: 28), leftBarButtonItem.customView!.heightAnchor.constraint(equalToConstant: 28)])
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func showJoinTeamVc(sender: UIButton) {
        
        UIView.animate(withDuration: 0.5) {
            
            self.joinTeamView.frame = CGRect(x: (UIScreen.main.bounds.width  - self.joinTeamView.bounds.width) / 2, y: (UIScreen.main.bounds.height  - self.joinTeamView.bounds.height) / 2, width: self.joinTeamView.bounds.width, height: self.joinTeamView.bounds.height)
        }
    }
    
    func hideJoinTeamVc() {
        
        UIView.animate(withDuration: 0.5) {
            self.joinTeamView.frame = CGRect(x: -UIScreen.main.bounds.width, y: self.joinTeamView.frame.minY, width: self.joinTeamView.bounds.width, height: self.joinTeamView.bounds.height)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCaseDetailVc" {
            
            let nextVc = segue.destination as? CaseDetailViewController
            
            nextVc?.selectedCase = selectedCase
        }
        
        if segue.identifier == "toJoinTeamPage" {
            
            let nextVc = segue.destination as? JoinTeamViewController
            
            nextVc?.closeJoinTeam = { _ in
                
                self.hideJoinTeamVc()
            }
        }
    }
    
    // MARK: - Firestore
    func fetchAllCases() {
        
        firestoreManager.read(collectionName: .crackerCase, dataType: CrackerCase.self) { (result) in
            
            switch result {
            
            case .success(let crackerCases):
                
                self.classicCases = crackerCases
      
            case .failure(let error):
                
                print("Failed to read cases: ", error.localizedDescription)
            }
        }
    }
}

// MARK: - Selection View
extension SearchCaseViewController: SelectionViewDataSource {
    
    func numberOfButtons(in selectionView: SelectionView) -> Int {
        
        return searchSource.count
    }
    
    func buttonTitle(in selectionView: SelectionView, titleForButtonAt index: Int) -> String {
        
        return searchSource[index].title
    }
}

extension SearchCaseViewController: SelectionViewDelegate {
    
    func didSelectButton(_ selectionView: SelectionView, at index: Int) {
        
        switch index {
        
        case 0:
            filteredCases = []
            searchCaseTableView.reloadData()
            
        case 1:
            // MARK: Modification Required
            filteredCases = classicCases
            searchCaseTableView.reloadData()
            
        default:
            break
        }
    }
}

// MARK: - Filtered Table View
extension SearchCaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCaseTBCell") as! SearchCaseTBCell
        
        cell.setupCellWith(cases: filteredCases[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCase = filteredCases[indexPath.row]
        
        performSegue(withIdentifier: "toCaseDetailVc", sender: self)

        searchCaseTableView.deselectRow(at: indexPath, animated: true)
    }
}
