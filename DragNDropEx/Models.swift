//
//  Models.swift
//  DragNDropEx
//
//  Created by Amisha I on 23/08/22.
//

import Foundation

struct Food {
    let id: Int
    let name: String
    let price: Int
    let image: String
}


struct User {
    let id: Int
    let name: String
    let image: String
    var amount: Int
    var items: Int
    var isHighlighted: Bool = false
}
