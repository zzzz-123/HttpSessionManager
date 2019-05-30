//
//  PluginProtocol.swift
//  Networking
//
//  Created by ZhengRS on 2018/11/12.
//  Copyright © 2018年 ZhengRS. All rights reserved.
//

import Foundation


/// supply plugin protocols.
public protocol PluginProtocol {
    
    /// invoke when provider will send request.
    ///
    /// - Parameter target: request target.
    func willSend(target: MultiTarget)
    
    /// invoke after provider received response ,before invoke callBack.
    ///
    /// - Parameters:
    ///   - result: response data after decrypt.
    ///   - target: request target
    func didReceive(result: Result<Success, Failure>, target: MultiTarget)
    
    /// auto retry request.
    ///
    /// - Parameter target: request target
    func willRetry(target: MultiTarget)
}

extension PluginProtocol {
    /// invoke when provider will send request.
    ///
    /// - Parameter target: request target.
    func willSend(target: MultiTarget) {}
    
    /// auto retry request.
    ///
    /// - Parameter target: request target
    func willRetry(target: MultiTarget) {}
    
    /// invoke after provider received response ,before invoke callBack.
    ///
    /// - Parameters:
    ///   - result: response data after decrypt.
    ///   - target: request target
    func didReceive(result: Result<Success, Failure>, target: MultiTarget) {}
}
