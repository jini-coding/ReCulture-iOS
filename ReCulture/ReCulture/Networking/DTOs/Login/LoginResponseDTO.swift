//
//  LoginResponseDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

struct LoginResponseDTO: Codable{
    let id: Int
    let accessToken: String
    let refreshToken: String
}

struct LogoutResponseDTO: Codable {
    let message: String
}
