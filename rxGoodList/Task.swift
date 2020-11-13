//
//  Task.swift
//  rxGoodList
//
//  Created by Jad Messadi on 11/13/20.
//

import Foundation

enum Priority: Int {
    case low
    case medium
    case high
}

struct Task {
   var title : String
    var priority : Priority
}
