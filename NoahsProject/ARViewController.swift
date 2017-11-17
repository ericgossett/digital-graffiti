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

// hard coded data for testing
let targetList = ["tabby cat", "iPod", "dog"]

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var identifiedObject: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Button(_ sender: Any) {
        performImageRecognition()
    }
    
    func performImageRecognition(){
        // Create anchor using the camera's current position
        if let currentFrame = sceneView.session.currentFrame {
            // Create a transform with a translation of 0.2 meters in front of the camera
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.2
            let transform = simd_mul(currentFrame.camera.transform, translation)
            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
            DispatchQueue.global(qos: .background).async {
                do {
                    let model = try VNCoreMLModel(for: Inceptionv3().model)
                    let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
                        // Jump onto the main thread
                        DispatchQueue.main.async {
                            // Access the first result in the array after casting the array as a VNClassificationObservation array
//                            guard let results = request.results as? [VNClassificationObservation], let result = results.first else {
//                                self.identifiedObject.text = "No results?"
//                                return
//                            }
                            guard let results = request.results as? [VNClassificationObservation], let result = results.first else {
                                self.identifiedObject.text = "No results?"
                                return
                            }
                            if self.checkTargetList(str: result.identifier){
                                self.addaModel()
                            }
                            self.identifiedObject.text = result.identifier
                            // Create a transform with a translation of 0.2 meters in front of the camera
                            var translation = matrix_identity_float4x4
                            translation.columns.3.z = -0.3
                            let transform = simd_mul(currentFrame.camera.transform, translation)
                            // Add a new anchor to the session
                            let anchor = ARAnchor(transform: transform)
                            // Set the identifier
                            //ARBridge.shared.anchorsToIdentifiers[anchor] = result.identifier
                            self.sceneView.session.add(anchor: anchor)
                        }
                    })
                    let handler = VNImageRequestHandler(cvPixelBuffer: currentFrame.capturedImage, options: [:])
                    try handler.perform([request])
                } catch {}
            }
        }
    }
    
    func checkTargetList(str: String) -> Bool{
        for string in targetList{
            if(string == str){
                return true
            }
        }
        return false
    }
    
    func addaModel(){
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPositionOfCamera = orientation + location
        let targetPosition = SCNVector3(currentPositionOfCamera.x,currentPositionOfCamera.y,currentPositionOfCamera.z - 0.3)
        
        let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
        sphereNode.position = targetPosition
        self.sceneView.scene.rootNode.addChildNode(sphereNode)
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.cyan
    }
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
