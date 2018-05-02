//
//  LaunchView.swift
//  anonymityMsg
//
//  Created by Yun on 2018/5/2.
//  Copyright © 2018 com.ZhuYunLong. All rights reserved.
//

import UIKit
protocol AnimationViewDelegate {
    func textFieldShouldReturn(_ inputString: String?)
}
class LaunchView: UIView, UITextFieldDelegate {
    private var userName: String?
    private var activityIndicatorView: UIActivityIndicatorView
    var delegate: AnimationViewDelegate?
    override init(frame: CGRect) {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        
        super.init(frame: frame)
        self.backgroundColor = .white
        let label = UILabel()
        label.text = "Welcome!"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        let textInput = UITextField()
        textInput.placeholder = "用户名"
        textInput.textAlignment = .center
        textInput.returnKeyType = .done
        textInput.enablesReturnKeyAutomatically = true
        textInput.delegate = self
        self.flex.justifyContent(.center).alignItems(.center).define { (flex) in
            flex.addItem().define({ (flex) in
                flex.addItem(label)
                flex.addItem(textInput).height(0)
            })
        }
        
        self.addSubview(activityIndicatorView)
        activityIndicatorView.flex.isIncludedInLayout(false)
        activityIndicatorView.color = .black
        activityIndicatorView.hidesWhenStopped = true
        let rect = UIScreen.main.bounds
        activityIndicatorView.center = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
        
    }
    
    func showActivityIndicatorView() {
        activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicatorView() {
        activityIndicatorView.stopAnimating()
    }
    
    private func buildWelcomeUserUI() {
        let temTextInput = self.subviews.flatMap{ $0.subviews }.first { $0.isKind(of: UITextField.self) }
        guard let textInput = temTextInput as? UITextField  else {
            return
        }
        if let name = userName {
            textInput.text = name
            textInput.isUserInteractionEnabled = false
        }else {
            textInput.isUserInteractionEnabled = true
            textInput.becomeFirstResponder()
        }
        textInput.flex.height(30).marginTop(10).marginBottom(40)
        UIView.animate(withDuration: 0.25){
            self.flex.layout()
        }
    }
    
    func buildNewUserUI() {
        self.buildWelcomeUserUI()
    }
    func buildUserUI(name: String) {
        userName = name
        self.buildWelcomeUserUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.flex.layout(mode: .fitContainer)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let input = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        textField.text = input
        self.delegate?.textFieldShouldReturn(input)
        textField.resignFirstResponder()
        return true
    }
    
}
