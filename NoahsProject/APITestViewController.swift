//
//  APITestViewController.swift
//  NoahsProject
//
//  Created by egossett on 11/3/17.
//  Copyright © 2017 Duke University. All rights reserved.
//

import UIKit
import ModelIO
import SceneKit
import SceneKit.ModelIO

class APITestViewController: UIViewController {
    @IBOutlet weak var tag: UIImageView!
    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let api = APIClient()
        var artist = [Artist]()
        api.fetchUserList() { (result) in
            artist = result
            print(artist[0])
            api.fetchTag(username: artist[0].username) { imageData in
                self.tag.image = UIImage(data: imageData)
            }
            
            api.fetchModel(username: artist[0].username) { modelData in
                let dir = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
                let newFile =  dir.appendingPathComponent("xwing.obj")
                
                try? modelData.write(to: newFile, options: .atomic)
                let asset = MDLAsset(url: newFile)
                print(asset)
                let object = asset.object(at: 0) as! MDLMesh
                print(object)

                
                api.fetchTexture(username: artist[0].username) { textureData in
                    let textureFile = dir.appendingPathComponent("xwing_texture.jpg")
                    try? textureData.write(to: textureFile, options: .atomic)
                    let fileManager = FileManager()
                    if  fileManager.fileExists(atPath: textureFile.path) {
                        print("FILE AVAILABLE")
                    } else {
                        print("FILE NOT AVAILABLE")
                    }
                    
                    let scatteringFunction = MDLScatteringFunction()
                    let material = MDLMaterial(
                        name: "baseMaterial",
                        scatteringFunction: scatteringFunction
                    )
                    let matProp = MDLMaterialProperty(
                        name: "xwing_texture.jpg",
                        semantic: .baseColor,
                        url: textureFile
                    )
                    material.setProperty(matProp)
                    
                    print(matProp)
                    
                    for submesh in object.submeshes! {
                        if let mesh = submesh as? MDLSubmesh {
                            mesh.material = material
                        }
                    }
                    
                    let node = SCNNode.init(mdlObject: object)
                    print(node)
                    // Apply texture to every submesh in the object
                    let scene = SCNScene()
                    scene.rootNode.addChildNode(node)
                    self.sceneView.autoenablesDefaultLighting = true
                    self.sceneView.allowsCameraControl = true
                    self.sceneView.scene = scene
                    //self.sceneView.backgroundColor = UIColor.blackColor()
                }
                
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
