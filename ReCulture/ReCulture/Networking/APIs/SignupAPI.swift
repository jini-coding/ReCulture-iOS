//
//  SignupAPI.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/5/24.
//

struct SignupAPI: ServableAPI {
    typealias Response = SignupResponseDTO
    
    let requestDTO: SignupRequestDTO
    
    var method: HTTPMethod { .post }
    var path: String { "/auth/register" }
    var headers: [String : String]? { ["Content-Type": "application/json"] }
    var requestBody: Encodable? { requestDTO }
}
