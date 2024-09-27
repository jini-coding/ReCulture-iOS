//
//  RecordResponseDTO.swift
//  ReCulture
//
//  Created by Jini on 6/3/24.
//

/// 탐색 탭과 내 기록탭 조회 시 사용되는 DTO (북마크가 없음)
struct AllRecordResponseDTO: Codable {
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
    
    struct PhotoDoc: Codable {
        let id: Int
        let url: String
        let culturePostId: Int
    }
}

extension AllRecordResponseDTO {
//    static func convertRecordDTOToModel(DTO: AllRecordResponseDTO) -> RecordModel {
//        return RecordModel(
//            culture: RecordModel.Culture(
//                id: DTO.id,
//                title: DTO.title,
//                emoji: DTO.emoji,
//                date: DTO.date,
//                categoryId: DTO.categoryId,
//                authorId: DTO.authorId,
//                disclosure: DTO.disclosure,
//                review: DTO.review,
//                detail1: DTO.detail1,
//                detail2: DTO.detail2,
//                detail3: DTO.detail3,
//                detail4: DTO.detail4, 
//                isBookmarked: DTO.isBookmarked
//            ),
//            photoDocs: DTO.photos.map { photoDoc in
//                RecordModel.PhotoDoc(
//                    culturePostId: photoDoc.culturePostId,
//                    url: photoDoc.url
//                )
//            }
//        )
//    }
//
//    static func convertRecordDTOsToModels(DTOs: [AllRecordResponseDTO]) -> [RecordModel] {
//        return DTOs.map { convertRecordDTOToModel(DTO: $0) }
//    }
    
    // MARK: - 내 기록 탭 관련해서 데이터 모델로 변환
    
    static func convertRecordDTOToMyRecordsModel(DTO: AllRecordResponseDTO) -> AllRecordsModel {
        return AllRecordsModel(
                culture: AllRecordsModel.Culture(
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
                AllRecordsModel.PhotoDoc(
                    culturePostId: photoDoc.culturePostId,
                    url: photoDoc.url
                )
            }
        )
    }

    static func convertRecordDTOsToMyRecordsModels(DTOs: [AllRecordResponseDTO]) -> [AllRecordsModel] {
        return DTOs.map { convertRecordDTOToMyRecordsModel(DTO: $0) }
    }
}
