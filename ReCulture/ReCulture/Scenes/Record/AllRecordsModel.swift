//
//  MyRecordsModel.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/27/24.
//

import Foundation

/// 내 기록 탭에서 보여주는 기록들의 데이터 모델
struct AllRecordsModel {
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
    }
    
    struct PhotoDoc {
        let culturePostId: Int
        let url: String
    }
    
    let culture: Culture
    let photoDocs: [PhotoDoc]
}
