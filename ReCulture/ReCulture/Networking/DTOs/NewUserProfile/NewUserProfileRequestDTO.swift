//
//  NewUserProfileRequestDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

struct NewUserProfileRequestDTO: Codable {
    let nickname: String
    let bio: String
    let birthdate: String
    let interests: String
    let profilePhoto: String
}
