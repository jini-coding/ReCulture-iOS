//
//  TicketResponseDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/14/24.
//

import Foundation

struct TicketResponseDTO: Codable {
    let ticket: TicketResponseDetail
    let photoDocs: [TicketPhotoDoc]
}

struct TicketResponseDetail: Codable {
    let id: Int
    let title: String
    let emoji: String
    let date: String
    let categoryId: Int
    let authorId: Int
    let disclosure: String
    let review: String
}

struct TicketPhotoDoc: Codable {
    let ticketPostId: Int
    let url: String
}
