//
//  sample.swift
//  CommonAPI
//
//  Created by DevGabi on 2020/08/05.
//  Copyright © 2020 devgabi. All rights reserved.
//

import Foundation

struct TopLevel: Codable {
    let userID, id: String
    let title: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}

extension API {
    class func sampleAPI() -> API {
        let query = ["test": "1"]
        let sampleAPI = API()
        sampleAPI.request
            .setScheme(scheme: .HTTPS)
            .setDomain(domain: "jsonplaceholder.typicode.com")
            .setPath(path: "/todos/1")
            .setQuary(query: query)
        
        sampleAPI.response.parse = { responseData in
            guard let responseData = responseData as? Data else { return nil }
            print(responseData)
            do {
                let codable = try JSONDecoder().decode(TopLevel.self, from: responseData)
                return codable
            } catch {
                return error
            }
        }
        
        return sampleAPI
    }
}
            
