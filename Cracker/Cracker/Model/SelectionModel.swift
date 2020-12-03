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
    
    let data: [CaseDetail]
}

let searchSource = [
    SelectionModel(title: "Popular Cases", data: popularCases),
    SelectionModel(title: "Classic Cases", data: classicCases)
]
