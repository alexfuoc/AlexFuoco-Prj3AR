//
//  UFOViewController.swift
//  AlexFuoco-Prj3AR
//  UFO 3D MODEL -- https://poly.google.com/view/b0N_HeT_Ttb
//
//  Created by Alex Fuoco on 5/10/21.
//  Sound from Zapsplat.com


import Foundation
import UIKit
import SceneKit
import ARKit

enum BodyType : Int {
    case bullet = 1
    case ship = 2
}

class UFOViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var lastContactNode: SCNNode!
    var shipsHit: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        let scene = setupScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        self.sceneView.scene.physicsWorld.contactDelegate = self
        
        regeisterGestureRecognizers()
    }
    
    // initalizes the scene and all of the nodes
    func setupScene() -> SCNScene {
        
        //Create UFOs to display
        let ufoScene = SCNScene(named: "art.scnassets/ufo.scn")!
        let ufoScene2 = SCNScene(named: "art.scnassets/ufo.scn")!
        let ufoScene3 = SCNScene(named: "art.scnassets/ufo.scn")!
        let ufoScene4 = SCNScene(named: "art.scnassets/ufo.scn")!
        let ufoScene5 = SCNScene(named: "art.scnassets/ufo.scn")!
        
        //Create Nodes
        let ufo = UFO(scene: ufoScene)
        let ufo2 = UFO(scene: ufoScene2)
        let ufo3 = UFO(scene: ufoScene3)
        let ufo4 = UFO(scene: ufoScene4)
        let ufo5 = UFO(scene: ufoScene5)
        
        ufo.name = "Ship1"
        ufo2.name = "Ship2"
        ufo3.name = "Ship3"
        ufo4.name = "Ship4"
        ufo5.name = "Ship5"
        
        ufo.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        ufo2.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        ufo3.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        ufo4.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        ufo5.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        ufo.physicsBody?.categoryBitMask = BodyType.ship.rawValue
        ufo2.physicsBody?.categoryBitMask = BodyType.ship.rawValue
        ufo3.physicsBody?.categoryBitMask = BodyType.ship.rawValue
        ufo4.physicsBody?.categoryBitMask = BodyType.ship.rawValue
        ufo5.physicsBody?.categoryBitMask = BodyType.ship.rawValue
        ufo.position = SCNVector3(0, 0.1, -1)
        ufo2.position = SCNVector3(0.2, 0.75, -2.5)
        ufo3.position = SCNVector3(-0.70, -0.3, -1.75)
        ufo4.position = SCNVector3(-1.5, 0.1, -1)
        ufo5.position = SCNVector3(1.50, 0.75, -1)
        
        //Text Instructions
        self.shipsHit = 0
        let textString = String(self.shipsHit) + " ships hit!"
        let text = SCNText(string: textString, extrusionDepth: 1.0)

        text.firstMaterial?.diffuse.contents = UIColor.purple

        let textNode = SCNNode(geometry: text)
        textNode.name = "HitCounter"
        textNode.position = SCNVector3(0, -0.5, -1)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        
        // Create a new scene
        let scene = SCNScene()
        
        
        scene.rootNode.addChildNode(ufo)
        scene.rootNode.addChildNode(ufo2)
        scene.rootNode.addChildNode(ufo3)
        scene.rootNode.addChildNode(ufo4)
        scene.rootNode.addChildNode(ufo5)
        scene.rootNode.addChildNode(textNode)
        
        return scene
    }
    
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var contactNode :SCNNode!
        
        if contact.nodeA.name == "Bullet" {
            contactNode = contact.nodeB
        } else {
            contactNode = contact.nodeA
        }
        
        if self.lastContactNode != nil && self.lastContactNode == contactNode {
            return
        }
        
        self.shipsHit += 1
        let textNode = self.sceneView.scene.rootNode.childNode(withName: "HitCounter", recursively: true)
        textNode?.removeFromParentNode()
        
        let textString = String(self.shipsHit) + " ships hit!"
        let text = SCNText(string: textString, extrusionDepth: 1.0)

        text.firstMaterial?.diffuse.contents = UIColor.purple

        let textNodeUpdate = SCNNode(geometry: text)
        textNodeUpdate.name = "HitCounter"
        textNodeUpdate.position = SCNVector3(0, -0.5, -1)
        textNodeUpdate.scale = SCNVector3(0.01, 0.01, 0.01)
        
        /**
         Unused code -- this would create an explosion on impact, not configured
        let ufoScene = SCNScene(named: "art.scnassets/ufo.scn")!
        let fireNode = ufoScene.rootNode.childNode(withName: "explosionNode", recursively: true)!
        
        if contactNode.name == "Ship1" {
            let ufoNode = self.sceneView.scene.rootNode.childNode(withName: "Ship1", recursively: true)!
            
            fireNode.position = ufoNode.position
            addExplosionNode(fireNode: fireNode)
            
        } else if contactNode.name == "Ship2" {
            let ufoNode = self.sceneView.scene.rootNode.childNode(withName: "Ship2", recursively: true)!
            
            fireNode.position = ufoNode.position
            addExplosionNode(fireNode: fireNode)
            
        } else if contactNode.name == "Ship3" {
            let ufoNode = self.sceneView.scene.rootNode.childNode(withName: "Ship3", recursively: true)!
            
            fireNode.position = ufoNode.position
            addExplosionNode(fireNode: fireNode)
            
        } else if contactNode.name == "Ship4" {
            let ufoNode = self.sceneView.scene.rootNode.childNode(withName: "Ship4", recursively: true)!
            
            fireNode.position = ufoNode.position
            addExplosionNode(fireNode: fireNode)
            
        } else {
            let ufoNode = self.sceneView.scene.rootNode.childNode(withName: "Ship5", recursively: true)!
            
            fireNode.position = ufoNode.position
            addExplosionNode(fireNode: fireNode)
        
        }
        
        self.sceneView.scene.rootNode.addChildNode(fireNode)
         */

        self.lastContactNode = contactNode
        contactNode.removeFromParentNode()
        self.sceneView.scene.rootNode.addChildNode(textNodeUpdate)
    }
    
    func regeisterGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(shoot))
        
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        let doubleTappedGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTappedGestureRecognizer.numberOfTapsRequired = 2
        
        tapGestureRecognizer.require(toFail: doubleTappedGestureRecognizer)

        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        self.sceneView.addGestureRecognizer(doubleTappedGestureRecognizer)
    }
    
    // Adding the explosion to the Node
    func addExplosionNode(fireNode: SCNNode) {
        let fire = createPS()
        fireNode.addParticleSystem(fire)
    }
    
    // Creating the fire particle system
    func createPS() -> SCNParticleSystem {
        let particleSystem = SCNParticleSystem()
            
        particleSystem.birthRate = 250
        particleSystem.particleSize = 0.01
        particleSystem.birthRateVariation = 50
        particleSystem.particleLifeSpan = 0.5
        particleSystem.warmupDuration = 0.01
        particleSystem.loops = false
        particleSystem.birthLocation = .volume
        particleSystem.birthDirection = .random
        particleSystem.speedFactor = 1.2
        particleSystem.particleSize = 0.1
        particleSystem.particleVelocity = 2.5
        particleSystem.particleMass = 1
        particleSystem.particleBounce = 0.7
        particleSystem.particleFriction = 1
        particleSystem.emissionDuration = 1
        particleSystem.particleColor = .red
        return particleSystem
    }
    
    // Shoots the sphere
    @objc func shoot(recognizer: UIGestureRecognizer){
        // Get the current camera frame
        guard let currentFrame = self.sceneView.session .currentFrame  else {
            return
        }
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.3
        
        //make ball to shoot
        let sphere = SCNSphere(radius: 0.05)
        sphere.firstMaterial?.diffuse.contents = UIColor.blue

        //Set position based on camera frame
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.name = "Bullet"
        sphereNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        sphereNode.physicsBody?.isAffectedByGravity = false
        sphereNode.physicsBody?.categoryBitMask = BodyType.bullet.rawValue
        sphereNode.physicsBody?.contactTestBitMask = BodyType.ship.rawValue
        sphereNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)

        //Apply shooting force to sphere
        let forceVector = SCNVector3(sphereNode.worldFront.x * 7, sphereNode.worldFront.y * 7, sphereNode.worldFront.z * 7)
        sphereNode.physicsBody?.applyForce(forceVector, asImpulse: true)

        self.sceneView.scene.rootNode.addChildNode(sphereNode)
    }
    
    //Resets the scene on completion
    @objc func doubleTapped(recognizer :UIGestureRecognizer) {
        
        if self.shipsHit >= 5 {
            let scene = setupScene()
            self.sceneView.scene = scene
            
            self.sceneView.scene.physicsWorld.contactDelegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
