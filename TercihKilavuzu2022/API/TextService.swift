//
//  TextService.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 7.10.2021.
//

import Foundation

class TextService {
    static let shared = TextService()

    private init() { }
    
    func fetchStaticUniversities(completion: @escaping([University]) -> Void) {
        var universities = [University]()
        var staticUniversityText = ""
        var lineArray = [String]()
        var keyArray = [String]()
        
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
    
    func fetchStaticDepartments(completion: @escaping([Department]) -> Void) {
        var departments = [Department]()
        var staticDepartmentText = ""
        var lineArray = [String]()
        var keyArray = [String]()
        
        if let path = Bundle.main.path(forResource: "StaticDepartmentData", ofType: "txt") {
          do {
            staticDepartmentText = try String(contentsOfFile: path, encoding: .utf8)
            lineArray = staticDepartmentText.components(separatedBy: "#")
            lineArray.remove(at: lineArray.count - 1)
            lineArray.forEach {
                keyArray = $0.trimmingCharacters(in: .newlines).components(separatedBy: ",")

                departments.append(Department(id: Int(keyArray[0].trimmingCharacters(in: .whitespaces)) ?? 0,
                                              name: keyArray[1].trimmingCharacters(in: .whitespaces)))
            }
            completion(departments)
          } catch let error {
            // Handle error here
            print("error while reading text file \(error)")
          }
        }
    }
}
