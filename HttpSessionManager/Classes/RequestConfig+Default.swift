//
//  RequestConfig.swift
//  Networking
//
//  Created by ZhengRS on 2018/11/15.
//  Copyright © 2018年 ZhengRS. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

/// Moya default configuration.
public class DefaultRequestConfig: RequestConfigProtocol {
    
    /// Adding to path ,retrun URL.
    public func getBaseURL(path: String) -> URL {
        return URL(string: "https://github.com")!
    }
    
    /// request headers
    public var headers: [String: String]? {
        return nil
    }
    
    /// Alamofire.SessionManager.
    public var manager: SessionManager {
        return SessionManager.default
    }
    
    /// plugins used to special deal .
    public var plugins: [PluginProtocol] {
        return []
    }
    
    /// parameters encoding.
    public var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    /// request method.
    public var requestMethod: HTTPMethod {
        return .post
    }
    
    /// auto retry once when request failed.
    public var shouldRetryFailed: Bool {
        return false
    }
    
    /// request successed statusCode.
    public var successStatusCode: [Int] {
        return Array(200..<300)
    }
    
    /// merge pulbic parameters method
    public func mergePulbicParameters(_ params: [String : Any]?, methodName: String) -> [String : Any] {
        return params == nil ? [:] : params!
    }
    
    // common encrypt method, include merge common parameters.
    public func encryptReqeustParameters(_ params: [String : Any], methodName: String) -> [String : Any]? {
        return params
    }
    
    /// common decrypt method.
    public func decryptRequestResult(_ jsonData: JSON, methodName: String) -> JSON? {
        return jsonData
    }
    
    /// time out
    public var timeoutInterval: TimeInterval {
        return 10
    }
    
    /// server return code if request successed.
    public var successReturnCode: Int {
        return 1
    }
    
    /// key of 'ReturnCode'
    public var returnCodeKey: String {
        return "ReturnCode"
    }
    
    /// key of 'ReturnMessage'
    public var returnMsgKey: String {
        return "ReturnMessage"
    }
    
    /// key of 'Data'
    public var dataKey: String {
        return "Data"
    }
    
    /// bad network message.
    public var badNetworkTip: String {
        return "网络不给力，请稍后再试"
    }
    
    /// server error message.
    public var serverErrorTip: String {
        return "哎呀，加载出错了〜"
    }
    
}
