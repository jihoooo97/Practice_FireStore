//
//  ChatListView.swift
//  Practice_FireStore
//
//  Created by 유지호 on 3/6/24.
//

import SwiftUI
import FirebaseFirestore

struct ChatListView: View {
    private let db = Firestore.firestore()
    
    @State private var userInfo: User = User(name: "")
    @State private var chatRoomList: [ChatRoom] = []
    @State private var navigateDetailView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(userInfo.name)
                
                ScrollView {
                    LazyVStack {
                        ForEach(chatRoomList) { chatRoom in
                            NavigationLink {
                                // ChatRoom ID 받아서 해당 방 호출하도록
                                ChatRoomView(chatRoom: chatRoom)
                            } label: {
                                VStack {
                                    Divider()
                                    Text("채팅방: \(chatRoom.id)")
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Button("읽어오기") {
                        Task {
                            await readDocument()
                        }
                    }
                    
                    Button("추가하기") {
                        //                Task {
                        //                    await addDocument()
                        //                }
                    }
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
            .padding(.horizontal)
            .onAppear {
                //            Task {
                //                await readDocument()
                //            }
            }
        }
    }
    
//    private func addDocument() async {
//        do {
//            let ref = try await db.collection("Users").addDocument(
//                data: [
//                    "first": "Ada",
//                    "last": "Lovelace",
//                    "born": 1815
//                ]
//            )
//            print("Document added with ID: \(ref.documentID)")
//        } catch {
//            print("Error adding document: \(error)")
//        }
//    }
    
    private func readDocument() async {
        do {
            let userDocument = db.collection("Users").document("WI8RnUnsNzWnXf6vD0yf")
            let chatRoomListSnapshot = try await userDocument.collection("ChatRooms").getDocuments()
            
            userInfo = try await userDocument.getDocument(as: User.self)
            
            for chatRoomDocument in chatRoomListSnapshot.documents {
                print("\(chatRoomDocument.documentID) => \(chatRoomDocument.data())")
                
                let chatRoom = try chatRoomDocument.data(as: ChatRoom.self)
                print(chatRoom)
                
                chatRoomList.append(chatRoom)
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
}

struct User: Codable, Identifiable {
    private(set) var id: String = UUID().uuidString
    var name: String
//    var chatList: [ChatRoom]
}

struct ChatRoom: Codable, Identifiable {
    private(set) var id: String = UUID().uuidString
    var chatList: [Chat]
}

struct Chat: Codable, Identifiable {
    private(set) var id: String = UUID().uuidString
    var senderID: String
    var date: Date
    var content: String
}

#Preview {
    ChatListView()
}
