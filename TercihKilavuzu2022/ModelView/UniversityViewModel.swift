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
        let props = university.scholarship.isEmpty ? " (\(university.language))" : " (\(university.scholarship) - \(university.language))"
        name.append(NSAttributedString(string: props, attributes: [.font: UIFont.boldSystemFont(ofSize: 12)]))
        return name
    }
    
    var favoriteButtonImage: UIImage {
        let imageName = university.isFavorite ? "suit.heart.fill" : "suit.heart"
        return UIImage(systemName: imageName)!
    }
    
    var typeColor: UIColor {
        var color = UIColor.clear
        
        switch university.type {
        case "SAY":
            color = .green
        case "EA":
            color = .blue
        case "SÖZ":
            color = .brown
        case "DİL":
            color = .orange
        default:
            color = .clear
        }
        
        return color
    }
    
    init(university: University) {
        self.university = university
    }
}
