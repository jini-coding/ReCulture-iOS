//
//  HomeViewModel.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

import UIKit

class HomeViewModel {
    // MARK: - Properties
        
    private var myProfileModel: MyProfileModel = MyProfileModel() {
        didSet {
            myProfileModelDidChange?()
        }
    }
    
    var myProfileModelDidChange: (() -> Void)?
    
    private var calendarDTO: [CalendarRecordDetail] = []
    
    private var myCalendarModelList: [Int: Int] = [:]
    
    private var myCalendarModelIsSet = false {
        didSet {
            if myCalendarModelIsSet{
                myCalendarModelDidSet?()
            }
        }
    }
    
    var myCalendarModelDidSet: (() -> Void)?
    
    // MARK: - Functions; Home Profile
    
    func getMyProfile(fromCurrentVC: UIViewController){
        NetworkManager.shared.getMyProfile() { result in
            switch result {
            case .success(let model):
                self.myProfileModel = model
                print("-- home view model --")
                print(model)
            case .failure(let error):
                print("-- home view model --")
                print(error)
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    func getNickname() -> String {
        return myProfileModel.nickname!
    }
    
    func getLevelNum() -> Int {
        return myProfileModel.levelNum!
    }
    
    func getLevelName() -> String {
        return myProfileModel.levelName!
    }
    
    func getExp() -> Int {
        return myProfileModel.exp!
    }
    
    func getProfileImage() -> String {
        return myProfileModel.profilePhoto!
    }
    
    // MARK: - Functions; Calendar
    
    func getMyCalendar(year: String, month: String, fromCurrentVC: UIViewController){
        NetworkManager.shared.getMyCalendar(year: year, month: month) { result in
            switch result {
            case .success(let dto):
                self.calendarDTO = dto
                print("-- home view model --")
                print(self.calendarDTO)
                self.countSameDayRecords()
            case .failure(let error):
                print("-- home view model --")
                print(error)
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    func getCalendarModelList() -> [Int:Int] {
        return myCalendarModelList
    }
    
    private func countSameDayRecords(){
        myCalendarModelList.removeAll()
        
        for record in calendarDTO {
            // date: 2024-06-10T03:34:56.000Z
            let date = String(record.date.split(separator: "T")[0])  // 2024-06-10
            let day = String(date.split(separator: "-")[2])  // 10 -> 현재 필요한 값!!
            print(day)
            //TODO: 여기부터
            
            let key = Int(day)!
            
            // 해당 날짜가 이미 추가돼있으면
            if myCalendarModelList[key] != nil {
                myCalendarModelList[key] = myCalendarModelList[key]! + 1
            }
            else{
                myCalendarModelList[key] = 1
            }
//            myCalendarModelList[Int(day)!] = (myCalendarModelList[Int(day)!] ?? 1) + 1
            
            print(myCalendarModelList)
        }
        
        myCalendarModelIsSet = true
    }
    
    // MARK: - Helpers
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}
