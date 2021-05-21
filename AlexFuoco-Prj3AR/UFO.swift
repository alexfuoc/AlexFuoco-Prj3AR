//
//  UFO.swift
//  AlexFuoco-Prj3AR
//
//  Created by Alex Fuoco on 5/20/21.
//

import Foundation
import SceneKit
import ARKit

class UFO : SCNNode {
    
    
    private var scene :SCNScene!
    
    init(scene :SCNScene) {
        super.init()
        
        self.scene = scene
        
        setup()
    }
    
    init(ufoNode :SCNNode) {
        super.init()
        
        
        setup()
    }
    
    private func setup() {
        
        let ufoNode = scene.rootNode.childNode(withName: "ufoNode", recursively: true)!
        
        self.addChildNode(ufoNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
