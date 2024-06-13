//
//  NewUserProfileResponseDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

import Foundation

struct NewUserProfileResponseDTO: Codable {
    let id: Int
    let userId: Int
    let nickname, bio, birthdate, interest: String
    let profilePhoto: String
    let exp: Int
    let levelId: Int
    let level: String
}
