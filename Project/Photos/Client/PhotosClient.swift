//
//  PhotosClient.swift
//
//  Created by Mark on 4/3/18.
//  Copyright © 2018 Sherdle. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class PhotosClient {
    
    public init(){}
    
    public func get(provider: PhotosProvider, params: [String], forPage: Int, completionHandler: @escaping (Bool, [Photo]?) -> Void) {
        
        if (provider is WordpressProvider) {
            (provider as! WordpressProvider).parseRequest(params: params, page: forPage, completionHandler: completionHandler)
        } else {
            var result: [Photo]?
            
            Alamofire.request(provider.getRequestUrl(params: params, page: forPage)!).responseString{ response in
                print("Request: \(String(describing: response.request))")   // original url request
                
                if (response.result.isFailure){
                     completionHandler(false, nil)
                    return
                }

                DispatchQueue.global(qos: .background).async {
                    
                    result = provider.parseRequest(params: params, json: response.result.value!)
                    
                    DispatchQueue.main.async {
                        completionHandler(true, result!)
                    }
                }
            }
        }
        
    }
    
}
