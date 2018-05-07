//
//  SendMsgViewController.swift
//  anonymityMsg
//
//  Created by Dadao on 2018/5/4.
//  Copyright © 2018 com.ZhuYunLong. All rights reserved.
//

import UIKit
import StatusAlert
class SendMsgViewController: UIViewController {
    let uid: String
    var textView: UITextView?
    init(uid: String) {
        self.uid = uid
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发消息"
        self.edgesForExtendedLayout = .bottom
        view.backgroundColor = .white
        let rightItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapRightItem))
        self.navigationItem.rightBarButtonItem = rightItem
        
        let textView = UITextView(frame: view.bounds)
        
        view.addSubview(textView)
        self.textView = textView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView?.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView?.resignFirstResponder()
    }
    
    @objc
    func didTapRightItem() {
        if let message = self.textView?.text {
            postAddNewMessage(uid, message: message).done {_ in
                
                let sendNotification = Notification(name: Notification.Name("sendNewMessageNotificationKey"), object: nil)
                NotificationCenter.default.post(sendNotification)
                
                let alert = StatusAlert.instantiate(withImage: UIImage(named: "Success_icon"), title: "成功", message: nil)
                alert.showInKeyWindow()
            }.catch { (error) in
                    
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }

}
