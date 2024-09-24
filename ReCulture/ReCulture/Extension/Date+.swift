//
//  Date+.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/25/24.
//

import Foundation

extension Date {

    /// Date가 날짜만으로 초기화되도록 (시간, 분, 초 는 모두 0으로)
    func startOfDay() -> Date? {
        let calendar = Calendar.current

        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)

        components.hour = 0
        components.minute = 0
        components.second = 0

        return calendar.date(from: components)
    }
}
