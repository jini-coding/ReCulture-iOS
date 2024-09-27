//
//  BookmarkListDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/8/24.
//

import Foundation

struct BookmarkListDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: [BookmarkListItem]
}

struct BookmarkListItem: Codable {
    let id: Int
    let userId: Int
    let postId: Int
    let createdAt: String
    let updatedAt: String
    let post: BookmarkPost
}

struct BookmarkPost: Codable {
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
    let photos: [BookmarkPhoto]
    let author: BookmarkAuthor
}

struct BookmarkPhoto: Codable {
    let id: Int
    let url: String
    let culturePostId: Int
}

struct BookmarkAuthor: Codable {
    let id: Int
    let email: String
    let profile: BookmarkAuthorProfile
}

struct BookmarkAuthorProfile: Codable {
    let id: Int
    let userId: Int
    let nickname: String
    let bio: String
    let birthdate: String
    let interest: String
    let profilePhoto: String
    let exp: Int
    let levelId: Int
    let level: String
}

extension BookmarkListDTO {
    static func convertBookmarkListDTOToModel(DTO: BookmarkListItem) -> BookmarkListModel {
        return BookmarkListModel(postId: DTO.postId,
                             title: DTO.post.title,
                             postOwnerId: DTO.post.authorId,
                             postOwnerNickname: DTO.post.author.profile.nickname, 
                             postOwnerProfileImage: DTO.post.author.profile.profilePhoto,
                             date: DTO.post.date,
                             categoryType: RecordType(categoryId: DTO.post.categoryId) ?? .movie,
                             firstImageURL: DTO.post.photos[0].url)
    }

    static func convertBookmarkListDTOsToModels(DTOs: [BookmarkListItem]) -> [BookmarkListModel] {
        return DTOs.map { convertBookmarkListDTOToModel(DTO: $0) }
    }
}
