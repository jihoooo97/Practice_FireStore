//
//  Feed.swift
//  Practice_FireStore
//
//  Created by 유지호 on 3/27/24.
//

import Foundation

struct Feed: Codable, Identifiable {
    let id: String
    let createdAt: Date
    let writerID: String
    var content: String
    var likeCount: Int
    var commentCount: Int
    
    init(
        id: String = UUID().uuidString,
        createdAt: Date = .now,
        writerID: String,
        content: String,
        likeCount: Int = 0,
        commentCount: Int = 0
    ) {
        self.id = id
        self.createdAt = createdAt
        self.writerID = writerID
        self.content = content
        self.likeCount = likeCount
        self.commentCount = commentCount
    }
    
    func toDomain(writer: SocialUser) -> FeedVO {
        return FeedVO(
            id: self.id,
            createdAt: self.createdAt,
            writerInfo: writer,
            content: self.content,
            likeCount: self.likeCount,
            commentCount: self.commentCount
        )
    }
}
