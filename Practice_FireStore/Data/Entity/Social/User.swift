//
//  User.swift
//  Practice_FireStore
//
//  Created by 유지호 on 3/27/24.
//

import Foundation

struct SocialUser: Codable, Identifiable {
    let id: String
    let createdAt: Date
    var nickname: String
    var introduction: String
    var profileImage: String
    
    init(
        id: String = UUID().uuidString,
        createdAt: Date = .now,
        nickname: String,
        introduction: String,
        profileImage: String
    ) {
        self.id = id
        self.createdAt = createdAt
        self.nickname = nickname
        self.introduction = introduction
        self.profileImage = profileImage
    }
}
