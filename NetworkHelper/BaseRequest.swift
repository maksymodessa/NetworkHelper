//
//  BaseRequest.swift
//  TestAppLastFM
//
//  Created by admin on 6/30/19.
//  Copyright © 2019 MaksymOdessa. All rights reserved.
//

import UIKit
import Alamofire

public typealias HTTPMethod = Alamofire.HTTPMethod

public class BaseRequest: NSObject {
    
    let config: ConfigManager
    
    required init(config: ConfigManager) {
        self.config = config
    }
    
    func httpMethod() -> HTTPMethod {
        return .get
    }
    
    func url() -> String {
        return ""
    }
    
    func parameters() -> [String : Any]? {
        return nil
    }
    
    func encoding() -> ParameterEncoding {
        return URLEncoding.default
    }
}
