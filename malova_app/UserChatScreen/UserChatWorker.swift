//
//  UserChatWorker.swift
//  malova_app
//
//  Created by Малова Олеся on 25.03.2025.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol UserChatWorkerProtocol {
    func loadMessages(chatId: String, completion: @escaping (Result<[Message], Error>) -> Void)
    func sendMessage(chatId: String, text: String, senderId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func createOrLoadChat(userId: String, adminId: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class UserChatWorker: UserChatWorkerProtocol {
    private let db = Firestore.firestore()
    
    func loadMessages(chatId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        db.collection("chats").document(chatId).collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let messages = snapshot?.documents.compactMap { doc -> Message? in
                    let data = doc.data()
                    guard let senderId = data["senderId"] as? String,
                          let text = data["text"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else { return nil }
                    return Message(senderId: senderId, text: text, timestamp: timestamp.dateValue())
                } ?? []
                
                completion(.success(messages))
            }
    }
    
    func sendMessage(chatId: String, text: String, senderId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let messageData: [String: Any] = [
            "senderId": senderId,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("chats").document(chatId).collection("messages")
            .addDocument(data: messageData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    func createOrLoadChat(userId: String, adminId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let chatId = "\(userId)_\(adminId)"
        
        db.collection("chats").document(chatId).getDocument { [weak self] snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if snapshot?.exists == true {
                completion(.success(chatId))
            } else {
                self?.db.collection("chats").document(chatId).setData([:]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(chatId))
                    }
                }
            }
        }
    }
}
