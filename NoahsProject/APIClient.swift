//
//  APIClient.swift
//  NoahsProject
//
//  Created by egossett on 11/3/17.
//  Copyright © 2017 Duke University. All rights reserved.
//

import Foundation
import UIKit

let DEV_MODE = true


struct Artist: Codable {
    let username: String
    
    struct FileObject: Codable {
        let name: String
        let url: URL
    }
    
    let tag: FileObject
    let model: FileObject
    let texture: FileObject
}


class APIClient {
    
    let userEndpoint = (DEV_MODE) ? URL(string: "http://127.0.0.1/api/v1/pieces") : URL(string: "http://vcm-2006.vm.duke.edu/api/v1/pieces")
    
    var apiURL = URLComponents()
    
    init() {
        apiURL.scheme = "http"
        apiURL.host = (DEV_MODE) ? "127.0.0.1" : "vcm-2006.vm.duke.edu"
    }
    
    
    func fetchUserList(completion: (([Artist]) -> Void)?) {
        apiURL.path = "/api/v1/pieces"
        guard let endpoint = apiURL.url else {
            fatalError("throw error no url constructed")
        }
        
        var req = URLRequest(url: endpoint)
        req.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: req) {(data, res, error) in
            DispatchQueue.main.async {
                guard error == nil, let jsonData = data else {
                    fatalError("throw, error of no response")
                }
                
                let decoder = JSONDecoder()
                
                do {
                    let artists = try decoder.decode([Artist].self, from: jsonData)
                    completion?(artists)
                } catch {
                    fatalError("Can't decode JSON")
                }
            }
        }
        task.resume()
    }
    
}
