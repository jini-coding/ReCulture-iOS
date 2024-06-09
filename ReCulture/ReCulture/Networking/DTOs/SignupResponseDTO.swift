//
//  SignupResponseDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/5/24.
//

struct SignupResponseDTO: Codable {
    let id: Int
    let accessToken: String
    let refreshToken: String
}
