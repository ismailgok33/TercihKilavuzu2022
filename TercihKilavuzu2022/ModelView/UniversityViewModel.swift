//
//  UniversityViewModel.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 13.09.2021.
//

import UIKit

struct UniversityViewModel {
    let university: University
    
    var universityNameLabel: NSAttributedString {
        let name = NSMutableAttributedString(string: university.name, attributes: [.font: UIFont.systemFont(ofSize: 16)])
        name.append(NSAttributedString(string: " (\(university.city))", attributes: [.font: UIFont.systemFont(ofSize: 12)]))
        return name
    }
    
    var departmentLabel: NSAttributedString {
        let name = NSMutableAttributedString(string: university.department, attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        name.append(NSAttributedString(string: " (\(university.language))", attributes: [.font: UIFont.boldSystemFont(ofSize: 12)]))
        return name
    }
    
    var favoriteButtonImage: UIImage {
        let imageName = university.isFavorite ? "suit.heart.fill" : "suit.heart"
        return UIImage(systemName: imageName)!
    }
    
    init(university: University) {
        self.university = university
    }
}
