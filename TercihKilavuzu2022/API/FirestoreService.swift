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
}
