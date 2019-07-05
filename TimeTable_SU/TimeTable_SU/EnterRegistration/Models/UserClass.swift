//
//  UserClass.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 21/06/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Firebase

final class UserDB {
    var uid: String
    var email: String
    var name: String
    var university: String
    var group: String
    var isAdmin: Bool
    var ref: DatabaseReference?
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as! [String: AnyObject]
        uid = value["uid"] as! String
        email = value["email"] as! String
        name = value["name"] as! String
        university = value["university"] as! String
        group = value["group"] as! String
        isAdmin = value["isAdmin"] as! Bool
        ref = snapshot.ref
    }
    
    init(uid: String, email: String, name: String, university: String, group: String, isAdmin: Bool) {
        self.uid = uid
        self.email = email
        self.name = name
        self.university = university
        self.group = group
        self.isAdmin = isAdmin
        ref = nil
    }
    
    func convertToDictionary() -> Any {
        return ["uid": uid, "email": email, "name": name, "university": university, "group": group, "isAdmin": isAdmin]
    }
}
