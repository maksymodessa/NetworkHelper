//
//  BaseResponse.swift
//  TestAppLastFM
//
//  Created by admin on 6/30/19.
//  Copyright © 2019 MaksymOdessa. All rights reserved.
//

import ObjectMapper

public typealias Map = ObjectMapper.Map

public class BaseResponse: Mappable {
    
    var rawValue: [String: Any]?
    var errors: [BaseResponseError]?
    
    public required init?(map: Map){
    }
    
    public func mapping(map: Map) {
        rawValue = map.JSON
        
        errors <- map["errors"]
    }
    
    class BaseResponseError: BaseResponse {
        var description: String?
        var errorCode: Int?
        
        override func mapping(map: Map) {
            rawValue = map.JSON
            
            description <- map["description"]
            errorCode <- map["errorCode"]
        }
    }
    
    var errorsAsString: String? {
        guard let errs = errors, errs.isEmpty == false  else { return nil }
        
        let errorsStrings = errs.map { (err) -> String in
            return err.description ?? ""
        }
        var strError = errorsStrings.joined(separator: ";\n")
        strError = strError.trimmingCharacters(in: CharacterSet(charactersIn:";\n"))
        if !strError.isEmpty {
            strError += "."
        }
        return strError
    }
}
