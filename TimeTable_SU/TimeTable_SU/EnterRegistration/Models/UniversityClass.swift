//
//  University.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 22/06/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Firebase

final class University {
    var name: String
    var ref: DatabaseReference!
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as! [String: AnyObject]
        name = value["name"] as! String
        ref = snapshot.ref
    }
    
    init(name: String) {
        self.name = name
        self.ref = nil
    }
}
