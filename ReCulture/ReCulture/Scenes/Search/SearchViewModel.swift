//
//  SearchViewModel.swift
//  ReCulture
//
//  Created by Jini on 6/13/24.
//

import UIKit

class SearchViewModel {
    // MARK: - Properties
        
    private var allRecordModel: [RecordModel] = [] {
        didSet {
            allRecordModelDidChange?()
        }
    }
    
    var allRecordModelDidChange: (() -> Void)?
    
    // MARK: - Functions
    
    func getAllRecords(fromCurrentVC: UIViewController){
        NetworkManager.shared.getAllRecords() { result in
            switch result {
            case .success(let models):
                self.allRecordModel = models
                print("-- all record view model --")
                print(models)
            case .failure(let error):
                print("-- all record view model --")
                print(error)
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    func recordCount() -> Int {
        return allRecordModel.count
    }
    
    func getRecord(at index: Int) -> RecordModel {
        return allRecordModel[index]
    }
//    
//    func getTitle() -> String {
//        return allRecordModel.title!
//    }
//
//    func getEmoji() -> String {
//        return allRecordModel.emoji!
//    }
//
//    func getDate() -> String {
//        return allRecordModel.date!
//    }
//
//    func getCategoryId() -> Int {
//        return allRecordModel.categoryId!
//    }
//
//    func getAuthorId() -> Int {
//        return allRecordModel.authorId!
//    }
//
//    func getDisclosure() -> String {
//        return allRecordModel.disclosure!
//    }
//
//    func getReview() -> String {
//        return allRecordModel.review!
//    }
//
//    func getDetail1() -> String {
//        return allRecordModel.detail1!
//    }
//
//    func getDetail2() -> String {
//        return allRecordModel.detail2!
//    }
//
//    func getDetail3() -> String {
//        return allRecordModel.detail3!
//    }
//
//    func getDetail4() -> String {
//        return allRecordModel.detail4!
//    }


    
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}


