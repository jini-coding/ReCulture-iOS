//
//  FollowAPI.swift
//  ReCulture
//
//  Created by Jini on 6/14/24.
//

struct FollowerAPI: ServableAPI {
    typealias Response = [FollowerDTO]
    
    var method: HTTPMethod { .get }
    var path: String { "/follow/followers" }
    var parameters: [String: String] { return [:] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}

struct FollowingAPI: ServableAPI {
    typealias Response = [FollowingDTO]
    
    var method: HTTPMethod { .get }
    var path: String { "/follow/followings" }
    var parameters: [String: String] { return [:] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}

struct pendingAPI: ServableAPI {
    typealias Response = [FollowStateDTO]
    
    var method: HTTPMethod { .get }
    var path: String { "/follow/pending" }
    var parameters: [String: String] { return [:] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}

struct sendRequestAPI: ServableAPI {
    typealias Response = [FollowStateDTO]
    
    var method: HTTPMethod { .post }
    var path: String { "/follow/request" }
    var parameters: [String: String] { return [:] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}

struct acceptAPI: ServableAPI {
    typealias Response = FollowStateDTO
    
    let id: Int
    
    var method: HTTPMethod { .post }
    var path: String { "/follow/accept/\(id)" }
    var parameters: [String: String] { return [:] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}


struct denyAPI: ServableAPI {
    typealias Response = FollowStateDTO
    
    let id: Int
    
    var method: HTTPMethod { .post }
    var path: String { "/follow/reject/\(id)" }
    var parameters: [String: String] { return [:] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}
