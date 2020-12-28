//
//  SearchCaseViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/1.
//

import UIKit
import PKHUD
import FirebaseAuth

class SearchCaseViewController: UIViewController {
    
    // UI
    @IBOutlet weak var findCaseBtn: UIButton!
    @IBOutlet weak var searchCaseTableView: UITableView!
    @IBOutlet weak var orangeView: UIView!
    @IBOutlet weak var joinTeamView: UIView!
    
    // Selection
    let selectionView = SelectionView()
    var searchSource: [SelectionModel] = []
    
    // Data from JoinTeamVc
    var gameId = ""
    
    // MARK: - Modification Required
    // Firestore
    let firestoreManager = FirestoreManager.shared
    let authManager = FirebaseAuthManager()
    private var classicCases = [CrackerCase]()
    private var popularCases = [CrackerCase]()
    private var filteredCases = [CrackerCase]()
    var selectedCase =  CrackerCase()
    var caseCategory = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Listen for realtime cases
        firestoreManager.listen(collectionName: .crackerCase) {
            
            self.fetchPopularCases()
            self.fetchAllCases()
            self.searchCaseTableView.reloadData()
        }
        
        searchSource = [
            SelectionModel(title: "Popular Cases", data: popularCases),
            SelectionModel(title: "Classic Cases", data: classicCases)
        ]

        setupUI()
    }
    
    // MARK: - UI
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
        
        joinBtn.addTarget(self, action: #selector(joinTeamDidTap), for: .touchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem(customView: joinBtn)
        
        NSLayoutConstraint.activate([leftBarButtonItem.customView!.widthAnchor.constraint(equalToConstant: 28), leftBarButtonItem.customView!.heightAnchor.constraint(equalToConstant: 28)])
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func joinTeamDidTap(sender: UIButton) {
            
        showJoinTeamVc()
    }
    
    @objc func showJoinTeamVc() {
        
        UIView.animate(withDuration: 0.5) {
            
            self.joinTeamView.frame = CGRect(x: (UIScreen.main.bounds.width  - self.joinTeamView.bounds.width) / 2, y: self.joinTeamView.frame.minY, width: self.joinTeamView.bounds.width, height: self.joinTeamView.bounds.height)
        }
    }
    
    func hideJoinTeamVc() {
        
        UIView.animate(withDuration: 0.5) {
            self.joinTeamView.frame = CGRect(x: -UIScreen.main.bounds.width, y: self.joinTeamView.frame.minY, width: self.joinTeamView.bounds.width, height: self.joinTeamView.bounds.height)
        }
    }
    
    // MARK: - Segue
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
            
            nextVc?.delegate = self
        }
    }
    
    // MARK: - Fetch all cases
    func fetchAllCases() {
        
        firestoreManager.read(collectionName: .crackerCase, dataType: CrackerCase.self) { (result) in
            
            switch result {
            
            case .success(let crackerCases):
                
                self.searchSource[1].data = crackerCases.sorted(by: { (first, second) -> Bool in
                    
                    return first.createdTime.dateValue() > second.createdTime.dateValue()
                })
      
            case .failure(let error):
                
                print("Failed to read cases: ", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Fetch popular cases
    func fetchPopularCases() {
                
        firestoreManager.read(collectionName: .crackerCase, dataType: CrackerCase.self, filterGreaterThan: .init(key: "score", value: 4)) { (result) in
            
            switch result {
            
            case .success(let crackerCases):
                
                self.filteredCases = crackerCases.sorted(by: { (first, second) -> Bool in
                    
                    return first.score! > second.score!
                })
                self.searchCaseTableView.reloadData()
                
                self.searchSource[0].data = crackerCases.sorted(by: { (first, second) -> Bool in
                    
                    return first.score! > second.score!
                })
      
            case .failure(let error):
                
                print("Failed to read cases: ", error.localizedDescription)
            }
        }
    }
}

// MARK: - Navigate to game page
extension SearchCaseViewController: NavigateToGameDelegate {
    
    func fetchCaseCategory() {
        
        let document = firestoreManager.getCollection(name: .crackerGame).document("\(gameId.prefix(20))").collection("CrackerCase")
        
        firestoreManager.read(collection: document, dataType: CrackerCase.self) { (result) in
            
            switch result {
            
            case .success(let crackerCase):
                
                self.caseCategory = crackerCase[0].category
                self.syncToGamePage()
                
            case .failure(let error):
                
                print("Failed to read cases: ", error.localizedDescription)
            }
        }
    }
    
    func syncToGamePage() {
        
        var vc: UIViewController
        
        if caseCategory == Category.linear.rawValue {
            
            vc = myStoryboard.instantiateViewController(withIdentifier: "LinearTabBar")

            // Set up delegate to pass stage index from stageVc to stageMapVc
            if let stageVC = (vc as? UITabBarController)?.viewControllers?.first as?
                StageViewController,
               let stageMapVC = (vc as? UITabBarController)?.viewControllers?[1] as? StageMapViewController,
               let stageBoardVC = (vc as? UITabBarController)?.viewControllers?[2] as? StageBoardViewController {
                
                stageVC.gameId = gameId
                stageMapVC.gameId = gameId
                
                stageVC.delegate = stageMapVC
                
                stageBoardVC.gameId = gameId
            }
            
        } else {
            
            vc = myStoryboard.instantiateViewController(withIdentifier: "RPGTabBar")
        }
        
        let nav = UINavigationController(rootViewController: vc)

        nav.modalPresentationStyle = .fullScreen

        nav.hero.isEnabled = true

        nav.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .up))

        present(nav, animated: true, completion: nil)
    }
    
    func canNavigate(gameId: String) {
        
        self.gameId = gameId
        
        self.fetchCaseCategory()
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
            filteredCases = searchSource[0].data
            searchCaseTableView.reloadData()
            
        case 1:
            filteredCases = searchSource[1].data
            searchCaseTableView.reloadData()
            
        default:
            break
        }
    }
}

// MARK: - Table View
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
