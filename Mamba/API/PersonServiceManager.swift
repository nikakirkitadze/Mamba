//
//  PersonServiceManager.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/29/20.
//

import Foundation

class PersonServiceManager {
    
    static func getPerson(by personId: Int, completion: @escaping (Person) -> ()) {
        let params: [String:String] = [
            "api_key":ApiConfiguration.apiKey,
            "person_id": "\(personId)"
        ]
        WebServiceManager.shared.get(endpoint: "person/\(personId)", params: params) { (result: Result<Person?, NeoError>) in
            switch result {
            case .success(let response):
                guard let response = response else {return}
                completion(response)
            case .failure(let err):
                Log.error(err)
            }
        }
    }
    
}
