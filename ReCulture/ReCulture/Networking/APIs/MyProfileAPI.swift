//
//  MyProfileAPI.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

struct MyProfileAPI: ServableAPI {
    typealias Response = MyProfileDTO
        
    var method: HTTPMethod { .get }
    var path: String { "/profile/my-profile" }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}
