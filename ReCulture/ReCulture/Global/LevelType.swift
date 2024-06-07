//
//  LevelType.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/8/24.
//

// 구간 별 총점
let levelTypeDict: [String: Int] = [
    "Freshman": 50,
    "Sophomore": 100,
    "Junior": 150,
    "Senior": 0,
]

enum LevelType : String {
    case Freshman
    case Sophomore
    case Junior
    case Senior
    case End
    
    static func getTotalScoreOf(_ level: LevelType) -> Int {
        return levelTypeDict[level.rawValue]!
    }
    
    static func getNextLevelOf(_ level: LevelType) -> LevelType {
        if level == .Freshman {
            return .Sophomore
        }
        else if level == .Sophomore {
            return .Junior
        }
        else if level == .Junior {
            return .Senior
        }
        else {
            return .End
        }
    }
}
