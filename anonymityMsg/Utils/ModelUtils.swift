//
//  ModelUtils.swift
//  anonymityMsg
//
//  Created by Yun on 2018/5/2.
//  Copyright © 2018 com.ZhuYunLong. All rights reserved.
//

import Foundation
struct MessageModel: Decodable {
    var message: String?
    var images: String?
    var video: String?
    var audio: String?
    var user_name: String?
}

struct PageInfoModel: Decodable {
    var totalCount: Int
    var currentPage: Int
    var pageNum: Int
    var totalPage: Int
}
