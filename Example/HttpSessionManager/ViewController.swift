//
//  ViewController.swift
//  HttpSessionManager
//
//  Created by zhengrusong on 05/30/2019.
//  Copyright (c) 2019 zhengrusong. All rights reserved.
//

import UIKit
import HttpSessionManager

enum UserAPI {
    //获取用户信息
    case userInfo
    //修改用户信息
    case modifyNickname(nickname: String)
}

extension UserAPI: TargetType {
    var path: String {
        switch self {
        case .userInfo:
            return "UserInfo"
        case .modifyNickname:
            return "modifyNickname"
        }
    }
    var parameters: [String : Any]? {
        switch self {
        case .userInfo:
            return nil
        case let .modifyNickname(nickname: nickname):
            return ["nickname": nickname]
        }
    }
    // ...每个网络请求接口，TargetType协议里的实现可不一样。
    /// Optional。比如每个接口 可以有不同的请求地址。
    var customURL: URL? {
        switch self {
        case .userInfo:
            return URL.init(string: "a地址")
        case .modifyNickname:
            return URL.init(string: "b地址")
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //3.发起网络请求
        HttpSessionManager.shared.request(target: MultiTarget(UserAPI.userInfo)) { result in
            switch result {
            case .success(let successRes):
                print(successRes)
            case .failure(let failRes):
                print(failRes.returnMsg)
            }
        }
    }
}

