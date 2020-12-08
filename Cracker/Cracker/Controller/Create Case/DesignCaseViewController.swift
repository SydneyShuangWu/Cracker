//
//  DesignCaseViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/8.
//

import UIKit

class DesignCaseViewController: UIViewController {
    
    var selectedCaseCategory: CaseCategory?
    var sectionDataList: [Int] = []
    var isExpandList: [Bool] = []
    
    // MARK: - Mock Data
    let linearSectionCount = testLinearCase.stageContent?.count
    let RpgSectionCount = testRpgCase.charContent?.count
    
    @IBOutlet weak var designCaseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar(with: "Design Your Case")
        setupBackButton()
        setupCloseButton()
        
        setupTableView()
        registerNib()
        
        for index in 1...linearSectionCount! {
            
            sectionDataList.append(index)
            isExpandList.append(false)
        }
        
        for index in 1...RpgSectionCount! {
            
            sectionDataList.append(index)
            isExpandList.append(false)
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
}

extension DesignCaseViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if selectedCaseCategory == CaseCategory.linear {
            return linearSectionCount!
        }
        
        return RpgSectionCount!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isExpandList[section] == true ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let stageCell = tableView.dequeueReusableCell(withIdentifier: "StageViewCell") as? StageViewCell
        
        let rpgCell = tableView.dequeueReusableCell(withIdentifier: "RPGViewCell") as? RPGViewCell
        
        if selectedCaseCategory == CaseCategory.linear {
            return stageCell ?? UITableViewCell()
        }
        
        return rpgCell ?? UITableViewCell()
    }
}

extension DesignCaseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 700
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
            sectionView.sectionTitle.text = "Stage" + "\(sectionDataList[section])"
        } else {
            sectionView.sectionTitle.text = "Character" + "\(sectionDataList[section])"
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
