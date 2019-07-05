//
//  File.swift
//  Timetable
//
//  Created by Кирилл Иванов on 05/03/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Firebase

final class Subject {
    var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df
    }()
    lazy var date: Date = {dateFormatter.date(from: self.startTime)!}()
    var subjectName: String
    var startTime: String
    var endTime: String
    var classroom: String
    var weekday: String
    var parity: String
    var subjectType: String
    var ref: DatabaseReference!
    
    init(subjectName: String, startTime: String, endTime: String, classroom: String, weekday: String, parity: String, subjectType: String){
        self.subjectName = subjectName
        self.startTime = startTime
        self.endTime = endTime
        self.classroom = classroom
        self.weekday = weekday
        self.parity = parity
        self.subjectType = subjectType
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        ref = snapshot.ref
        subjectName = snapshotValue["name"] as! String
        startTime = snapshotValue["startTime"] as! String
        endTime = snapshotValue["endTime"] as! String
        classroom = snapshotValue["classroom"] as! String
        weekday = snapshotValue["weekday"] as! String
        parity = snapshotValue["parity"] as! String
        subjectType = snapshotValue["type"] as! String
    }
    
    func convertToDictionary() -> Any {
        return ["name": subjectName, "startTime": startTime, "endTime": endTime, "classroom": classroom, "weekday": weekday, "parity": parity, "type": subjectType]
    }
}

