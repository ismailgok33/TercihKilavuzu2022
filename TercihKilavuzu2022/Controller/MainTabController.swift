//
//  MainTabController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 11.09.2021.
//

import UIKit

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
    }
    
    
    //MARK: - API
    
    
    
    //MARK: - Helpers
    
    func configureViewControllers() {
        let nav1 = templateNavigationController(image: UIImage(systemName: "building.columns.fill")!, rootController: UniversityController())
        
        let nav2 = templateNavigationController(image: UIImage(systemName: "heart.fill")!, rootController: FavoritesController())
        
        let nav3 = templateNavigationController(image: UIImage(systemName: "timer")!, rootController: CountdownController())
        
        viewControllers = [nav1, nav2, nav3]
    }
    
    func templateNavigationController(image: UIImage, rootController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .systemBackground
        return nav
    }

    

}
