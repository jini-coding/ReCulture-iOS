//
//  MyTicketBookAPI.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/13/24.
//


struct MyTicketBookAPI: ServableAPI {
    typealias Response = MyTicketBookDTO
    
    var method: HTTPMethod { .get }
    var path: String { "/ticket/my-ticket" }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}
