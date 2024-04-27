//
//  FeedUsecase.swift
//  Practice_FireStore
//
//  Created by 유지호 on 3/27/24.
//

import Foundation
import FirebaseFirestore


final class FeedUsecase {
    enum FeedError: Error {
        case getDocumentError(message: String)
    }
    
    private let userDB = Firestore.firestore().collection("SocialUser")
    private let feedDB = Firestore.firestore().collection("Feed")
    
    func loadFeedList() async throws -> [Feed] {
        guard let snapshot = try? await feedDB.getDocuments()
        else {
            throw FeedError.getDocumentError(message: "Feed Document 목록을 가져오는데 실패했습니다!")
        }
        
        let feedList = snapshot.documents.compactMap { try? $0.data(as: Feed.self) }
        let sortedList = feedList.sorted { $0.createdAt > $1.createdAt }
        return sortedList
    }
    
    func loadCommentList(feedID: String) async throws -> [Comment] {
        guard let snapshot = try? await feedDB.document(feedID).collection("Comment").getDocuments()
        else {
            throw FeedError.getDocumentError(message: "Comment Document 목록을 가져오는데 실패했습니다!")
        }
        
        let commentList = snapshot.documents.compactMap { try? $0.data(as: Comment.self) }
        let sortedList = commentList.sorted { $0.createdAt > $1.createdAt }
        return sortedList
    }
    
    func loadWriterInfo(userID: String) async throws -> SocialUser {
        guard let userInfo = try? await userDB.document(userID).getDocument(as: SocialUser.self)
        else {
            throw FeedError.getDocumentError(message: "User Document 정보를 가져오는데 실패했습니다!")
        }
        
        return userInfo
    }
    
    func writeFeed(feed: Feed) async throws {
        try await feedDB.document(feed.id).setData([
            "id": feed.id,
            "createdAt": feed.createdAt,
            "writerID": feed.writerID,
            "content": feed.content,
            "likeCount": feed.likeCount,
            "commentCount": feed.commentCount
        ])
    }
    
}


// MARK: Convert to VO
extension FeedUsecase {
    
    func getCommentInfoList(feedID: String) async throws -> [CommentVO] {
        let commentList = try await loadCommentList(feedID: feedID)
        var commentInfoList: [CommentVO] = []
        
        for comment in commentList {
            let writer = try await loadWriterInfo(userID: comment.writerID)
            let commentInfo = comment.toDomain(writer: writer)
            commentInfoList.append(commentInfo)
        }
        
        return commentInfoList
    }
    
    func getFeedInfoList() async throws -> [FeedVO] {
        let feedList = try await loadFeedList()
        var feedInfoList: [FeedVO] = []
        
        for feed in feedList {
            let writer = try await loadWriterInfo(userID: feed.writerID)
            let feedInfo = feed.toDomain(writer: writer)
            feedInfoList.append(feedInfo)
        }
        
        return feedInfoList
    }
    
}
