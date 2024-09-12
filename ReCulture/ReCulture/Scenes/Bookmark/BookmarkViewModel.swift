//
//  BookmarkViewModel.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/8/24.
//

import UIKit

final class BookmarkViewModel {
    
    // MARK: - Properties
    
    private var bookmarkList: [BookmarkModel] = [] {
        didSet {
            bookmarkListDidChange?()
        }
    }
      
    var bookmarkListDidChange: (() -> Void)?
    
    // MARK: - Function
    
    func getBookmarkList(fromCurrentVC: UIViewController) {
        NetworkManager.shared.getBookmarkList() { result in
            switch result {
            case .success(let models):
                self.bookmarkList = models
                print("===== 북마크 조회 =====")
                print(models)
            case .failure(let error):
                print(error)
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    func getBookmarkCount() -> Int {
        return bookmarkList.count
    }
    
    func getBookmarkAt(_ index: Int) -> BookmarkModel {
        return bookmarkList[index]
    }
    
    // MARK: - Helpers
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}
