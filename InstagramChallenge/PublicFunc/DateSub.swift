//
//  dateSub.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import Foundation

public func dateSub(date: String) -> String {
    let currentDate = Date().addingTimeInterval(9 * 3600)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let dateChangeFormat = formatter.date(from: date)!
    
    let seconds: Int = Int(currentDate.timeIntervalSince(dateChangeFormat))
    if seconds < 60 {
        return "\(seconds)초 전"
    }

    let minutes = seconds / 60
    if minutes < 60 {
        return "\(minutes)분 전"
    }

    let hour = minutes / 60
    if hour < 24 {
        return "\(hour)시간 전"
    }
    
    let day = hour / 24
    if day < 30 {
        return "\(day)일 전"
    }
    
    formatter.dateFormat = "MM월 dd일"
    let date = formatter.string(from: dateChangeFormat)
    
    return date
}
