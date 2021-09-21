//
//  FilterModelView.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 21.09.2021.
//

import Foundation

struct FilterModelView {
    
    var selectedFilters: [FilterOptions]
    
    init() {
        self.selectedFilters = [.scholarshipAll, .allUniversityTypes, .allLanguages, .allYears]
    }
}

enum FilterOptions {
    case scholarshipAll
    case scholarship100
    case scholarship75
    case scholarship50
    case scholarship25
    case scholarship0
    case allUniversityTypes
    case stateUniversities
    case privateUniversities
    case allLanguages
    case turkish
    case english
    case allYears
    case year2
    case year4
    
}
