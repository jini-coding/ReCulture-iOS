//
//  TicketBookViewModel.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/14/24.
//

import UIKit

class TicketBookViewModel {
    
    // MARK: - Properties
    
    private var myTicketBookList: [MyTicketBookModel] = [] {
        didSet {
            myTicketBookListDidChange?()
        }
    }
      
    var myTicketBookListDidChange: (() -> Void)?
    
    // MARK: - Function
    
    func getMyTicketBook(fromCurrentVC: UIViewController){
        NetworkManager.shared.getMyTicketBook() { result in
            switch result {
            case .success(let models):
                self.myTicketBookList = models
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
    
    func getMyTicketBookCount() -> Int {
        return myTicketBookList.count
    }
    
    func getMyTicketBookDetailAt(_ index: Int) -> MyTicketBookModel {
        return myTicketBookList[index]
    }
    
    // MARK: - Helpers
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}
