//
//  NewsApiConvenience.swift
//  LocationNews
//
//  Created by Kiko Santos on 10/01/19.
//  Copyright © 2019 Kiko Santos. All rights reserved.
//

import Foundation

extension NewsApiClient {
    
    func retrieveNews(_ query: String, completionHandlerForRetrieveNews: @escaping (_ result: AnyObject?, _ errorString: String?) -> Void) {
        
        print("\"\(query)\"")
        let parameters: [String: AnyObject] = [
            URLKeys.Query: "\"\(query)\"" as AnyObject
        ]
        
        let _ = taskForGETMethod(Methods.Everything, parameters: parameters) { (results, error) in
            if let error = error {
                completionHandlerForRetrieveNews(nil, "Failed to Load Photos: \(error.localizedDescription).")
            } else {
                completionHandlerForRetrieveNews(results, nil)
            }
        }
    }

}
