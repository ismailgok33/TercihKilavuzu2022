//
//  NetworkMonitorService.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 17.10.2021.
//

import Foundation
import UIKit
import Network

final class NetworkMonitorService {
    static let shared = NetworkMonitorService()
    
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    public private(set) var isConnected = false
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            
            if path.status == .satisfied {
                print("DEBUG: We're connected!")
                // post connected notification
                self?.isConnected = true
            } else {
                print("DEBUG: No connection.")
                // post disconnected notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "noInternetConnection"), object: nil)
                self?.isConnected = false
                
            }
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
