//
//  NetworkUtils.swift
//  FlexboxAnimaitonDemo
//
//  Created by Dadao on 2018/5/2.
//  Copyright © 2018 Dadao. All rights reserved.
//

import PMKAlamofire
import Alamofire
import PromiseKit
import UIKit

protocol BaseResponse: Decodable {
    var status: Int {get}
    var message: String {get}
}

struct NewUserResponse: BaseResponse {
    var status: Int
    var message: String
    var uid: String
}

struct ConfigResponse: BaseResponse {
    var status: Int
    var message: String
    let atkey: String
    let skKey: String
}

struct MessagesResponse: BaseResponse {
    var status: Int
    var message: String
    var messages: [MessageModel]
}

func fetchConfig() -> Promise<ConfigResponse> {
    let q = DispatchQueue.global()
    return Alamofire.request("http://api.ylzhu.site/api/config", method: .get).responseData().map(on: q, { (arg) -> ConfigResponse in
        let (data, _) = arg
        return try JSONDecoder().decode(ConfigResponse.self, from: data)
    })
}

func postAddNewUser(name: String) -> Promise<NewUserResponse> {
    let q = DispatchQueue.global()
    return Alamofire.request("http://api.ylzhu.site/api/signup", method: .post, parameters: ["name": name]).responseData().map(on: q, { (arg) -> NewUserResponse in
        let (data, _) = arg
        return try JSONDecoder().decode(NewUserResponse.self, from: data)
    })
}

func fetchMessages() -> Promise<MessagesResponse> {
    let q = DispatchQueue.global()
    return Alamofire.request("http://api.ylzhu.site/api/message/messages", method: .get).responseData().map(on: q, { (arg) -> MessagesResponse in
        let (data, _) = arg
        return try JSONDecoder().decode(MessagesResponse.self, from: data)
    })
}

func postAddNewMessage(uid: String, message: String? = "") {
    
}


