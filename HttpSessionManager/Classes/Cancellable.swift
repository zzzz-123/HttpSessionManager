//
//  Cancellable.swift
//  TuanDaiV4
//
//  Created by ZhengRS on 2018/11/19.
//  Copyright © 2018年 Dee. All rights reserved.
//

import Foundation
import Alamofire

/// Protocol to define the opaque type returned from a request.
public protocol Cancellable {
    
    /// Cancels the represented request.
    func cancel()
}

extension DataRequest: Cancellable {
    
}
