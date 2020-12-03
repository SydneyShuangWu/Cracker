//
//  SelectionView.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/2.
//

import Foundation
import UIKit

protocol SelectionViewDataSource: AnyObject {
    
    func numberOfButtons(in selectionView: SelectionView) -> Int
    
    func buttonTitle(in selectionView: SelectionView, titleForButtonAt index: Int) -> String
    
    func indicatorColor(in selectionView: SelectionView) -> UIColor
    
    func buttonTitleColor(in selectionView: SelectionView) -> UIColor
    
    func buttonTitleFont(in selectionView: SelectionView) -> UIFont
}

@objc protocol SelectionViewDelegate: AnyObject {
    
    @objc optional func didSelectButton(_ selectionView: SelectionView, at index: Int)
}

class SelectionView: UIView {
    
    weak var delegate: SelectionViewDelegate? {
        
        didSet {
        }
    }
    
    // Pass returned value from controller to view
    weak var dataSource: SelectionViewDataSource? {
        
        didSet {
            createButtons()
            createIndicator()
        }
    }
    
    var buttons = [UIButton]()
    
    let screenWidth = UIScreen.main.bounds.width
    
    let indicatorView = UIView()
    
    func createButtons() {
        
        guard let numberOfButtons = dataSource?.numberOfButtons(in: self) else { return }
        
        let buttonWidth = Int(screenWidth) / numberOfButtons
        
        var tag = 0
        
        for index in 0 ..< numberOfButtons {
            
            let button = UIButton()
            button.frame = CGRect(x: buttonWidth * index, y: 0, width: buttonWidth, height: 45)
            
            guard let title = dataSource?.buttonTitle(in: self, titleForButtonAt: index) else { return }
            button.setTitle("\(title)", for: .normal)
            button.setTitleColor(dataSource?.buttonTitleColor(in: self), for: .normal)
            button.titleLabel?.font = dataSource?.buttonTitleFont(in: self)
            
            button.addTarget(nil, action: #selector(buttonDidTap), for: .touchUpInside)
            
            button.tag = tag
            
            self.addSubview(button)
            
            tag += 1
            
            buttons.append(button)
        }
    }
    
    func createIndicator() {
        
        guard let numberOfButtons = dataSource?.numberOfButtons(in: self),
              let maxY = buttons.first?.frame.maxY,
              let indicatorColor = dataSource?.indicatorColor(in: self)
        else { return }
        
        let indicatorWidth = Int(screenWidth) / numberOfButtons
        
        indicatorView.backgroundColor = indicatorColor
        
        indicatorView.frame = CGRect(x: 0, y: maxY, width: CGFloat(indicatorWidth), height: 1.5)
        
        delegate?.didSelectButton?(self, at: 0)
        
        self.addSubview(indicatorView)
    }
    
    @objc func buttonDidTap(sender: UIButton) {
        
        guard let numberOfButtons = dataSource?.numberOfButtons(in: self),
              let maxY = buttons.first?.frame.maxY
        else { return }
        
        let buttonWidth = screenWidth / CGFloat(numberOfButtons)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, animations: {
            self.indicatorView.frame = CGRect(x: sender.frame.minX, y: maxY, width: buttonWidth, height: 1.5)
        }, completion: nil)
        
        delegate?.didSelectButton?(self, at: sender.tag)
    }
}

extension SelectionViewDataSource {
    
    func indicatorColor(in selectionView: SelectionView) -> UIColor {
        
        return UIColor.O!
    }
    
    func buttonTitleColor(in selectionView: SelectionView) -> UIColor {
        
        return UIColor.O!
    }
    
    func buttonTitleFont(in selectionView: SelectionView) -> UIFont {
        
        return UIFont(name: "Gill Sans SemiBold", size: 20)!
    }
}
