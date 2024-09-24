//
//  SearchResponseDTO.swift
//  ReCulture
//
//  Created by Jini on 6/13/24.
//

struct SearchResponseDTO: Codable {
    let data: [SearchRecordDTO]
    let pagination: Pagination

    struct SearchRecordDTO: Codable {
        let id: Int
        let title: String
        let emoji: String?
        let date: String?
        let categoryId: Int
        let disclosure: String?
        let review: String?
        let detail1: String?
        let detail2: String?
        let detail3: String?
        let detail4: String?
        let authorId: Int
        let createdAt: String
        let updatedAt: String
        
        let photos: [PhotoDoc]?

        struct PhotoDoc: Codable {
            let id: Int
            let url: String
            let culturePostId: Int
        }
    }

    struct Pagination: Codable {
        let currentPage: Int
        let pageSize: Int
        let totalPages: Int
        let totalCultures: Int
    }
}

extension SearchResponseDTO {
    static func convertSearchRecordDTOToModel(DTO: SearchRecordDTO) -> SearchModel {
        return SearchModel(
            // Map basic properties
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
            
            photos: DTO.photos?.map { photoDTO in
                SearchModel.PhotoModel(
                    id: photoDTO.id,
                    url: photoDTO.url,
                    culturePostId: photoDTO.culturePostId
                )
            } ?? []
        )
    }

    static func convertSearchRecordDTOsToModels(DTOs: [SearchRecordDTO]) -> [SearchModel] {
        return DTOs.map { convertSearchRecordDTOToModel(DTO: $0) }
    }
}

