//
//  ConfigProtocol.swift
//  Networking
//
//  Created by ZhengRS on 2018/11/15.
//  Copyright © 2018年 ZhengRS. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public protocol RequestConfigProtocol: class {
    
    /// Adding to path ,retrun URL.
    func getBaseURL(path: String) -> URL
    
    /// merge pulbic parameters method
    func mergePulbicParameters(_ params: [String: Any]?, methodName: String) -> [String: Any]
    
    // common encrypt method, include merge common parameters.
    func encryptReqeustParameters(_ params: [String: Any], methodName: String) -> [String: Any]?
    
    /// common decrypt method.
    func decryptRequestResult(_ jsonData: JSON, methodName: String) -> JSON?
    
    /// request headers
    var headers: [String: String]? { get }
    
    /// Alamofire.SessionManager.
    var manager: SessionManager { get }
    
   /// plugins used to special deal .
    var plugins: [PluginProtocol] { get }
    
    /// parameters encoding.
    var parameterEncoding: ParameterEncoding { get }
    
    /// request method.
    var requestMethod: HTTPMethod { get }
    
    /// auto retry once when request failed.
    var shouldRetryFailed: Bool { get }
    
    /// time out
    var timeoutInterval: TimeInterval { get }
    
    /// request successed statusCode.
    var successStatusCode: [Int] { get }
    
    /// server return code if request successed.
    var successReturnCode: Int { get }
    
    /// key of 'ReturnCode'
    var returnCodeKey: String { get }
    
    /// key of 'ReturnMessage'
    var returnMsgKey: String { get }
    
    /// key of 'Data'
    var dataKey: String { get }
    
    /// bad network message.
    var badNetworkTip: String { get }
    
    /// server error message.
    var serverErrorTip: String { get }
}
