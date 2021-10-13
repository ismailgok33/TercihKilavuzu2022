//
//  AppStoreReviewManager.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 13.10.2021.
//

import Foundation
import StoreKit

enum AppStoreReviewManager {
    static let minimumReviewWorthyActionCount = 50
    static let reviewWorthyActionCountKey = "reviewWorthyActionCount"
    static let lastReviewRequestAppVersionKey = "lastReviewRequestAppVersion"
    
    static func requestReviewIfAppropriate() {
        let defaults = UserDefaults.standard
        let bundle = Bundle.main
        
        // 2.
        var actionCount = defaults.integer(forKey: reviewWorthyActionCountKey)
        
        // 3.
        actionCount += 1
        
        // 4.
        defaults.set(actionCount, forKey: reviewWorthyActionCountKey)
        
        // 5.
        guard actionCount >= minimumReviewWorthyActionCount else {
            return
        }
        
        // 6.
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = defaults.string(forKey: lastReviewRequestAppVersionKey)
        
        // 7.
        guard lastVersion == nil || lastVersion != currentVersion else {
            return
        }
        
        // 8.
        SKStoreReviewController.requestReviewInCurrentScene()

        // 9.
        defaults.set(0, forKey: reviewWorthyActionCountKey)
        defaults.set(currentVersion, forKey: lastReviewRequestAppVersionKey)
        
    }
}

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            requestReview(in: scene)
        }
    }
}


