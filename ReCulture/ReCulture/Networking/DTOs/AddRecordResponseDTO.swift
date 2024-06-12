//
//  AddRecordResponseDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/12/24.
//

import Foundation

struct AddRecordResponseDTO: Codable {
    let culture: Culture
    let photoDocs: [PhotoDoc]
}

struct Culture: Codable {
    let id: Int
    let title: String
    let emoji: String
    let date: String
    let categoryId: Int
    let disclosure: String
    let review: String
    let detail1: String
    let detail2: String
    let detail3: String
    let detail4: String
    let authorId: Int
    let createdAt: String
    let updatedAt: String
}

struct PhotoDoc: Codable {
    let culturePostId: Int
    let url: String
}
