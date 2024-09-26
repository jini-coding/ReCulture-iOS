//
//  AllRecordsResponseDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/27/24.
//

import Foundation

/// 특정 기록을 상세 조회할 때 사용되는 DTO (북마크가 포함돼있음)
struct RecordDetailResponseDTO: Codable {
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

    let photos: [PhotoDoc]
    
    let Bookmark: [BookmarkIdData]
    let isBookmarked: Bool

    struct PhotoDoc: Codable {
        let id: Int
        let url: String
        let culturePostId: Int
    }
}

extension RecordDetailResponseDTO {
    static func convertRecordDTOToModel(DTO: RecordDetailResponseDTO) -> RecordModel {
        return RecordModel(
            culture: RecordModel.Culture(
                id: DTO.id,
                title: DTO.title,
                emoji: DTO.emoji,
                date: DTO.date,
                categoryId: DTO.categoryId,
                authorId: DTO.authorId,
                disclosure: DTO.disclosure,
                review: DTO.review,
                detail1: DTO.detail1,
                detail2: DTO.detail2,
                detail3: DTO.detail3,
                detail4: DTO.detail4,
                isBookmarked: DTO.isBookmarked
            ),
            photoDocs: DTO.photos.map { photoDoc in
                RecordModel.PhotoDoc(
                    culturePostId: photoDoc.culturePostId,
                    url: photoDoc.url
                )
            }
        )
    }

    static func convertRecordDTOsToModels(DTOs: [RecordDetailResponseDTO]) -> [RecordModel] {
        return DTOs.map { convertRecordDTOToModel(DTO: $0) }
    }
}
