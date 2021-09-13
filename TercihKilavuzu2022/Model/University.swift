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
    @objc dynamic var minScore: String = ""
    @objc dynamic var placement: String = ""
    @objc dynamic var quota: String = ""
    @objc dynamic var duration: String = ""
    @objc dynamic var type: String = ""
    var isFavorite = false
    
    
    convenience init(universityID: String, dictionary: [String: Any]) {
        self.init()
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
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}
