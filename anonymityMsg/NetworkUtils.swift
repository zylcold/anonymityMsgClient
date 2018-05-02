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
}

struct Response: BaseResponse {
    var status: Int
    var message: String
}

struct ConfigModel:BaseResponse {
    let atkey: String
    let skKey: String
    var status: Int
}

func fetchConfig() -> Promise<ConfigModel>{
    let q = DispatchQueue.global()
    return Alamofire.request("http://api.ylzhu.site/api/config", method: .get).responseData().map(on: q, { (arg) -> ConfigModel in
        let (data, _) = arg
        return try JSONDecoder().decode(ConfigModel.self, from: data)
    })
}

func postAddNewUser(name: String) -> Promise<Response> {
    let q = DispatchQueue.global()
    return Alamofire.request("http://api.ylzhu.site/api/signup", method: .post, parameters: ["name": name]).responseData().map(on: q, { (arg) -> Response in
        let (data, _) = arg
        return try JSONDecoder().decode(Response.self, from: data)
    })
}


