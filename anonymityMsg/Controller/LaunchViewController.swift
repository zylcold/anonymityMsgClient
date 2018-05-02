//
//  LaunchViewController.swift
//  anonymityMsg
//
//  Created by Yun on 2018/5/1.
//  Copyright © 2018 com.ZhuYunLong. All rights reserved.
//

import UIKit
import FlexLayout
import PromiseKit
import KeychainAccess
class LaunchViewController: UIViewController, AnimationViewDelegate {
    
    var mainView: LaunchView {
        return self.view as! LaunchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.showActivityIndicatorView()
        fetchConfig().done(on: DispatchQueue.main) { (model) in
            self.mainView.hideActivityIndicatorView()
            self.mainView.buildNewUserUI()
            }.catch { (error) in
                print(error)
            }.finally {
                self.mainView.hideActivityIndicatorView()
        }
        
    }
    
    func textFieldShouldReturn(_ inputString: String?) {
        
        guard let name = inputString else {
            return
        }
        self.mainView.showActivityIndicatorView()
        postAddNewUser(name: name).done(on: DispatchQueue.main) { (res) in
            if res.status == 200 {
                let keychain = Keychain(service: "com.Zhu.anonymityMsg")
                keychain["uid"] = res.uid
                self.dismiss(animated: true, completion: nil)
            }else {
                print(res.message)
            }
            }.catch { (error) in
                print(error)
            }.finally {
                self.mainView.hideActivityIndicatorView()
        }
    }
    
    override func loadView() {
        self.view = LaunchView()
        self.mainView.delegate = self
    }

}
