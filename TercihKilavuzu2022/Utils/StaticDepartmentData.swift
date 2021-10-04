//
//  StaticDepartmentData.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 3.10.2021.
//

import Foundation

struct StaticDepartmentData {
    var staticDepartmentDataList: [Department]
    
    init() {
        staticDepartmentDataList = [
            Department(id: 1, name: "Bilgisayar Mühendisliği"),
            Department(id: 2, name: "Elektrik Elektronik Mühendisliği"),
            Department(id: 3, name: "Endüstrü Mühendisliği"),
            Department(id: 4, name: "Hukuk"),
            Department(id: 5, name: "İşletme")
        ]
    }
}
