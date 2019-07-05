//
//  File.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 03/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Firebase

final class Exam {
    var name: String
    var classroom: String
    var date: String
    var time: String
    var ref: DatabaseReference!
    
    init(snapshot: DataSnapshot) {
        let values = snapshot.value as! [String: AnyObject]
        name = values["name"] as! String
        classroom = values["classroom"] as! String
        date = values["date"] as! String
        time = values["time"] as! String
        ref = snapshot.ref
    }
    
    init(name: String, classroom: String, date: String, time: String) {
        self.name = name
        self.classroom = classroom
        self.date = date
        self.time = time
        ref = nil
    }
    
    func convertToDictionary() -> Any {
        
    }
}
