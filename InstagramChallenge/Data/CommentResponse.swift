//
//  CommentResponse.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/06.
//

import Foundation

struct CommentResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [CommentResponseResult]?
}

struct CommentResponseResult: Codable {
    let id: Int?
    let loginId, commentText, createdAt, updatedAt: String?
}
