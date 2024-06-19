//
//  TicketRequestDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/14/24.
//

struct TicketRequestDTO: Codable {
    let title: String
    let emoji: String
    let date: String
    let categoryId: Int
    let disclosure: String
    let review: String
}
