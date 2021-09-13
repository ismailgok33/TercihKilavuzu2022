//
//  RealmService.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 13.09.2021.
//

import Foundation
import RealmSwift

class RealmService {
    static let shared = RealmService()
    
    
    let realm = try! Realm()
    
    func saveFavorite(favorite university: University) {
        
        if university.isFavorite {
            do {
                try realm.write {
                    realm.delete(realm.objects(University.self).filter("uid=%@",university.uid))
                }
            } catch {
                print("Error while deleting a university from favorites")
            }
        }
        else {
            do {
                try realm.write ({
                    let copy = realm.create(University.self, value: university, update: .all)
                    realm.add(copy)
                })
            }
            catch {
                print("Error while saving to university to favorites")
            }
}
        
    }
}
