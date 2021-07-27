//
//  InternetManager.swift
//  Calculator
//
//  Created by MSZ on 14/07/2021.
//

import Foundation

protocol InternetManager {
    func  isInternetConnectionAvailable () -> Bool
}

class InternetManagerImp: InternetManager {

    private var reachability = try? Reachability()
    private var isReachable: Bool?
     init() {
        reachability?.whenReachable = {[weak self ] _ in
            self?.isReachable = true
        }

        reachability?.whenUnreachable = {[weak self ] _ in
            self?.isReachable = false
        }
        try? reachability?.startNotifier()
    }

    func isInternetConnectionAvailable() -> Bool {
        return isReachable ?? (reachability?.connection != .unavailable)
    }
}
