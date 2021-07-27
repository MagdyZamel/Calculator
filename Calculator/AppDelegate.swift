//
//  AppDelegate.swift
//  Calculator
//
//  Created by MSZ on 12/07/2021.
//

import UIKit
import Resolver
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let homeViewController  = UIViewController()
        window?.rootViewController = homeViewController
        changeUserInterfaceStyle(style: .dark)
        return true
    }
    
    func changeUserInterfaceStyle(style: UIUserInterfaceStyle) {
        window?.overrideUserInterfaceStyle = style
    }
}
