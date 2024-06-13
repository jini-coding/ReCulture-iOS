//
//  MyTicketBookDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/13/24.
//

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

extension MyTicketBookDTO {
    static func convertMyTicketBookDTOToModel(DTO: MyTicketBookDTO) -> MyTicketBookModel {
        return MyTicketBookModel(
            ticketBookId: DTO.id,
            title: DTO.title,
            emoji: DTO.emoji,
            review: DTO.review,
            imageURL: DTO.photos[0].url
        )
    }

    static func convertMyTicketBookDTOsToModels(DTOs: [MyTicketBookDTO]) -> [MyTicketBookModel] {
        return DTOs.map { convertMyTicketBookDTOToModel(DTO: $0) }
    }
}
