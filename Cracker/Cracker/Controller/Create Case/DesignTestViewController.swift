//
//  DesignTestViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/14.
//

import UIKit
import PKHUD

class DesignTestViewController: UIViewController {
    
    var numberOfQuestion = demoRpgCase.testContent?.count
    
    var sectionTitle: [String] = []
    
    @IBOutlet weak var designTestTableView: UITableView!
    @IBOutlet weak var completeBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupNavigationBar(with: "Design Test")
        setupBackButton()
        setupCloseButton()
        
        completeBtn.setupCornerRadius()
        
        for index in 1 ... numberOfQuestion! {
            
            sectionTitle.append(String(index))
        }
        
        setupTableView()
    }
    
    func setupTableView() {
        
        designTestTableView.delegate = self
        designTestTableView.dataSource = self
    }
    
    @IBAction func backToHome(_ sender: Any) {
        
        HUD.flash(.labeledSuccess(title: nil, subtitle: "Case Created!"), delay: 0.3) { _ in
            
            self.navigateToLobby()
        }
    }
}

extension DesignTestViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return numberOfQuestion!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return tableView.frame.height * 0.08
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height * 0.08))
        
        headerView.backgroundColor = .Y
        
        let headerLabel = UILabel(frame: CGRect(x: 16, y: 0, width: UIScreen.main.bounds.width, height: tableView.frame.height * 0.08))
        
        headerLabel.text = "Question " + sectionTitle[section]
        
        headerLabel.font = UIFont(name: "Gill Sans SemiBold", size: 25)

        headerLabel.textColor = UIColor.W

        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DesignTestTBCell") as! DesignTestTBCell
        
        cell.setupCellUI()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 160
    }
}
