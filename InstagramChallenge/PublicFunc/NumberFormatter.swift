//
//  NumberFormatter.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/28.
//

import Foundation

public func numberFormatter(number: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    return numberFormatter.string(from: NSNumber(value: number))!
}
