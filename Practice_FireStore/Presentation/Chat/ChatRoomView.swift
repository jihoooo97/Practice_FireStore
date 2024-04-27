//
//  ChatRoomView.swift
//  Practice_FireStore
//
//  Created by 유지호 on 3/24/24.
//

import SwiftUI
import FirebaseFirestore

struct ChatRoomView: View {
    private let db = Firestore.firestore().collection(.user).document("WI8RnUnsNzWnXf6vD0yf").collection(.chatRoom)
    private let userID: String = "WI8RnUnsNzWnXf6vD0yf"
    
    @State var chatRoom: ChatRoom = .init(chatList: [])
    
    @State private var chatString: String = ""
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(chatRoom.chatList) { chat in
                            HStack {
                                if chat.senderID == userID {
                                    Spacer()
                                    
                                    Text(chat.date.formatted())
                                        .font(.caption)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(chat.senderID)
                                    Text(chat.content)
                                }
                                .padding(8)
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .clipShape(.rect(cornerRadius: 12))
                                
                                if chat.senderID != userID {
                                    Text(chat.date.formatted())
                                        .font(.caption)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .id("ScrollViewBottom")
                }
                .padding(.vertical, 1)
                .defaultScrollAnchor(.bottom)
                .onAppear {
                    Task {
                        await addListener()
//                        proxy.scrollTo("ScrollViewBottom", anchor: .bottom)
                    }
                }
                
                HStack {
                    TextField("메시지 보내기", text: $chatString)
                        .padding(8)
                        .background()
                        .clipShape(.rect(cornerRadius: 20))
                    
                        .padding(.horizontal)
                    
                    Button {
                        Task {
                            await sendMessage()
                            chatString = ""
                            proxy.scrollTo("ScrollViewBottom", anchor: .bottom)
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                        
                    }
                    .rotationEffect(.degrees(45))
                }
                .padding()
                .background(Color.gray)
            }
        }
    }
    
    func addListener() async {
        db.document(chatRoom.id).addSnapshotListener { snapshot, error in
            guard let document = snapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = try? document.data(as: ChatRoom.self) else {
              print("Document data was empty.")
              return
            }
            
            let sortedChatRoom = ChatRoom(
                id: data.id,
                chatList: data.chatList.sorted(by: { $0.date < $1.date })
            )
            
            self.chatRoom = sortedChatRoom
        }
    }
    
    func sendMessage() async {
        do {
            try await db.document("X67rEwmnY4xlA8M2FH3i").updateData([
                "chatList": FieldValue.arrayUnion([
                    ["id": UUID().uuidString,
                     "senderID": userID,
                     "date": Date.now,
                     "content": chatString
                    ]
                ])
            ])
        } catch {
            print("fail update")
        }
    }
    
}

#Preview {
    ChatRoomView(chatRoom: ChatRoom(id: "X67rEwmnY4xlA8M2FH3i", chatList: []))
}


enum CollectionName: String {
    case user = "Users"
    case chatRoom = "ChatRooms"
}

extension Firestore {
    
    func collection(_ collectionName: CollectionName) -> CollectionReference {
        self.collection(collectionName.rawValue)
    }
    
}

extension DocumentReference {
    
    func collection(_ collectionName: CollectionName) -> CollectionReference {
        self.collection(collectionName.rawValue)
    }
    
}
