//
//  RecordPlaceholders.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/17/24.
//

import Foundation

final class RecordPlaceholders {
    
    static private let placeholderDict: [RecordType: [[String]]] = [
        .movie: [["영화 이름", "어떤 영화인가요?"],
                  ["출연진 및 감독", "출연진 및 감독을 적어주세요"],
                  ["장르", "어떤 장르의 영화인가요?"]],
        .musical: [["작품명", "어떤 뮤지컬인가요?"],
                    ["극장", "어디에서 보셨나요?"],
                    ["캐스팅", "출연자를 작성해주세요"]],
        .play: [["작품명", "어떤 연극인가요?"],
                 ["공연장", "어디에서 보셨나요?"],
                 ["캐스팅", "출연자를 작성해주세요"]],
        .sports: [["스포츠 종류", "어떤 스포츠인가요?"],
                   ["장소 및 상대팀", "어디에서, 누가 한 경기인가요?"],
                   ["경기 결과", "경기 결과를 입력해주세요"],
                   ["선발 라인업", "선발 라인업을 입력해주세요"]],
        .concert: [["공연명", "어떤 공연인가요?"],
                    ["공연장", "어디에서 한 공연인가요?"],
                    ["출연진/연주자", "출연진/연주자를 입력해주세요"],
                    ["셋리스트", "셋리스트/프로그램을 입력해주세요"]],
        .drama: [["제목", "어떤 드라마인가요?"],
                  ["장르", "어떤 장르의 드라마인가요?"],
                  ["출연진 및 감독", "출연진, 감독을 입력해주세요"]],
        .book: [["책 이름", "어떤 책인가요?"],
                 ["저자", "누구의 책인가요?"],
                 ["독서 기간", "언제부터 언제까지 읽으셨나요?"],
                 ["인상깊은 구절", "인상깊은 구절을 입력해주세요"]],
        .exhibition: [["주제", "어떤 전시회인가요?"],
                       ["장소", "어디에서 열렸나요?"],
                       ["인상깊은 전시물", "인상깊은 전시물을 입력해주세요"]],
        .etc: [["내용", "무엇을 했나요?"],
                ["장소", "어디에서 했나요?"],
                ["함께한 사람들", "누구와 했나요?"]]
    ]
    
    /// 해당 카테고리 종류의 기록에 들어가야 하는 내용 종류를 리턴합니다. (ex. 공연명, 공연장 등)
    static func getTitlesByRecordType(_ type: RecordType) -> [String] {
        if let placeholders = placeholderDict[type] {
            return placeholders.map { $0[0] }
        }
        else {
            return []
        }
    }
    
    /// 해당 카테고리 종류의 기록에 해당하는 내용 종류와 placholder를 모두 리턴합니다.
    static func getTitlesAndPlaceholdersByRecordType(_ type: RecordType) -> [[String]] {
        if let placeholders = placeholderDict[type] {
            return placeholders
        }
        else {
            return []
        }
    }
}
