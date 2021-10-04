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
    
    func fetchStaticUniversities(completion: @escaping([University]) -> Void) {
        var universities = [University]()
        var staticUniversityText = ""
        var lineArray = [String]()
        var keyArray = [String]()
//        let staticUniversityDataModel = StaticUniversityData()
//
//        universities = staticUniversityDataModel.staticUniversityDataList
//        completion(universities)
        
        if let path = Bundle.main.path(forResource: "StaticUniversityData", ofType: "txt") {
          do {
            staticUniversityText = try String(contentsOfFile: path, encoding: .utf8)
            lineArray = staticUniversityText.components(separatedBy: "#")
            lineArray.remove(at: lineArray.count - 1)
            lineArray.forEach {
                keyArray = $0.trimmingCharacters(in: .newlines).components(separatedBy: ",")

                universities.append(University(universityID: UUID().uuidString,
                                               dictionary: ["name": keyArray[0].trimmingCharacters(in: .whitespaces),
                                                            "state": keyArray[1].trimmingCharacters(in: .whitespaces),
                                                            "city": keyArray[2].trimmingCharacters(in: .whitespaces),
                                                            "department": keyArray[3].trimmingCharacters(in: .whitespaces),
                                                            "duration": keyArray[4].trimmingCharacters(in: .whitespaces),
                                                            "language": keyArray[5].trimmingCharacters(in: .whitespaces),
                                                            "minScore" : Double(keyArray[6].trimmingCharacters(in: .whitespaces)) ?? 0.0,
                                                            "placement": Int(keyArray[7].trimmingCharacters(in: .whitespaces)) ?? 0,
                                                            "quota": Int(keyArray[8].trimmingCharacters(in: .whitespaces)) ?? 0,
                                                            "type": keyArray[9].trimmingCharacters(in: .whitespaces),
                                                            "scholarship": keyArray[10].trimmingCharacters(in: .whitespaces)
                                               ]))
            }
            completion(universities)
          } catch let error {
            // Handle error here
            print("error while reading text file \(error)")
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
    
    func fetchStaticCities(completion: @escaping([City]) -> Void) {
        var cities = [City]()
        let staticCityDataModel = StaticCityData()
        cities = staticCityDataModel.staticCityDataList
        completion(cities)
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
    
    func fetchStaticDepartments(completion: @escaping([Department]) -> Void) {
        var departments = [Department]()
        let staticDepartmentData = StaticDepartmentData()
        departments = staticDepartmentData.staticDepartmentDataList
        completion(departments)
    }
}
