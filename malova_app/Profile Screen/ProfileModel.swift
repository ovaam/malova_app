//
//  ProfileModel.swift
//  malova_app
//
//  Created by Малова Олеся on 28.02.2025.
//

import UIKit

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
