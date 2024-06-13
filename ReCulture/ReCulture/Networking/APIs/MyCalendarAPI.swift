//
//  MyCalendarAPI.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/13/24.
//

struct MyCalendarAPI: ServableAPI {
    typealias Response = MyCalendarDTO
    
    var year: String
    var month: String
    
    var method: HTTPMethod { .get }
    var path: String { "/culture/my-calendar" }
    var queryParams: [String : String]? { ["year" : year, "month" : month] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
    
}
