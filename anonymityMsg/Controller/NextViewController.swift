//
//  NextViewController.swift
//  FlexboxAnimaitonDemo
//
//  Created by Dadao on 2018/5/2.
//  Copyright © 2018 Dadao. All rights reserved.
//

import UIKit
import KeychainAccess
import URLNavigator
class NextViewController: UIViewController {
    private let navigator: NavigatorType
    init(navigator: NavigatorType) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let temUid = Keychain(service: "com.Zhu.anonymityMsg")["uid"]
        if let uid = temUid {
            print(uid)
        }else {
            navigator.present("anMsg://launch", context: nil, wrap: UINavigationController.self, from: nil, animated: true, completion: nil)
        }
    }

}
