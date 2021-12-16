//
//  AppDelegate.swift
//  Scan QR
//
//  Created by mac on 06.12.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController(rootViewController: ReportIssueViewController())
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
}

