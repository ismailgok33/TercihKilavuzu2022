//
//  FirestoreService.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 12.09.2021.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
            
    func fetchUniversities(completion: @escaping([University]) -> Void) {
        var universities = [University]()
        
        REF_UNIVERSITIES_DB.getDocuments { snapshot, err in
            guard err == nil else { return }
            guard let snapshot = snapshot else { return }
            
            for document in snapshot.documents {
                let universityID = document.documentID
                guard let dictionary = document.data() as? [String: Any] else { return }
                let university = University(universityID: universityID, dictionary: dictionary)
                universities.append(university)
                completion(universities)
            }
        }
    }
    
    func fetchCities(completion: @escaping([City]) -> Void) {
        var cities = [City]()
        
        REF_CITIES_DB.getDocuments { snapshot, err in
            guard err == nil else { return }
            guard let snapshot = snapshot else { return }
            
            for document in snapshot.documents {
//                let cityUID = document.documentID
                guard let dictionary = document.data() as? [String: Any] else { return }
                let city = City(id: dictionary["id"] as! Int, name: dictionary["name"] as! String)
                cities.append(city)
                completion(cities)
            }
        }
    }
    
    func fetchDepartments(completion: @escaping([Department]) -> Void) {
        var departments = [Department]()
        
        REF_DEPARTMENTS_DB.getDocuments { snapshot, err in
            guard err == nil else { return }
            guard let snapshot = snapshot else { return }
            
            for document in snapshot.documents {
                guard let dictionary = document.data() as? [String: Any] else { return }
                let department = Department(id: dictionary["id"] as! Int, name: dictionary["name"] as! String)
                departments.append(department)
                completion(departments)
            }
        }
    }
}
