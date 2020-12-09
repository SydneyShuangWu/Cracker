//
//  SectionView.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/8.
//

protocol SectionViewDelegate: AnyObject {
    
    func sectionView(_ sectionView: SectionView, _ didPressTag: Int, _ isExpand: Bool)
}

import UIKit

class SectionView: UITableViewHeaderFooterView {
    
    weak var delegate: SectionViewDelegate?
    var buttonTag: Int!
    var isExpand: Bool!

    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var toggleBtn: UIButton!
    
    @IBAction func toggleSection(_ sender: Any) {
        
        self.delegate?.sectionView(self, self.buttonTag, self.isExpand)
    }
}
