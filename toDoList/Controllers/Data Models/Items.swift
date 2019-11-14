//
//  Items.swift
//  toDoList
//
//  Created by Ahmed on 11/10/19.
//  Copyright © 2019 z510. All rights reserved.
//

import Foundation
import RealmSwift

class Items: Object {
    
    @objc dynamic  var title :String = ""
    
    @objc dynamic var done:Bool = false
   
        @objc dynamic  var dateCreated : Date?

    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
