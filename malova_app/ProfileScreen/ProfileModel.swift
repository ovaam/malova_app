//
//  ProfileModel.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

enum ProfileModel {
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    //    enum Other {
    //        struct Request { }
    //        struct Response { }
    //        struct ViewModel { }
    //        struct Info { }
    //    }
}

struct User {
    let uid: String
    let email: String
    let fullName: String
    let age: Int
    let gender: String
    
    init?(data: [String: Any], uid: String) {
        guard let email = data["phoneNumber"] as? String,
              let fullName = data["fullName"] as? String,
              let age = data["age"] as? Int,
              let gender = data["gender"] as? String else {
            return nil
        }
        
        self.uid = uid
        self.email = email
        self.fullName = fullName
        self.age = age
        self.gender = gender
    }
}

final class ProfileViewModel {
    private let db = Firestore.firestore()
    
    func fetchUserData(completion: @escaping (User?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                print("Ошибка загрузки данных пользователя: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = snapshot?.data() else {
                print("Данные пользователя не найдены")
                completion(nil)
                return
            }
            
            let user = User(data: data, uid: userId)
            completion(user)
        }
    }
}
