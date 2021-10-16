//
//  AppDelegate.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 11.09.2021.
//

import UIKit
import Firebase
import RealmSwift
import GoogleMobileAds
import Purchases

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        do {
            _ = try Realm()
        } catch {
            print("Error while starting realm \(error)")
        }
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        Purchases.configure(withAPIKey: "yRVqvnFMPsyETOMzMgNdPWAkHnKROwEV")
        
        if !IAPService.shared.isPremium() {
            IAPService.shared.getSubscriptionStatus(completion: nil)
        }
        
        UINavigationBar.appearance().barTintColor = .white // navigation background color
//        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black] // navigation title color
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

