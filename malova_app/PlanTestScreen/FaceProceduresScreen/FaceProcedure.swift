//
//  FaceProcedure.swift
//  malova_app
//
//  Created by Малова Олеся on 07.04.2025.
//

import FirebaseFirestore

struct FaceProcedure: Codable {
    let id: String
    let createdAt: Date
    let description: String
    let duration: String
    let name: String
    let performer: String
    let price: Int
    let type: String
    let zone: String
    
    init?(id: String, data: [String: Any]) {
        guard let createdAt = data["createdAt"] as? Timestamp,
              let description = data["description"] as? String,
              let duration = data["duration"] as? String,
              let name = data["name"] as? String,
              let performer = data["performer"] as? String,
              let price = data["price"] as? Int,
              let type = data["type"] as? String,
              let zone = data["zone"] as? String else {
            return nil
        }
        
        self.id = id
        self.createdAt = createdAt.dateValue()
        self.description = description
        self.duration = duration
        self.name = name
        self.performer = performer
        self.price = price
        self.type = type
        self.zone = zone
    }
}
