//
//  Category.swift
//  toDoList
//
//  Created by Ahmed on 11/10/19.
//  Copyright © 2019 z510. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    
    @objec dynamic var name: String = ""
    
    let items = list <Items>()
    
}
