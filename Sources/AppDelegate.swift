//
//  AppDelegate.swift
//
//  Created by Joe Pan on 2025/3/6.
//

import UIKit
import Home

@main class AppDelegate: UIResponder {
    var window: UIWindow?
}

// MARK: - UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let bounds = UIScreen.main.bounds
        let window = UIWindow(frame: bounds)
        window.backgroundColor = .white
        let home = Home.ViewController()
        window.rootViewController = UINavigationController(rootViewController: home)
        self.window = window
        window.makeKeyAndVisible()
        
        return true
    }
}
