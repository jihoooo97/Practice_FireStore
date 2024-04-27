//
//  SocialView.swift
//  Practice_FireStore
//
//  Created by 유지호 on 3/27/24.
//

import SwiftUI

struct SocialView: View {
    private let useCase = FeedUsecase()
    @State private var feedList: [FeedVO] = []
    
    var body: some View {
        VStack {
            HStack {
                Button("로그인") {
                    login()
                }
                
                Button("피드 불러오기") {
                    loadFeedList()
                }
                
                Button("피드 쓰기") {
                    writeFeed()
                }
            }
            .buttonStyle(.borderedProminent)
            
            ScrollView {
                LazyVStack {
                    ForEach(feedList) { feed in
                        HStack(alignment: .top) {
                            Image(systemName: feed.writerInfo.profileImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(feed.writerInfo.nickname)
                                    Text(feed.createdAt.formatted())
                                }
                                Text(feed.content)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func login() {
        print(UUID().uuidString)
    }
    
    private func loadFeedList() {
        Task {
            do {
                feedList = try await useCase.getFeedInfoList()
                print(feedList)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func writeFeed() {
        Task {
            let feed = Feed(writerID: "D142E00A-1228-46B3-A7FD-65F0F77E0013", content: "테스트 중 입니다~~~~~")
            try await useCase.writeFeed(feed: feed)
        }
    }
}

#Preview {
    SocialView()
}
