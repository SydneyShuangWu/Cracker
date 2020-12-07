//
//  SearchCaseViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/1.
//

import UIKit

class SearchCaseViewController: UIViewController {
    
    @IBOutlet weak var findCaseBtn: UIButton!
    
    @IBOutlet weak var searchCaseTableView: UITableView!
    
    let selectionView = SelectionView()
    
    @IBOutlet weak var orangeView: UIView!
    
    private var cases = [MockCase]()
    
    var selectedCase: MockCase?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupNavigationBar(with: "CASES")
        setupCloseButton()
        findCaseBtn.setupCornerRadius()
        
        setupSelecionView()
        
        setupTableView()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCaseDetailVc" {
            
            let nextVc = segue.destination as? CaseDetailViewController
            
            nextVc?.selectedCase = selectedCase
        }
    }
}

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
            cases = popularCases
            searchCaseTableView.reloadData()
            
        case 1:
            cases = classicCases
            searchCaseTableView.reloadData()
            
        default:
            break
        }
    }
}

extension SearchCaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCaseTBCell") as! SearchCaseTBCell
        
        cell.setupCellWith(cases: cases[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCase = cases[indexPath.row]
        
        performSegue(withIdentifier: "toCaseDetailVc", sender: self)

        searchCaseTableView.deselectRow(at: indexPath, animated: true)
    }
}
