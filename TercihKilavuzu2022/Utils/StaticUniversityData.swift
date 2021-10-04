//
//  StaticUniversityData.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 4.10.2021.
//

import Foundation

struct StaticUniversityData {
    var staticUniversityDataList: [University]
    
    init() {
        staticUniversityDataList = [
            University(universityID: UUID().uuidString, dictionary: ["name": "Çanakkale Onsekiz Mart Üniversitesi", "state": "Devlet", "city": "ÇANAKKALE", "department": "Acil Yardım ve Afet Yönetimi", "duration": 4, "language": "Türkçe", "minScore": 237.64364, "placement": 340477, "quota": 60, "type": "SAY", "scholarship": "" ]),

             University(universityID: UUID().uuidString, dictionary: ["name": "Sağlık Bilimleri Üniversitesi", "state": "Devlet", "city": "İSTANBUL", "department": "Acil Yardım ve Afet Yönetimi", "duration": 4, "language": "Türkçe", "minScore": 235.22199, "placement": 350711, "quota": 40, "type": "SAY", "scholarship": "" ]),

             University(universityID: UUID().uuidString, dictionary: ["name": "Selçuk Üniversitesi", "state": "Devlet", "city": "KONYA", "department": "Acil Yardım ve Afet Yönetimi", "duration": 4, "language": "Türkçe", "minScore": 224.97011, "placement": 380229, "quota": 60, "type": "SAY", "scholarship": "" ]),

             University(universityID: UUID().uuidString, dictionary: ["name": "Hatay Mustafa Kemal Üniversitesi", "state": "Devlet", "city": "HATAY", "department": "Acil Yardım ve Afet Yönetimi", "duration": 4, "language": "Türkçe", "minScore": 214.21110, "placement": 386512, "quota": 50, "type": "SAY", "scholarship": "" ])
        ]
    }
}
