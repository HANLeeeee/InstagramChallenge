//
//  ChatResponse.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import Foundation

struct ChatResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [ChatResponseResult]
}

struct ChatResponseResult: Codable {
    let chatId: Int
    let loginId: String
    let content, createdAt, updatedAt: String
}


struct ChatPostResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: ChatPostResponseResult
}

struct ChatPostResponseResult: Codable {
    let loginId, reply: String
}

