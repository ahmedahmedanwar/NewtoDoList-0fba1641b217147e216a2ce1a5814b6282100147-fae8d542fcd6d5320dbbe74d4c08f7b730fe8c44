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
    
    @objc dynamic   var name: String = ""
     @objc dynamic   var color:String =  ""
    var items = List<Items>()
     
}



