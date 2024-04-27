//
//  FeedVO.swift
//  Practice_FireStore
//
//  Created by 유지호 on 3/27/24.
//

import Foundation

struct FeedVO: Identifiable {
    let id: String
    let createdAt: Date
    let writerInfo: SocialUser
    var content: String
    var likeCount: Int
    var commentCount: Int
}
