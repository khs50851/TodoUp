//
//  MyColor.swift
//  TodoUp
//
//  Created by user on 2023/04/08.
//

import UIKit

enum MyColor: Int64 {
    case yellow = 1
    case green = 2
    case blue = 3
    case pink = 4
    
    var backgoundColor: UIColor {
        switch self {
        case .yellow:
            return UIColor(red: 252/255, green: 235/255, blue: 185/255, alpha: 1)
        case .green:
            return UIColor(red: 221/255, green: 240/255, blue: 178/255, alpha: 1)
        case .blue:
            return UIColor(red: 216/255, green: 230/255, blue: 243/255, alpha: 1)
        case .pink:
            return UIColor(red: 245/255, green: 204/255, blue: 204/255, alpha: 1)
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .yellow:
            return UIColor(red: 248/255, green: 206/255, blue: 80/255, alpha: 1)
        case .green:
            return UIColor(red: 143/255, green: 206/255, blue: 0/255, alpha: 1)
        case .blue:
            return UIColor(red: 61/255, green: 133/255, blue: 198/255, alpha: 1)
        case .pink:
            return UIColor(red: 232/255, green: 128/255, blue: 128/255, alpha: 1)
        }
    }
}


