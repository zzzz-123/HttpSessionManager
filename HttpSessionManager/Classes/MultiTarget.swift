//
//  MultiTarget.swift
//  Networking
//
//  Created by ZhengRS on 2018/11/8.
//  Copyright © 2018年 ZhengRS. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/// Converter: convert TargetType to TargetType.
/// to allow modify target property, 'MultiTarget' designed to 'Class' object.
public final class MultiTarget {
    
    public init(_ sourceTarget: TargetType) {
        
        /// TODO: Record properties.
        /// 1.baseURL & customURL:
        baseURL = HttpSessionManager.shared.config.getBaseURL(path: sourceTarget.path)
        customURL = sourceTarget.customURL
        /// 2.path
        path = sourceTarget.path
        /// 3.method
        method = sourceTarget.method
        /// 4.parameters.
        parameters = sourceTarget.parameters
        /// 5.encode.
        parameterEncoding = sourceTarget.parameterEncoding
        /// 6.encrypt method
        encryptMethod = sourceTarget.encryptReqeustParameters(_:)
        /// 7.headers
        headers = HttpSessionManager.shared.config.headers
        /// 8. decrypt method.
        decryptMethod = sourceTarget.decryptRequestResult(_:)
        /// 9. is need retry when failed.
        shouldRetryFailed = sourceTarget.shouldRetryFailed
        /// 10.time out.
        timeoutInterval = sourceTarget.timeoutInterval
    }
    
    /// if target url custom return target url, or return common url.
    public var baseURL: URL
    
    /// custom URL.
    public var customURL: URL?
    
    /// API method name.
    public var path: String
    
    /// The HTTP method used in the request.
    public var method: HTTPMethod
    
    /// The headers to be used in the request.
    public var headers: [String : String]?
    
    /// encrypt method.
    public var encryptMethod:([String: Any]) -> [String: Any]?
    
    /// decrypt method.
    public var decryptMethod: (JSON) -> JSON?
    
    /// time out interval.
    public var timeoutInterval: TimeInterval
    
    /// is need retry when failed.
    public var shouldRetryFailed: Bool
    
    /// request parameters.
    public var parameters: [String: Any]?
    
    /// encode method.
    public var parameterEncoding: ParameterEncoding
    
    /// use for future.
    public var extDict: [String: Any]?
}

