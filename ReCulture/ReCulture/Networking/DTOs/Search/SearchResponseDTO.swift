//
//  SearchResponseDTO.swift
//  ReCulture
//
//  Created by Jini on 6/13/24.
//

struct SearchResponseDTO: Codable {
    struct Culture: Codable {
        let id: Int
        let title: String
        let emoji: String
        let date: String
        let categoryId: Int
        let authorId: Int
        let disclosure: String
        let review: String
        let detail1: String
        let detail2: String
        let detail3: String
        let detail4: String
    }
    
    struct PhotoDoc: Codable {
        let culturePostId: Int
        let url: String
    }
    
    let culture: Culture
    let photoDocs: [PhotoDoc]
}

extension SearchResponseDTO {
    static func convertSearchRecordDTOToModel(DTO: SearchResponseDTO) -> SearchModel {
        return SearchModel(
            id: DTO.culture.id,
            title: DTO.culture.title,
            emoji: DTO.culture.emoji,
            date: DTO.culture.date,
            categoryId: DTO.culture.categoryId,
            authorId: DTO.culture.authorId,
            disclosure: DTO.culture.disclosure,
            review: DTO.culture.review,
            detail1: DTO.culture.detail1,
            detail2: DTO.culture.detail2,
            detail3: DTO.culture.detail3,
            detail4: DTO.culture.detail4
        )
    }

    static func convertRecordDTOsToModels(DTOs: [SearchResponseDTO]) -> [SearchModel] {
        return DTOs.map { convertSearchRecordDTOToModel(DTO: $0) }
    }
}

