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
import PromiseKit
class NextViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let navigator: NavigatorType
    private var datas = [MessageModel]()
    private var currentPage = 0
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
        tableView.delegate = self
        tableView.register(MesssageCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 10
        view.addSubview(tableView)
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapRightItem))
        self.navigationItem.rightBarButtonItem = rightItem
        
        navigator.present("anMsg://launch", animated: true)
        
        fetchMessages(page: 0).done { (res) in
            if res.status == 200 {
                self.datas.append(contentsOf: res.messages)
                self.tableView.reloadData()
            }else {
                print(res.message!)
            }
        }.catch { (error) in
                
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        refreshControl.addTarget(self, action: #selector(didChangerRefreshControl), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        let refreshFooterControl = YLRefreshFooterControl()
        refreshFooterControl.addTarget(self, action: #selector(didChangerFooterRefreshControl) , for: .valueChanged)
        tableView.refreshFooterControl = refreshFooterControl
    }
    @objc
    func didTapRightItem() {
        if let uid = Keychain(service: "com.Zhu.anonymityMsg")["uid"] {
            navigator.present("anMsg://sendMsg/\(uid)", wrap: UINavigationController.self)
        }
    }
    
    @objc
    func didChangerRefreshControl(control: UIRefreshControl) {
        if(control.isRefreshing) {
            fetchMessages(page: currentPage).done { (res) in
                if res.status == 200 {
                    self.datas.removeAll()
                    self.datas.append(contentsOf: res.messages)
                    self.tableView.reloadData()
                }else {
                    print(res.message!)
                }
            }.catch { (error) in

            }.finally {
                after(seconds: 1).done {
                    control.endRefreshing()
                }
            }
        }
    }
    
    @objc
    func didChangerFooterRefreshControl(control: YLRefreshFooterControl) {
        if(control.isRefreshing) {
            self.currentPage += 1
            fetchMessages(page: self.currentPage).done { (res) in
                if res.status == 200 {
                    if res.messages.count < 20 {
                        control.isHidden = true
                    }
                    self.datas.append(contentsOf: res.messages)
                    self.tableView.reloadData()
                }else {
                    print(res.message!)
                }
            }.catch { (error) in
                    
            }.finally {
                control.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MesssageCell
        cell?.message = datas[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

