//
//  MainTabController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 11.09.2021.
//

import UIKit
import RealmSwift

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    let universities: [University]? = nil
    
    let favorites: Results<University>? = nil
    
    let uniVC = UniversityController()
    let favoriteVC = FavoritesController()
    let countdownVC = CountdownController()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
    }
    
    
    //MARK: - API
    
    
    
    //MARK: - Helpers
    
    func configureViewControllers() {
        //let universityVC = UniversityController()
        uniVC.delegate = self
        uniVC.title = "Üniversiteler"
        let nav1 = templateNavigationController(image: UIImage(systemName: "building.columns.fill")!, rootController: uniVC)
        nav1.tabBarItem.title = "Üniversiteler"
        
        favoriteVC.delegate = self
        favoriteVC.title = "Favoriler"
        let nav2 = templateNavigationController(image: UIImage(systemName: "heart.fill")!, rootController: favoriteVC)
        nav2.tabBarItem.title = "Favoriler"
        
        countdownVC.title = "Geri Sayım"
        let nav3 = templateNavigationController(image: UIImage(systemName: "timer")!, rootController: countdownVC)
        nav3.tabBarItem.title = "Geri Sayım"
        
        viewControllers = [nav1, nav2, nav3]
    }
    
    func templateNavigationController(image: UIImage, rootController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .systemBackground
        return nav
    }
}

// MARK: - UniversityControllerDelegate

extension MainTabController: UniversityControllerDelegate {
    func handleFavoriteTappedAtUniversityController(_ cell: UniversityCell) {
        guard let university = cell.university else { return }
                
        RealmService.shared.saveFavorite(favorite: university)
        university.isFavorite.toggle()
        cell.university = university
        
        favoriteVC.loadFavorites()
    }
    
    
}

extension MainTabController: FavoritesControllerDelegate {
    func handleFavoriteTappedAtFavoritesController(_ cell: UniversityCell) {
        guard let favorite = cell.university else { return }
        favorite.isFavorite = true
        uniVC.changeFavoritesFromFavoritesController(withFavorite: favorite)
        RealmService.shared.saveFavorite(favorite: favorite)
        favorite.isFavorite.toggle()
        favoriteVC.loadFavorites()
    }
}
