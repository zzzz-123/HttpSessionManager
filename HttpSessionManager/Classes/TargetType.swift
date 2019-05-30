//
//  TargetProtocol.swift
//  Networking
//
//  Created by ZhengRS on 2018/11/15.
//  Copyright © 2018年 ZhengRS. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public protocol TargetType {
    
    /// The target's custom `URL`.
    var customURL: URL? { get }
    
    /// Request API Name.
    var path: String { get }
    
    /// request target parameters.
    var parameters: [String: Any]? { get }
    
    /// parameter encoding.
    var parameterEncoding: ParameterEncoding { get }
    
    /// request time out.
    var timeoutInterval: TimeInterval { get }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    
    // common encrypt method, include merge common parameters.
    func encryptReqeustParameters(_ params: [String: Any]) -> [String: Any]?
    
    /// common decrypt method.
    func decryptRequestResult(_ jsonData: JSON) -> JSON?
    
    /// auto retry once before invoke callback when request failed.
    var shouldRetryFailed: Bool { get }
}

extension TargetType {
    
    /// The target's custom `URL`.
    public var customURL: URL? {
        return nil
    }
    
    /// parameter encoding.
    public var parameterEncoding: ParameterEncoding {
        return HttpSessionManager.shared.config.parameterEncoding
    }
    
    /// The HTTP method used in the request.
    public var method: HTTPMethod {
        return HttpSessionManager.shared.config.requestMethod
    }
    
    // encrypt.
    public func encryptReqeustParameters(_ params: [String: Any]) -> [String: Any]? {
        return HttpSessionManager.shared.config.encryptReqeustParameters(params, methodName: path)
    }
    
    /// decrypt.
    public func decryptRequestResult(_ jsonData: JSON) -> JSON? {
        return HttpSessionManager.shared.config.decryptRequestResult(jsonData, methodName: path)
    }
    
    /// Request time out.
    public var timeoutInterval: TimeInterval {
        return HttpSessionManager.shared.config.timeoutInterval
    }
    
    /// auto retry once before invoke callback when request failed.
    public var shouldRetryFailed: Bool {
        return HttpSessionManager.shared.config.shouldRetryFailed
    }
}
