//
//  TokenData.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/03.
//

import Foundation

struct UserResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: UserResponseResult?
}

struct UserResponseResult: Codable {
    let jwt: String?
    let loginId: String?
    let realName: String?
    let followerCount, followingCount, feedCount: Int?
}

struct UserToken {
    let loginId: String?
    let jwt: String?
}
