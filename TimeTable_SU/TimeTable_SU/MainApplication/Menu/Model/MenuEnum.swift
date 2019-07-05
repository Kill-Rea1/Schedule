//
//  MenuEnum.swift
//  Timetable
//
//  Created by Кирилл Иванов on 11/03/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import UIKit

enum Menu: Int, CustomStringConvertible {
    case schedule
    case session
    case profile
    case group
    case exit
    
    var description: String {
        switch self {
        case .schedule:
            return "Расписание"
        case .session:
            return "Сессия"
        case .profile:
            return "Профиль"
        case .group:
            return "Группа"
        case .exit:
            return "Выйти"
        }
    }
    
    var image: UIImage {
        switch self {
        case .schedule:
            return UIImage(named: "schedule") ?? UIImage()
        case .session:
            return UIImage(named: "session") ?? UIImage()
        case .profile:
            return UIImage(named: "profile") ?? UIImage()
        case .group:
            return UIImage(named: "group") ?? UIImage()
        case .exit:
            return UIImage(named: "exit") ?? UIImage()
        }
    }
}
