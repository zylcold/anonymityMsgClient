//
//  AppDelegate.swift
//  anonymityMsg
//
//  Created by Yun on 2018/5/1.
//  Copyright © 2018 com.ZhuYunLong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let launchVc = LaunchViewController()
        let navVC = UINavigationController.init(rootViewController: launchVc)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        return true
    }
}

