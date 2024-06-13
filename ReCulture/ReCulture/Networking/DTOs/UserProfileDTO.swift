//
//  UserProfileDTO.swift
//  ReCulture
//
//  Created by Jini on 6/14/24.
//

struct UserProfileDTO: Codable {
    let id: Int
    let userId: Int
    let nickname: String
    let bio: String
    let birthdate: String
    let interest: String?
    let profilePhoto: String
    let exp: Int
    let levelId: Int
    let level: String
}
