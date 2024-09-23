//
//  LevelType.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/8/24.
//

// 구간 별 총점
let levelTypeDict: [String: Int] = [
    "초보 탐험가": 50,
    "숙련된 모험가": 100,
    "정복자": 150,
    "전설의 탐험가": 0,
]

enum LevelType: String {
    case NoviceExplorer = "초보 탐험가"
    case SkilledAdventurer = "숙련된 모험가"
    case Conqueror = "정복자"
    case LegendaryExplorer = "전설의 탐험가"
    case End
    
    static func getTotalScoreOf(_ level: LevelType) -> Int {
        return levelTypeDict[level.rawValue]!
    }
    
    static func getNextLevelOf(_ level: LevelType) -> LevelType {
        if level == .NoviceExplorer {
            return .SkilledAdventurer
        }
        else if level == .SkilledAdventurer {
            return .Conqueror
        }
        else if level == .Conqueror {
            return .LegendaryExplorer
        }
        else {
            return .End
        }
    }
    
    /// 레벨 숫자를 통해 레벨타입을 가져오는 메소드
    static func getLevelTypeByLevelNum(_ num: Int) -> LevelType {
        switch num {
        case 1: return .NoviceExplorer
        case 2: return .SkilledAdventurer
        case 3: return .Conqueror
        case 4: return .LegendaryExplorer
        default: return .End
        }
    }
}
