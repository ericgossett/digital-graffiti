//
//  ModelManager.swift
//  NoahsProject
//
//  Created by egossett on 11/6/17.
//  Copyright © 2017 Duke University. All rights reserved.
//

import Foundation
import ModelIO
import SceneKit
import SceneKit.ModelIO


enum ModelManagerError: Error {
    case AssetFilesNotFound
}


class ModelManager {
    let api = APIClient()
    var assetURL: URL
    
    init() {
        let fileManager = FileManager.default
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        assetURL = documentsDirectory.appendingPathComponent("Assets")
        if !fileManager.fileExists(atPath: assetURL.path){
            do {
                try fileManager.createDirectory(atPath: assetURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
               NSLog("Couldn't create document directory")
            }
        }
    }
    
    func saveAssets(username: String, completion: ((URL, URL) -> Void)?) {
        self.api.fetchModel(username: username) { (modelData) in
            self.api.fetchTexture(username: username) { textureData in
                let modelFile = self.assetURL.appendingPathComponent("\(username)_model.obj")
                try? modelData.write(to: modelFile, options: .atomic)
                let textureFile = self.assetURL.appendingPathComponent("\(username)_texture.obj")
                try? textureData.write(to: textureFile, options: .atomic)
                completion?(modelFile, textureFile)
            }
        }
    }
    
    func loadAssets(username: String)  throws -> (modelFile: URL, textureFile: URL) {
        let modelFile = assetURL.appendingPathComponent("\(username)_model.obj")
        let textureFile = assetURL.appendingPathComponent("\(username)_texture.obj")

        if !FileManager.default.fileExists(atPath: modelFile.path) && !FileManager.default.fileExists(atPath: textureFile.path) {
            throw ModelManagerError.AssetFilesNotFound
        }
        return (modelFile: modelFile, textureFile: textureFile)
    }
    
    func deleteAssets(username: String) throws {
        let modelFile = assetURL.appendingPathComponent("\(username)_model.obj")
        let textureFile = assetURL.appendingPathComponent("\(username)_texture.obj")
        do {
            try FileManager.default.removeItem(atPath: modelFile.path)
            try FileManager.default.removeItem(atPath: textureFile.path)
        } catch {
            throw ModelManagerError.AssetFilesNotFound
        }
    }
    
    func getSCNNode(username: String) throws -> SCNNode {
        do {
            let assets = try loadAssets(username: username)
            let model = MDLAsset(url: assets.modelFile)
            let object = model.object(at: 0) as! MDLMesh
            let scatteringFunction = MDLScatteringFunction()
            
            let material = MDLMaterial(
                name: "baseMaterial",
                scatteringFunction: scatteringFunction
            )
            
            let matProp = MDLMaterialProperty(
                name: "\(username)_texture.jpg",
                semantic: .baseColor,
                url: assets.textureFile
            )
            material.setProperty(matProp)
        
            
            for submesh in object.submeshes! {
                if let mesh = submesh as? MDLSubmesh {
                    mesh.material = material
                }
            }
            
            return SCNNode.init(mdlObject: object)
            
        } catch {
            throw ModelManagerError.AssetFilesNotFound
        }
    }
}
