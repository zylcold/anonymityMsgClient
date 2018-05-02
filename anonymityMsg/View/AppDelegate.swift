//
//  AppDelegate.swift
//  anonymityMsg
//
//  Created by Yun on 2018/5/1.
//  Copyright © 2018 com.ZhuYunLong. All rights reserved.
//

import UIKit
import URLNavigator
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navigator = Navigator()
        URLNavigationMap.initialize(navigator: navigator)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        let navVC = UINavigationController.init(rootViewController: NextViewController(navigator: navigator))
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        return true
    }
}

struct URLNavigationMap {
    static func initialize(navigator: NavigatorType) {
        navigator.register("anMsg://launch") { url, values, context in
            return LaunchViewController()
        }
    }
}
