//
//  MainTabController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 11.09.2021.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    let universities: [University]? = nil
    
    let favorites: Results<University>? = nil
    
    let uniVC = UniversityController()
    let favoriteVC = FavoritesController()
    let countdownVC = CountdownController()
    
    private let bannerAd: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-6180320592686930/4022248406"
        banner.load(GADRequest())
        banner.backgroundColor = .red
        return banner
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
        
        bannerAd.rootViewController = self
        view.addSubview(bannerAd)
//        view.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, height: 50)
    }
    
    override func viewDidLayoutSubviews() {
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else { return }
        bannerAd.frame = CGRect(x: 0, y: view.frame.height - tabBarHeight - 50, width: view.frame.width, height: 50)
    }
    
    
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
        nav.navigationBar.barTintColor = .white
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

// MARK: - FavoritesControllerDelegate

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
