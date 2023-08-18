//
//  MenuItem.swift
//  LittleLemon
//
//  Created by Carlos Martínez on 08/08/23.
//

import Foundation

struct MenuItem: Decodable {
    
    let id: Int
    let title: String
    let description: String
    let price: String
    let image: String
    let category: String
}
