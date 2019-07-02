//
//  RequestsExecutionManager.swift
//  TestAppLastFM
//
//  Created by admin on 7/2/19.
//  Copyright © 2019 MaksymOdessa. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

enum Response<Value> {
    case success(Value?)
    case failure(Error?)
    
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
    var isFailure: Bool { return !isSuccess }
    
    var value: Value? {
        switch self {
        case .success(let value): return value
        case .failure: return nil
        }
    }
    var error: Error? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
}

public class RequestsExecutionManager {
    
    public init() {}
    
    public func createRequest<T:BaseRequest>(with config: ConfigManager) -> T {
        let request = T(config: config)
        return request
    }
    
    public func executeRequest<T:BaseResponse>(
        _ request: BaseRequest,
        completion: @escaping(Response<T>)->Void)
    {
        guard let url = URL(string: request.url()) else {
            //            completion(.failure(OperationError.internalServerError))
            return
        }
        
        let afnRequest =
            Alamofire.request(
                url                             ,
                method    : request.httpMethod(),
                parameters: request.parameters(),
                encoding  : request.encoding())
        
        #if DEBUG
        print("executeRequest - \(afnRequest.debugDescription)")
        #endif
        
        afnRequest.validate().responseObject
            {
                (response: DataResponse<T>) in
                
                #if DEBUG
                print("executeRequest - response - \n \(response.debugDescription)")
                
                if let url = response.request?.url
                {
                    print("executeRequest - response url - \(url)")
                }
                
                if let data = response.data
                {
                    let maybeDataText = String(data: data, encoding: .utf8)
                    let dataText = maybeDataText ?? "empty"
                    print("executeRequest - response data - \(dataText)")
                }
                
                if let error = response.error
                {
                    print("executeRequest - response error - \(error)")
                }
                #endif
                
                if let value = response.value
                {
                    completion(.success(value))
                }
                else
                {
                    completion(.failure(response.error))
                }
        }
    }
}


