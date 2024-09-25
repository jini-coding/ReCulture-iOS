//
//  RecordModel.swift
//  ReCulture
//
//  Created by Jini on 6/13/24.
//

//struct RecordModel {
//    var id: Int
//    var title: String?
//    var emoji: String?
//    var date: String?
//    var categoryId: Int?
//    var authorId: Int?
//    var disclosure: String?
//    var review: String?
//    var detail1: String?
//    var detail2: String?
//    var detail3: String?
//    var detail4: String?
//}

struct RecordModel {
    struct Culture {
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
        let isBookmarked: Bool
    }
    
    struct PhotoDoc {
        let culturePostId: Int
        let url: String
    }
    
    let culture: Culture
    let photoDocs: [PhotoDoc]
}
