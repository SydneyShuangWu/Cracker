//
//  SelectionModel.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/3.
//

import Foundation
import UIKit

struct SelectionModel {
    
    let title: String
    
    let data: [MockCase]
}

let searchSource = [
    SelectionModel(title: "Popular Cases", data: popularCases),
    SelectionModel(title: "Classic Cases", data: classicCases)
]

let profileSource = [
    SelectionModel(title: "\(crackedCases.count)" + " Cracked", data: crackedCases),
    SelectionModel(title: "\(createdCases.count)" + " Created", data: createdCases),
    SelectionModel(title: "\(treasuredCases.count)" + " Treasured", data: treasuredCases)
]
