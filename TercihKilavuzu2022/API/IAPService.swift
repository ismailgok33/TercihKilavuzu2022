//
//  IAPService.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 13.10.2021.
//

import Foundation
import Purchases
import StoreKit

final class IAPService {
    static let shared = IAPService()
    
    // RevenueCat Shared Secret
    // d402259c51b142258e67d5f085dd176a

    // Storekit bundle id
    // com.myiosapps.TercihKilavuzu2022.premium
    
    // RevenueCat API Key
    // yRVqvnFMPsyETOMzMgNdPWAkHnKROwEV
    
    private init() {}
    
    func isPremium() -> Bool {
        return UserDefaults.standard.bool(forKey: "premium")
    }
    
    func getSubscriptionStatus(completion: ((Bool) -> Void)?) {
        Purchases.shared.purchaserInfo { info, error in
            guard let entitlements = info?.entitlements, error == nil else { return }
            
            if entitlements.all["Premium"]?.isActive == true {
                print("DEBUG: Got updated status of subscribed")
                UserDefaults.standard.set(true, forKey: "premium")
                completion?(true)
            }
            else {
                print("DEBUG: Got updated status of NOT subscribed")
                UserDefaults.standard.set(false, forKey: "premium")
                completion?(false)
            }
        }
    }
    
    func fetchPackages(completion: @escaping((Purchases.Package)?) -> Void) {
        Purchases.shared.offerings { offering, error in
            guard let package = offering?.offering(identifier: "default")?.availablePackages.first, error == nil else {
                completion(nil)
                return
            }
            
            completion(package)
        }
    }
    
    public func subscribe(package: Purchases.Package, completion: @escaping(Bool) -> Void) {
        guard !isPremium() else {
            print("DEBUG: Already has premium!")
            completion(true)
            return
        }
        
        Purchases.shared.purchasePackage(package) { transaction, info, error, userCanceled in
            guard let transaction = transaction,
                  let entitlements = info?.entitlements,
                  error == nil,
                  !userCanceled else { return }
            
            switch transaction.transactionState {
            
            case .purchasing:
                print("purchasing")
            case .purchased:
                if entitlements.all["Premium"]?.isActive == true {
                    print("DEBUG: Purchased")
                    UserDefaults.standard.set(true, forKey: "premium")
                    completion(true)
                }
                else {
                    print("DEBUG: Purchase failed")
                    UserDefaults.standard.set(false, forKey: "premium")
                    completion(false)
                }
            case .failed:
                print("failed")
            case .restored:
                if entitlements.all["Premium"]?.isActive == true {
                    print("DEBUG: Restored Successfully")
                    UserDefaults.standard.set(true, forKey: "premium")
                    completion(true)
                }
                else {
                    print("DEBUG: Restore failed")
                    UserDefaults.standard.set(false, forKey: "premium")
                    completion(false)
                }
            case .deferred:
                print("defered")
            @unknown default:
                print("default case")
            }
        }
    }
    
    public func restore(completion: @escaping(Bool) -> Void) {
        Purchases.shared.restoreTransactions { info, error in
            guard let entitlements = info?.entitlements, error == nil else { return }
            
            if entitlements.all["Premium"]?.isActive == true {
                print("DEBUG: Restored successfully")
                UserDefaults.standard.set(true, forKey: "premium")
                completion(true)
            }
            else {
                print("DEBUG: Restore failed")
                UserDefaults.standard.set(false, forKey: "premium")
                completion(false)
            }
        }
    }
}
