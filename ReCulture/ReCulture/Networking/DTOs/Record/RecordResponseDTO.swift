//
//  RecordResponseDTO.swift
//  ReCulture
//
//  Created by Jini on 6/3/24.
//


struct RecordResponseDTO: Codable {
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
    
//    struct Culture: Codable {
//        let id: Int
//        let title: String
//        let emoji: String
//        let date: String
//        let categoryId: Int
//        let disclosure: String
//        let review: String
//        let detail1: String
//        let detail2: String
//        let detail3: String
//        let detail4: String
//        let authorId: Int
//        let createdAt: String
//        let updatedAt: String
//    }
    
    struct PhotoDoc: Codable {
        let id: Int
        let url: String
        let culturePostId: Int
    }
    
//    let culture: Culture
//    let photos: [PhotoDoc]
}

extension RecordResponseDTO {
    static func convertRecordDTOToModel(DTO: RecordResponseDTO) -> RecordModel {
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
                detail4: DTO.detail4
            ),
            photoDocs: DTO.photos.map { photoDoc in
                RecordModel.PhotoDoc(
                    culturePostId: photoDoc.culturePostId,
                    url: photoDoc.url
                )
            }
        )
    }

    static func convertRecordDTOsToModels(DTOs: [RecordResponseDTO]) -> [RecordModel] {
        return DTOs.map { convertRecordDTOToModel(DTO: $0) }
    }
}
