//
//  Item.swift
//  Todoey
//
//  Created by Zeynep on 6.07.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var string: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
