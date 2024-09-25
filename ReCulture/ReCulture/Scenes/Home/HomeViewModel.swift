//
//  HomeViewModel.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

import UIKit

final class HomeViewModel {
    
    // MARK: - Properties
        
    private var myProfileModel: MyProfileModel = MyProfileModel() {
        didSet {
            myProfileModelDidChange?()
        }
    }
    
    var myProfileModelDidChange: (() -> Void)?
    
    private var calendarDTO: [CalendarRecordDetail] = []
    
    private var myCalendarDataList: [MyCalendarData] = []
    private var myCalendarDataListIsSet = false {
        didSet {
            if myCalendarDataListIsSet {
                myCalendarDataListDidSet?()
            }
        }
    }
    var myCalendarDataListDidSet: (() -> Void)?
    
    // MARK: - Functions; Home Profile
    
    func getMyProfile(fromCurrentVC: UIViewController) {
        NetworkManager.shared.getMyProfile() { result in
            switch result {
            case .success(let model):
                self.myProfileModel = model
                print("-- home view model --")
                print(model)
                UserDefaults.standard.set(model.nickname, forKey: "nickname")
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
    
    func getMyCalendar(yearAndMonthFormatted: String, fromCurrentVC: UIViewController) {
        let strList = yearAndMonthFormatted.split(separator: "-")  // [0]은 2024, [1]은 9(달)
        let year = String(strList[0])
        let month = String(strList[1])
        
        NetworkManager.shared.getMyCalendar(year: year, month: month) { result in
            print("=== home view model ===")
            print("month: \(month)")
            switch result {
            case .success(let dto):
                self.calendarDTO = dto
                self.countSameDayRecordsAndSetData(year: Int(year) ?? 2024, month: Int(month) ?? 9)
            case .failure(let error):
                print(error)
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    private func countSameDayRecordsAndSetData(year: Int, month: Int) {
        // 초기화 (기록의 개수는 모두 0으로 됨)
        myCalendarDataList.removeAll()
        for i in 1...31 {
            myCalendarDataList.append(MyCalendarData(year: year, month: month, day: i, count: 0, records: []))
        }
                
        // 같은 날짜의 기록 개수 세기
        for record in calendarDTO {
            // date: 2024-06-10T03:34:56.000Z
            let recordDate = record.date.toDate()
            print(recordDate)
            if let formattedDate = recordDate?.toDashedString() {
                print(">> \(formattedDate)")
                let date = String(formattedDate.split(separator: "T")[0])  // 2024-06-10
                let day = String(date.split(separator: "-")[2])  // 10 -> 현재 필요한 값!!
                
                myCalendarDataList[Int(day)! - 1].count += 1
                myCalendarDataList[Int(day)! - 1].records.append(MyCalendarRecordDetailModel(recordId: record.id,
                                                                                             title: record.title,
                                                                                             categoryId: record.categoryId,
                                                                                             photoURL: record.photos[0].url))
            }
        }
        
        myCalendarDataListIsSet = true
    }
    
    func getMyCalendarDataList() -> [MyCalendarData] {
        return myCalendarDataList
    }
    
    // MARK: - Helpers
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}
