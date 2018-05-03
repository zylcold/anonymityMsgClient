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
class NextViewController: UIViewController, UITableViewDataSource {
    private let navigator: NavigatorType
    private var datas = [MessageModel]()
    init(navigator: NavigatorType) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = self.view.bounds
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        navigator.present("anMsg://launch", context: nil, wrap: UINavigationController.self, from: nil, animated: true, completion: nil)
        
        fetchMessages().done { (res) in
            if res.status == 200 {
                self.datas.append(contentsOf: res.messages)
                self.tableView.reloadData()
            }else {
                print(res.message)
            }
        }.catch { (error) in
                
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let item = datas[indexPath.row]
        cell?.textLabel?.text = item.message!
        return cell!
    }
}

