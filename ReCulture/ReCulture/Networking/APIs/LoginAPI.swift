//
//  LoginAPI.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

struct LoginAPI: ServableAPI {
    typealias Response = LoginResponseDTO
    
    let requestDTO: LoginRequestDTO
    
    var method: HTTPMethod { .post }
    var path: String { "/auth/login" }
    var headers: [String : String]? { ["Content-Type": "application/json"] }
    var requestBody: Encodable? { requestDTO }
}
