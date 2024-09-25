//
//  BookmarkViewModel.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/25/24.
//

import UIKit

final class BookmarkViewModel {
    
    // MARK: - Properties
        
    private var bookmarkModel: BookmarkModel? {
        didSet {
            bookmarkModelDidChange?()
        }
    }
    
    var bookmarkModelDidChange: (() -> Void)?
    
    // MARK: - Functions
    
    func postBookmarkToggle(recordId: Int) {
        NetworkManager.shared.bookmarkRecord(recordId: recordId) { result in
            print("-- bookmark view model --")
            switch result {
            case .success(let model):
                self.bookmarkModel = model
                print("===== 북마크 요청 =====")
                print(model)
            case .failure(let error):
                let networkAlertController = self.networkErrorAlert(error)
                print(error.localizedDescription)
                print(error)
            }
        }
    }
    
    func getBookmarkModel() -> BookmarkModel? {
        return bookmarkModel
    }
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        return alertController
    }
}
