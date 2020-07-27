//
//  Category.swift
//  Todoey
//
//  Created by Zeynep on 6.07.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
    
}

