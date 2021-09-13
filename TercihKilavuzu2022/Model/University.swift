//
//  University.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 12.09.2021.
//

import Foundation

struct University {
    let uid: String
    let name: String
    let department: String
    let city: String
    let language: String
    let minScore: String
    let placement: String
    let quota: String
    let duration: String
    let type: String
    
    
    init(universityID: String, dictionary: [String: Any]) {
        self.uid = universityID
        
        self.name = dictionary["name"] as? String ?? "unnamed"
        self.department = dictionary["department"] as? String ?? "unnamed"
        self.city = dictionary["city"] as? String ?? "unnamed"
        self.language = dictionary["language"] as? String ?? "unnamed"
        self.minScore = dictionary["minScore"] as? String ?? "unnamed"
        self.placement = dictionary["placement"] as? String ?? "unnamed"
        self.quota = dictionary["quota"] as? String ?? "unnamed"
        self.duration = dictionary["duration"] as? String ?? "unnamed"
        self.type = dictionary["type"] as? String ?? "unnamed"
    }
}
