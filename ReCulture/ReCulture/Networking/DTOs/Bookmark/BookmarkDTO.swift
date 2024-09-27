//
//  BookmarkDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/25/24.
//

import Foundation

struct BookmarkDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: BookmarkData
}

struct BookmarkData: Codable {
    let added: Bool
    let bookmark: BookmarkIdData
}

struct BookmarkIdData: Codable {
    let id: Int
    let userId: Int
    let postId: Int
    let createdAt: String
    let updatedAt: String
}

extension BookmarkDTO {
    static func convertBookmarkDTOToModel(DTO: BookmarkDTO) -> BookmarkModel {
        return BookmarkModel(success: DTO.success,
                             isBookmarked: DTO.data.added,
                             recordId: DTO.data.bookmark.postId)
    }
}
