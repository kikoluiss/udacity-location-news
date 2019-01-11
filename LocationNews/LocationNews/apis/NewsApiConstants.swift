//
//  NewsApiConstants.swift
//  LocationNews
//
//  Created by Kiko Santos on 10/01/19.
//  Copyright © 2019 Kiko Santos. All rights reserved.
//

import Foundation

extension NewsApiClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Data
        static let ApiKey = "9530dd55a9714c46bd3539bfc4c3c032"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "newsapi.org"
        static let ApiPath = "/v2"
        
    }
    
    // MARK: Methods
    struct Methods {
        static let Everything = "/everything"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let ApiKey = "apiKey"
        static let Query = "q"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let Status = "status"
        static let TotalResults = "totalResults"
        static let Articles = "articles"
        
        // MARK: Articles
        static let Title = "title"
        static let Description = "description"
        static let Url = "url"
        static let UrlToImage = "urlToImage"
        static let PublishedAt = "publishedAt"
        static let Content = "content"
        
    }
    
}
