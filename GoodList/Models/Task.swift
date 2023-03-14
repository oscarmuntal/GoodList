//
//  Task.swift
//  GoodList
//
//  Created by Òscar Muntal on 14/3/23.
//

import Foundation
import CoreImage

struct Task {
    let title: String
    let priority: Priority
}

enum Priority: Int {
    case high
    case medium
    case low
}
