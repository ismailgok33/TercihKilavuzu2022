//
//  ActionSheetViewModel.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 18.09.2021.
//

import Foundation

struct ActionSheetViewModel {
        
    var options: [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        results.append(.nameAsc)
        results.append(.nameDesc)
        results.append(.minScoreAsc)
        results.append(.minScoreDesc)
        results.append(.placementAsc)
        results.append(.placementDesc)
        results.append(.departmentAsc)
        results.append(.departmenDesc)
        results.append(.cityAsc)
        results.append(.cityDesc)
        results.append(.quotaAsc)
        results.append(.quotaDesc)
        return results
    }
    
    var selectedOption: ActionSheetOptions
    
    init() {
        self.selectedOption = .nameAsc
    }
    
}

enum ActionSheetOptions {
    case nameAsc
    case nameDesc
    case minScoreAsc
    case minScoreDesc
    case placementAsc
    case placementDesc
    case departmentAsc
    case departmenDesc
    case cityAsc
    case cityDesc
    case quotaAsc
    case quotaDesc
    
    var description: String {
        switch self {
        case .nameAsc: return "Üniversite ismine göre (A-Z)"
        case .nameDesc: return "Üniversite ismine göre (Z-A)"
        case .minScoreAsc: return "Puana göre (düşükten yükseğe)"
        case .minScoreDesc: return "Puana göre (yüksekten düşüğe)"
        case .placementAsc: return "Sıralamaya göre (azdan çoğa)"
        case .placementDesc: return "Sıralamaya göre (çoktan aza)"
        case .departmentAsc: return "Bölüm ismine göre (A-Z)"
        case .departmenDesc: return "Bölüm ismine göre (Z-A)"
        case .cityAsc: return "Şehir ismine göre (A-Z)"
        case .cityDesc: return "Şehir ismine göre (Z-A)"
        case .quotaAsc: return "Kontenjana göre (azdan çoğa)"
        case .quotaDesc: return "Kontenjana göre (çoktan aza)"
        }
    }
}
