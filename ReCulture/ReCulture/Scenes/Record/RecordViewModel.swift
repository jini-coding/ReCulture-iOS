//
//  RecordViewModel.swift
//  ReCulture
//
//  Created by Jini on 6/13/24.
//

import UIKit

class RecordViewModel {
    // MARK: - Properties
        
    private var myRecordModel: [RecordModel] = [] {
        didSet {
            myRecordModelDidChange?()
        }
    }
    
    private var recordDetail: RecordModel? {
        didSet {
            myRecordModelDidChange?()
        }
    }
    
    private var allRecords: [RecordModel] = []  // Holds all records fetched from the server
    private var filteredRecords: [RecordModel] = []
    
    var myRecordModelDidChange: (() -> Void)?
    
    // MARK: - Functions
    
    func getmyRecords(fromCurrentVC: UIViewController){
        NetworkManager.shared.getMyRecords() { result in
            switch result {
            case .success(let models):
                self.allRecords = models // 모든 레코드를 allRecords에 저장
                self.myRecordModel = models
                print("-- my record view model --")
                print(models)
            case .failure(let error):
                print("-- my record view model --")
                print(error)
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    func getRecordDetail(at index: Int) -> RecordModel {
        return myRecordModel[index]
    }

    func getRecordDetails(recordId: Int) {
        NetworkManager.shared.getRecordDetails(recordId: recordId) { result in
            switch result {
            case .success(let model):
                self.recordDetail = model
            case .failure(let error):
                print("-- record detail view model --")
                print(error)
            }
        }
    }
    
    func getRecordDetail() -> RecordModel? {
        return recordDetail
    }
    
    func recordCount() -> Int {
        return myRecordModel.count
    }
    
    func deleteRecord(postId: Int) {
        NetworkManager.shared.deleteRecord(postId: postId) { result in
            switch result {
            case .success(let model):
                self.recordDetail = model
            case .failure(let error):
                print("-- record detail view model --")
                print(error)
            }
        }
    }
    
    func filterRecords(by category: String) {
        if category == "전체" {
            // 전체 카테고리인 경우 모든 레코드를 표시
            myRecordModel = allRecords
        } else {
            // 특정 카테고리에 해당하는 레코드만 필터링
            let categoryId = categoryId(from: category)
            myRecordModel = allRecords.filter { (record: RecordModel) -> Bool in
                return record.culture.categoryId == categoryId
            }
        }
    }
    
    private func categoryId(from category: String) -> Int {
        switch category {
        case "영화": return 1
        case "뮤지컬": return 2
        case "연극": return 3
        case "스포츠": return 4
        case "콘서트": return 5
        case "드라마": return 6
        case "독서": return 7
        case "전시회": return 8
        case "기타": return 9
        default: return 0
        }
    }
    
//    func getNickname() -> String {
//        return myRecordModel.title!
//    }
//    
//    func getEmoji() -> String {
//        return myRecordModel.emoji!
//    }
//    
//    func getDate() -> String {
//        return myRecordModel.date!
//    }
//    
//    func getCategoryId() -> Int {
//        return myRecordModel.categoryId!
//    }
//    
//    func getAuthorId() -> Int {
//        return myRecordModel.authorId!
//    }
//    
//    func getDisclosure() -> String {
//        return myRecordModel.disclosure!
//    }
//    
//    func getReview() -> String {
//        return myRecordModel.review!
//    }
//    
//    func getDetail1() -> String {
//        return myRecordModel.detail1!
//    }
//    
//    func getDetail2() -> String {
//        return myRecordModel.detail2!
//    }
//    
//    func getDetail3() -> String {
//        return myRecordModel.detail3!
//    }
//    
//    func getDetail4() -> String {
//        return myRecordModel.detail4!
//    }
//
    
    func getRecord(at index: Int) -> RecordModel {
        return myRecordModel[index]
    }
    
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}

