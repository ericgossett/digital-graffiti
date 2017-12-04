//
//  ARViewController.swift
//  NoahsProject
//
//  Created by YUNHAN WANG on 11/16/17.
//  Copyright © 2017 Duke University. All rights reserved.
//

import UIKit
import ARKit
import Vision

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var identifiedObject: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        /* Uncomment lines below to see debug tools (e.g. world origin and feature points) in the ARView */
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        //self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
    }
    
    /* this func is used to take the current frame for a machine learning model (inception v3) and perform image recognition. If one of the image recognition result matches a subscribed artist, will display the associated 3d model associated with that artist */
    func performImageRecognition(){
        // Use current frame as the input of image recognition for the inception v3 model
        if let currentFrame = sceneView.session.currentFrame {
            DispatchQueue.global(qos: .background).async {
                do {
                    let model = try VNCoreMLModel(for: Inceptionv3().model)
                    let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
                        // Jump onto the main thread
                        DispatchQueue.main.async {
                            // Access the first result in the array after casting the array as a VNClassificationObservation array
                            guard let results = request.results as? [VNClassificationObservation], let result = results.first else {
                                self.identifiedObject.text = "No results?"
                                return
                            }
                            // Acess the top 10 classes in the array of results from the inception v3 model
                            if(subscribedArtists.count > 0){
                                for i in 0...subscribedArtists.count - 1{
                                    for j in 0..<10{ // top 10 classes
                                        if(subscribedArtists[i].artist.username == results[j].identifier){
                                            self.loadCustomModel(username: subscribedArtists[i].artist.username)
                                            break
                                        }
                                    }
                                }
                            }
                            self.identifiedObject.text = result.identifier
                        }
                    })
                    let handler = VNImageRequestHandler(cvPixelBuffer: currentFrame.capturedImage, options: [:])
                    try handler.perform([request])
                } catch {}
            }
        }
    }
    
    // Display a 3d model according to the name of a subscribed artist
    func loadCustomModel(username: String){
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPositionOfCamera = orientation + location
        // display the custom model 10 centimeters in front of the current position of the camera
        let targetPosition = SCNVector3(currentPositionOfCamera.x,currentPositionOfCamera.y,currentPositionOfCamera.z - 0.1)

        let modelManager = ModelManager()
        modelManager.saveAssets(username: username) {(modelFile, TextureFile) in
            let node = try! modelManager.getSCNNode(username: username)
            node.position = targetPosition
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    // the press button triggers the performImageRecognition func
    @IBAction func Button(_ sender: Any) {
        performImageRecognition()
    }
    
    // the clear button triggers the restartSession func
    @IBAction func clear(_ sender: Any) {
        restartSession()
    }
    
    // this func is used to remove all the SCNNode from the rootNode and restart session
    func restartSession(){
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// override the + of SCNVector3
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
