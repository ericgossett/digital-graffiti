//
//  APIClient.swift
//  NoahsProject
//
//  Created by egossett on 11/3/17.
//  Copyright © 2017 Duke University. All rights reserved.
//

import Foundation
import UIKit

let DEV_MODE = false


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
    
    var apiURL = URLComponents()
    
    init() {
        apiURL.scheme = "http"
        apiURL.host = (DEV_MODE) ? "127.0.0.1" : "vcm-2006.vm.duke.edu"
        print("host: \(apiURL.host!)")
    }
    
    func testConnection(completion: ((Bool) -> Void)?) {
        let session = URLSession.shared
        guard let url = apiURL.url else {
            fatalError("throw error no url constructed")
        }
        let task = session.dataTask(with:url) { (loc, resp, err) in
            guard err == nil else {
                print("throw, error no response")
                completion?(false)
                return
            }
            let status = (resp as! HTTPURLResponse).statusCode
            print("response status: \(status)")
            if status != 200 {
                completion?(false)
            }
            completion?(true)
        }
        task.resume()
    }
    
    
    
    /*** Fetches a list of Artist objects from the pieces API endpoint.
    */
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
                    print("error: no response")
                    completion?([])
                    return
                }
                
                let decoder = JSONDecoder()
                
                do {
                    let artists = try decoder.decode([Artist].self, from: jsonData)
                    completion?(artists)
                } catch {
                    // fatalError("Can't decode JSON")
                    completion?([])
                }
            }
        }
        task.resume()
    }
    
    /*** Fetches a file from the server, used internally by APIClient.
    */
    private func fetchFile(file: String, completion: ((Data) -> Void)?) {
        apiURL.path = "/uploads/\(file)"
        guard let endpoint = apiURL.url else {
            fatalError("throw error no url constructed")
        }
        
        var req = URLRequest(url: endpoint)
        req.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: req) {(data, res, error) in
            DispatchQueue.main.async {
                guard error == nil, let fileData = data else {
                    fatalError("throw, error of no response")
                }
                completion?(fileData)
            }
        }
        task.resume()
    }
    
    /*** Facade for fetching tags.
    */
    func fetchTag(username: String, completion: ((Data) -> Void)?) {
        self.fetchFile(file:"\(username)_tag.jpg") { (data) in
            completion?(data)
        }
    }
    
    /*** Facade for fetching 3D Model.
    */
    func fetchModel(username: String, completion: ((Data) -> Void)?) {
        self.fetchFile(file:"\(username)_model.obj") { (data) in
            completion?(data)
        }
    }
    
    /*** Facade for fetching the texture.
    */
    func fetchTexture(username: String, completion: ((Data) -> Void)?) {
        self.fetchFile(file:"\(username)_texture.jpg") { (data) in
            completion?(data)
        }
    }
    
}
