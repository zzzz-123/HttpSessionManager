//
//  SessionManager.swift
//  Networking
//
//  Created by ZhengRS on 2018/11/15.
//  Copyright © 2018年 ZhengRS. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/// response callback.
public typealias Completion = (_ result: Result<Success, Failure>) -> Void

public class HttpSessionManager {
    
    /// shared.
    public static var shared: HttpSessionManager = HttpSessionManager()
    private init() { }
    /// network configuration.
    public var config: RequestConfigProtocol = DefaultRequestConfig()
    
    /// 保证网络请求使用同一个sessionManager. 不能直接使用config.manager就行请求。
    private lazy var sessionManager: SessionManager = {
        return config.manager
    }()
    
    private lazy var plugins: [PluginProtocol] = {
        return config.plugins
    }()
    
    /// send request.
    ///
    /// - Parameters:
    ///   - target: request target.
    ///   - queue: queue for callback.
    ///   - progress: response progress.
    ///   - completion: request completed callback.
    @discardableResult
    public func request(target: MultiTarget, callBack: @escaping Completion)  -> Cancellable {
        
        let request = urlRequest(target: target)
        plugins.forEach {
            $0.willSend(target: target)
        }
        return sessionManager.request(request).validate(statusCode: config.successStatusCode).responseJSON { (dataResponse) in
            let statusCode = dataResponse.response?.statusCode
            let res = dataResponse.result
            switch res {
            case .success(let successRes):
                var responseJson = JSON(successRes)
                if let json = target.decryptMethod(responseJson) {
                    responseJson = json
                } else {
                    let failRes = Failure(statusCode: statusCode, returnMsg: self.config.serverErrorTip, type: .decryptError)
                    let result = Result<Success, Failure>(value: failRes)
                    self.plugins.forEach {
                        $0.didReceive(result: result, target: target)
                    }
                    callBack(result)
                    return
                }
                let returnCode = responseJson[self.config.returnCodeKey].int
                let returnMsg = responseJson[self.config.returnMsgKey].string
                let data = responseJson[self.config.dataKey]
                if let returnCode = returnCode, returnCode == self.config.successReturnCode {
                    let successRes = Success(data: data, returnMsg: returnMsg)
                    let result = Result<Success, Failure>(value: successRes)
                    self.plugins.forEach {
                        $0.didReceive(result: result, target: target)
                    }
                    callBack(result)
                } else { // returnCode unNormal.
                    let msg = (returnMsg != nil && !returnMsg!.isEmpty) ? returnMsg! : self.config.serverErrorTip
                    var failRes = Failure(statusCode: statusCode, returnMsg: msg, type: .wrongReturnCode)
                    failRes.returnCode = returnCode
                    failRes.data = data
                    let result = Result<Success, Failure>(value: failRes)
                    self.plugins.forEach {
                        $0.didReceive(result: result, target: target)
                    }
                    callBack(result)
                }
            case .failure(let error):
                var failRes = Failure(statusCode: statusCode, returnMsg: self.config.serverErrorTip, type: .serverError)
                failRes.error = error
                failRes.isCancel = false
                switch (error as NSError).code {
                case NSURLErrorCancelled:
                    // request cancelled.
                    failRes.isCancel = true
                    print("接口:\(target.path)网络请求已被取消")
                case NSURLErrorTimedOut, NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet:
                    // Bad Network.
                    failRes.returnMsg = self.config.badNetworkTip
                    failRes.type = .badNetwork
                default: break
                }
                let result = Result<Success, Failure>(value: failRes)
                self.plugins.forEach {
                    $0.didReceive(result: result, target: target)
                }
                if !failRes.isCancel && target.shouldRetryFailed {
                    self.plugins.forEach {
                        $0.willRetry(target: target)
                    }
                    /// 只重发一次。
                    target.shouldRetryFailed = false
                    self.request(target: target, callBack: callBack)
                } else {
                    callBack(result)
                }
            }
        }
    }
    
    /// 将target转化为URLRequest
    ///
    /// - Parameter target: 请求的目标
    /// - Returns: 转换后的Request对象
    private func urlRequest(target: MultiTarget) -> URLRequest {
        var url = target.customURL == nil ? target.baseURL : target.customURL!
        url = url.appendingPathComponent(target.path)
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        request.allHTTPHeaderFields = target.headers
        request.timeoutInterval = target.timeoutInterval
        let paramters = HttpSessionManager.shared.config.mergePulbicParameters(target.parameters, methodName: target.path)
        let encryptParamters = target.encryptMethod(paramters)
        do {
            let request2 = try target.parameterEncoding.encode(request, with: encryptParamters)
            return request2
        } catch {
            return request
        }
    }
}

extension HttpSessionManager {
    
    /// 同步请求
    ///
    /// - Parameters:
    ///   - target: 请求体
    ///   - callBack: 结果回调。注此回调是在异步线程。
    public func syncRequest(target: MultiTarget, callBack: @escaping Completion) {
        
        /// create semaphore.
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.init(label: "syncRequest")
        let request = urlRequest(target: target)
        /// send network request.
        sessionManager.request(request).validate(statusCode: config.successStatusCode).responseJSON(queue: queue, options: .allowFragments) { dataResponse in
            /// send signal before return.
            defer {
                semaphore.signal()
            }
            let statusCode = dataResponse.response?.statusCode
            let res = dataResponse.result
            switch res {
            case .success(let successRes):
                var responseJson = JSON(successRes)
                if let json = target.decryptMethod(responseJson) {
                    responseJson = json
                } else {
                    let failRes = Failure(statusCode: statusCode, returnMsg: self.config.serverErrorTip, type: .decryptError)
                    callBack(Result(value: failRes))
                    return
                }
                let returnCode = responseJson[self.config.returnCodeKey].int
                let returnMsg = responseJson[self.config.returnMsgKey].string
                let data = responseJson[self.config.dataKey]
                if let returnCode = returnCode, returnCode == self.config.successReturnCode {
                    let successRes = Success(data: data, returnMsg: returnMsg)
                    callBack(Result(value: successRes))
                } else { // returnCode unNormal.
                    let msg = (returnMsg != nil && !returnMsg!.isEmpty) ? returnMsg! : self.config.serverErrorTip
                    var failRes = Failure(statusCode: statusCode, returnMsg: msg, type: .wrongReturnCode)
                    failRes.returnCode = returnCode
                    failRes.data = data
                    callBack(Result(value: failRes))
                }
            case .failure(let error):
                var failRes = Failure(statusCode: statusCode, returnMsg: self.config.serverErrorTip, type: .serverError)
                failRes.error = error
                failRes.isCancel = false
                switch (error as NSError).code {
                case NSURLErrorCancelled:
                    // request cancelled.
                    failRes.isCancel = true
                    print("接口:\(target.path)网络请求已被取消")
                case NSURLErrorTimedOut, NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet:
                    // Bad Network.
                    failRes.returnMsg = self.config.badNetworkTip
                    failRes.type = .badNetwork
                default: break
                }
                callBack(Result(value: failRes))
            }
        }
        semaphore.wait()
    }
}
