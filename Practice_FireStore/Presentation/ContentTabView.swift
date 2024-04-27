//
//  TabView.swift
//  Practice_FireStore
//
//  Created by 유지호 on 3/27/24.
//

import SwiftUI

enum ActiveTab {
    case social
    case chat
}

struct ContentTabView: View {
    @State private var activeTab: ActiveTab = .social
    
    var body: some View {
        TabView(selection: $activeTab) {
            NavigationStack {
                Text("social")
            }
            .tabItem {
                Label("Social", systemImage: "person.2")
            }
            
            NavigationStack {
                ChatListView()
            }
            .tabItem {
                Label("Chat", systemImage: "message")
            }
        }
    }
}

#Preview {
    ContentTabView()
}
