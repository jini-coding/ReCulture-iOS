//
//  DisclosureType.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/12/24.
//

import Foundation

enum DisclosureType: String {
    case Public = "PUBLIC"
    case Private = "PRIVATE"
    case Follower = "FOLLOWER"
    
    static func getDisclosureTypeByKorean(_ string: String) -> DisclosureType {
        switch string {
        case "공개": return .Public
        case "팔로워": return .Follower
        default: return .Private
        }
    }
    
    static func getKoreanByDisclosureType(_ type: DisclosureType) -> String {
        switch type {
        case .Public: return "공개"
        case .Follower: return "팔로워"
        default: return "비공개"
        }
    }
    
    func getKorean() -> String {
        switch self {
        case .Public: return "공개"
        case .Follower: return "팔로워"
        default: return "비공개"
        }
    }
}
