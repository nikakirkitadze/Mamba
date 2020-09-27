//
//  APP.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import Foundation

class APP {
    public static func configure(withApiKey apiKey: String, withApiUrl url: String? = nil) {
        WebServiceManager.shared.configure(with: apiKey)
        
        if let apiUrl = url {
            WebServiceManager.shared.setApiUrl(url: apiUrl)
        }
    }
}
