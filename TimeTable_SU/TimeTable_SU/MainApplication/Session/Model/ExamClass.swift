//
//  ExamClass.swift
//  TimeTable_SU
//
//  Created by Кирилл Иванов on 03/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Firebase

final class Exam {
    var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd MMMM"
        return df
    }()
    var name: String
    var classroom: String
    var date: String
    var time: String
    var type: String
    lazy var dateType: Date = { dateFormatter.date(from: self.date)! }()
    var ref: DatabaseReference!
    
    init(snapshot: DataSnapshot) {
        let values = snapshot.value as! [String: AnyObject]
        name = values["name"] as! String
        classroom = values["classroom"] as! String
        date = values["date"] as! String
        time = values["time"] as! String
        type = values["type"] as! String
        ref = snapshot.ref
    }
    
    init(name: String, classroom: String, date: String, time: String, type: String) {
        self.name = name
        self.classroom = classroom
        self.date = date
        self.time = time
        self.type = type
        ref = nil
    }
    
    func convertToDictionary() -> Any {
        return ["name": name, "classroom": classroom, "date": date, "time": time, "type": type]
    }
}

