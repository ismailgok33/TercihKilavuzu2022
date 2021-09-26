//
//  CountdownController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 11.09.2021.
//

import UIKit
import GoogleMobileAds

class CountdownController: UIViewController {
    
    // MARK: - Properties
    
    private var tytCountdownGraphView = TYTCountdownGraphView()
    private var aytCountdownGraphView = AYTCountdownGraphView()
    private var ydtCountdownGraphView = YDTCountdownGraphView()
    
    private let bannerAd: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-6180320592686930/4022248406"
        banner.load(GADRequest())
        banner.backgroundColor = .secondarySystemBackground
        return banner
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
//    override func viewDidLayoutSubviews() {
//        guard let tabBarHeight = tabBarController?.tabBar.frame.height else { return }
//
//        bannerAd.frame = CGRect(x: 0, y: view.frame.height - tabBarHeight - 50, width: view.frame.width, height: 50)
//    }
    
    // MARK: Helpers
    
    func configureUI() {
        
        let stack = UIStackView(arrangedSubviews: [tytCountdownGraphView as TYTCountdownGraphView,
                                                   aytCountdownGraphView as AYTCountdownGraphView,
                                                   ydtCountdownGraphView as YDTCountdownGraphView])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10

        view.addSubview(stack)
        stack.addConstraintsToSafelyFillView(view)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
//        bannerAd.rootViewController = self
//        view.addSubview(bannerAd)
    }
    
    
}

extension NSObject {
    func copyObject<T:NSObject>() throws -> T? {
        let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
    }
}
