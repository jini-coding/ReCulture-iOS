//
//  FollowAPI.swift
//  ReCulture
//
//  Created by Jini on 6/14/24.
//

struct FollowerAPI: ServableAPI {
    typealias Response = [FollowDTO]
    
    var method: HTTPMethod { .get }
    var path: String { "/follow/followers" }
    var parameters: [String: String] { return [:] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}

struct FollowingAPI: ServableAPI {
    typealias Response = [FollowDTO]
    
    var method: HTTPMethod { .get }
    var path: String { "/follow/followings" }
    var parameters: [String: String] { return [:] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}
