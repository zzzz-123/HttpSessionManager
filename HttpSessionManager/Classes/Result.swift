//
//  RequestResult.swift
//  TuanDaiV4
//
//  Created by ZhengRS on 2017/8/19.
//  Copyright © 2017年 Dee. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum ErrorType {
    case badNetwork      //网络异常
    case serverError     //服务器异常
    case decryptError    //解密错误
    case dataError       //数据异常
    case wrongReturnCode //错误的returnCode
}

public protocol SuccessProtocol {
    /// 数据
    var data: JSON { get }
    
    /// 服务器返回信息
    var returnMsg: String? { get }
}

public protocol FailureProtocol {
    /// 状态码
    var statusCode: Int? { get }
    
    /// 服务器返回的returnCoe
    var returnCode: Int? { get }
    
    /// 错误信息，提供给界面显示时
    var returnMsg: String { get }
    
    /// 服务器返回的data
    var data: JSON { get }
    
    /// 是否取消网络请求标记
    var isCancel: Bool { get }
    
    /// 错误信息
    var error: Error? { get }
    
    /// 失败的类型
    var type: ErrorType { get }
}

/// 请求成功的实体.
public struct Success: SuccessProtocol {
    public var data: JSON = JSON("")
    public var returnMsg: String?
}

/// 请求失败的实体.
public struct Failure: FailureProtocol {
    
    public var error: Error?
    public var statusCode: Int?
    public var returnCode: Int?
    public var returnMsg: String = ""
    public var data: JSON = JSON("")
    public var isCancel: Bool = false
    public var type: ErrorType = .serverError
    init(statusCode: Int?, returnMsg: String, type: ErrorType) {
        self.statusCode = statusCode
        self.returnMsg = returnMsg
        self.type = type
    }
}

/// 请求结果
///
/// - success: 成功的数据
/// - failure: 失败的数据
public enum Result<T: SuccessProtocol, E: FailureProtocol> {
    
    case success(T)
    case failure(E)
    
    public init(value: T) {
        self = .success(value)
    }
    
    public init(value: E) {
        self = .failure(value)
    }
}

