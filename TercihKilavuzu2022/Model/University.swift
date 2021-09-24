//
//  University.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 12.09.2021.
//

import Foundation
import RealmSwift

class University: Object {
    @objc dynamic var uid: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var department: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var language: String = ""
    @objc dynamic var minScore: Double = 0
    @objc dynamic var placement: Int = 0
    @objc dynamic var quota: Int = 0
    @objc dynamic var duration: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var scholarship: String = ""
    @objc dynamic var state: Bool = false

    var isFavorite = false
    
    
    convenience init(universityID: String, dictionary: [String: Any]) {
        self.init()
        self.uid = universityID
        
        self.name = dictionary["name"] as? String ?? "unnamed"
        self.department = dictionary["department"] as? String ?? "unnamed"
        self.city = dictionary["city"] as? String ?? "unnamed"
        self.language = dictionary["language"] as? String ?? "unnamed"
        self.minScore = dictionary["minScore"] as? Double ?? 0
        self.placement = dictionary["placement"] as? Int ?? 0
        self.quota = dictionary["quota"] as? Int ?? 0
        self.duration = dictionary["duration"] as? String ?? "unnamed"
        self.type = dictionary["type"] as? String ?? "unnamed"
        self.scholarship = dictionary["scholarship"] as? String ?? "unnamed"
        self.state = dictionary["state"] as? Bool ?? false

    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}
