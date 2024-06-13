//
//  MyTicketBookDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/13/24.
//

import Foundation

struct MyTicketBookDTO: Codable {
    let id: Int
    let title: String
    let emoji: String
    let date: String
    let disclosure: String
    let review: String
    let authorId: Int
    let createdAt: String
    let updatedAt: String
    let photos: [Photo]
}

struct Photo: Codable {
    let id: Int
    let url: String
    let ticketPostId: Int
}
