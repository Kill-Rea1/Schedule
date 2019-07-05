//
//  StudentClass.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 03/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Firebase

final class Student {
    var name: String
    var email: String
    var uid: String
    var isAdmin: Bool
    var ref: DatabaseReference!
    
    init(snapshot: DataSnapshot) {
        let values = snapshot.value as! [String: AnyObject]
        name = values["name"] as! String
        email = values["email"] as! String
        uid = values["uid"] as! String
        isAdmin = values["isAdmin"] as! Bool
        ref = snapshot.ref
    }
    
    init(name: String, email: String, uid: String, isAdmin: Bool) {
        self.name = name
        self.email = email
        self.uid = uid
        self.isAdmin = isAdmin
        ref = nil
    }    
}
