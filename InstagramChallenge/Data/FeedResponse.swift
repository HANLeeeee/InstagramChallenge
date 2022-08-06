//
//  FeedResponse.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/05.
//

import Foundation

struct FeedResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [FeedResponseResult]?
}

struct FeedResponseResult: Codable {
    let feedId: Int?
    let feedLoginId, feedText, feedCreatedAt, feedUpdatedAt: String?
    let feedCommentCount: Int?
    let contentsList: [FeedResponseResultList]?
}

struct FeedResponseResultList: Codable {
    let contentsId: Int?
    var contentsUrl: String?
    let createdAt, updatedAt: String?
}
