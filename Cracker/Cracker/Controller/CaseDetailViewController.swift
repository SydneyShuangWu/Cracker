//
//  CaseDetailViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/4.
//

import UIKit

class CaseDetailViewController: UIViewController {
    
    @IBOutlet weak var caseDetailTableView: UITableView!
    
    @IBOutlet weak var crackCaseBtn: UIButton!
    
    // Data holder for cases from SearchCaseVC
    var selectedCase: MockCase?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTableView()
        
        crackCaseBtn.setupCornerRadius()
        
        setupNavigationBar(with: selectedCase!.name)
        setupCloseButton()
        setupBackButton()
    }
    
    func setupTableView() {
        
        caseDetailTableView.delegate = self
        caseDetailTableView.dataSource = self
    }
}

extension CaseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let caseImageCell = tableView.dequeueReusableCell(withIdentifier: "CaseImageTBCell") as! CaseImageTBCell
        let caseIntroCell = tableView.dequeueReusableCell(withIdentifier: "CaseIntroTBCell") as! CaseIntroTBCell
        let caseScoreCell = tableView.dequeueReusableCell(withIdentifier: "CaseScoreTBCell") as! CaseScoreTBCell
        let caseDescriptionCell = tableView.dequeueReusableCell(withIdentifier: "CaseDescriptionTBCell") as! CaseDescriptionTBCell
        
        switch indexPath.row {
        
        case 0:
            caseImageCell.setupCaseImageWith(cases: selectedCase!)
            return caseImageCell
            
        case 1:
            caseIntroCell.setupCaseLocationWith(cases: selectedCase!)
            return caseIntroCell
            
        case 2:
            caseIntroCell.setupCaseTimeWith(cases: selectedCase!)
            return caseIntroCell
            
        case 3:
            caseIntroCell.setupCaseDurationWith(cases: selectedCase!)
            return caseIntroCell
            
        case 4:
            caseIntroCell.setupCaseHeadCountWith(cases: selectedCase!)
            return caseIntroCell
            
        case 5:
            caseScoreCell.setupCaseScoreWith(cases: selectedCase!)
            return caseScoreCell
            
        default:
            caseDescriptionCell.setupCaseDescriptionWith(cases: selectedCase!)
            return caseDescriptionCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        
        case 0:
            return 220
        case 6:
            return UITableView.automaticDimension
        default:
            return 40
        }
    }    
}