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
    var message: String? {get}
}

struct NewUserResponse: BaseResponse {
    var status: Int
    var message: String?
    var uid: String
}

struct UserResponse: BaseResponse {
    var status: Int
    var message: String?
    var name: String
}
struct ConfigResponse: BaseResponse {
    var status: Int
    var message: String?
    let atkey: String
    let skKey: String
}

struct MessagesResponse: BaseResponse {
    var status: Int
    var message: String?
    var messages: [MessageModel]
    var pageInfo: PageInfoModel
}

struct NewMessageResponse: BaseResponse {
    var status: Int
    var message: String?
    var messageid: String?
}

let hostAPI = "http://api.ylzhu.site/api"

//获取配置信息
func fetchConfig() -> Promise<ConfigResponse> {
    return networkUtil(request: Alamofire.request("\(hostAPI)/config", method: .get))
}

//获取用户数据
func fetchUserInfo(uid: String) -> Promise<UserResponse> {
    return networkUtil(request: Alamofire.request("\(hostAPI)/user/\(uid)", method: .get))
}

//获取消息列表
func fetchMessages(page: Int) -> Promise<MessagesResponse> {
    return networkUtil(request: Alamofire.request("\(hostAPI)/message/messages", method: .get, parameters: ["page": page, "pageNum": "20"]))
}

//创建新用户
func postAddNewUser(name: String) -> Promise<NewUserResponse> {
    return networkUtil(request: Alamofire.request("\(hostAPI)/signup", method: .post, parameters: ["name": name]))
}

func postAddNewMessage(_ uid: String, message: String? = nil, images: String? = nil, video: String? = nil, audio: String? = nil) -> Promise<NewMessageResponse> {
    var params = [String: String]()
    if let message_p = message {
        params["message"] = message_p
    }
    
    if let images_p = images {
        params["images"] = images_p
    }
    
    if let video_p = video {
        params["video"] = video_p
    }
    
    if let audio_p = audio {
        params["audio"] = audio_p
    }
    
    params["uid"] = uid
    
    return networkUtil(request: Alamofire.request("\(hostAPI)/message/send", method: .post, parameters: params))
}


func networkUtil<T:Decodable>(request: DataRequest) -> Promise<T> {
    
    let q = DispatchQueue.global()
    return request.responseData().map(on: q, { (arg) -> T in
        let (data, _) = arg
        debugPrint("===============")
        debugPrint(request)
        debugPrint(try JSONSerialization.jsonObject(with: data, options: .allowFragments))
        debugPrint("===============")
        
        return try JSONDecoder().decode(T.self, from: data)
    })
}


