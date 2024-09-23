//
//  SearchModel.swift
//  ReCulture
//
//  Created by Jini on 6/13/24.
//

struct SearchModel {
    var id: Int?
    var title: String?
    var emoji: String?
    var date: String?
    var categoryId: Int?
    var authorId: Int?
    var disclosure: String?
    var review: String?
    var detail1: String?
    var detail2: String?
    var detail3: String?
    var detail4: String?
    
    var photos: [PhotoModel]?
    
    struct PhotoModel {
        var id: Int?
        var url: String?
        var culturePostId: Int?
    }
}

extension SearchModel {
    static func fromDTO(dto: SearchResponseDTO.SearchRecordDTO) -> SearchModel {
        return SearchModel(
            id: dto.id,
            title: dto.title,
            emoji: dto.emoji,
            date: dto.date,
            categoryId: dto.categoryId,
            authorId: dto.authorId,
            disclosure: dto.disclosure,
            review: dto.review,
            detail1: dto.detail1,
            detail2: dto.detail2,
            detail3: dto.detail3,
            detail4: dto.detail4,
            photos: dto.photos.map { photoDTO in
                PhotoModel(
                    id: photoDTO.id,
                    url: photoDTO.url,
                    culturePostId: photoDTO.culturePostId
                )
            }
        )
    }
}



