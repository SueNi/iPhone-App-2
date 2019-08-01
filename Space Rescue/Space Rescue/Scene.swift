//
//  Scene.swift
//  Space Rescue
//
//  Created by GWC2 on 7/25/19.
//  Copyright © 2019 GWC. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    var sceneView: ARSKView {
        return view as! ARSKView
    }
    var isWorldSetUp = false
    var aim: SKSpriteNode!
    let gameSize = CGSize(width: 4, height: 2)
    var haveFuel = false
    let spaceDogLabel = SKLabelNode(text: "Animals Rescued:")
    let numberOfDogsLabel = SKLabelNode(text: "0")
    let win = SKLabelNode(text: "Congratulations! You win!")
    
    
    var dogCount = 0 {
        didSet {
            self.numberOfDogsLabel.text = "\(dogCount)"
        }
    }
    override func didMove(to view: SKView) {
        // Setup your scene here
        aim = SKSpriteNode(imageNamed: "aim")
        addChild(aim)
        label()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if !isWorldSetUp {
            setUpWorld()
        }
        light()
        guard let currentFrame = sceneView.session.currentFrame  else {
            return
        }
        collectFuel(currentFrame: currentFrame)
        //if dogCount == 6{
            //addChild(win)
       // }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       rescue()
    }
    
    func setUpWorld() {
        // Create anchor using the camera's current position
        guard let currentFrame = sceneView.session.currentFrame,
            let scene = SKScene(fileNamed: "lv1") else{
                return
            }
        for node in scene.children{
            if let node = node as? SKSpriteNode{
                // Create a transform with a translation of 0.2 meters in front of the camera
                var translation = matrix_identity_float4x4
                let posX = node.position.x / scene.size.width
                let posY = node.position.y / scene.size.height
                translation.columns.3.x = Float(posX*gameSize.width)
                translation.columns.3.y = Float(posY*gameSize.height)
                translation.columns.3.z = Float.random(in: -0.5 ..< 0.5)
                let transform = simd_mul(currentFrame.camera.transform, translation)
                // Add a new anchor to the session
                let anchor = Anchor(transform: transform)
                if let name = node.name,
                    let type = NodeType(rawValue: name) {
                    anchor.type = type
                    sceneView.session.add(anchor: anchor)
                }

            }
            isWorldSetUp = true
        }
    }
    
    func light(){
        guard let currentFrame = sceneView.session.currentFrame, let lightEstimate = currentFrame.lightEstimate else {
            return
        }
        let neutralIntensity: CGFloat = 1000
        let ambientIntensity = min(lightEstimate.ambientIntensity, neutralIntensity)
        let blendFactor = 1 - ambientIntensity / neutralIntensity
        for node in children {
            if let spaceDog = node as? SKSpriteNode {
                spaceDog.color = .black
                spaceDog.colorBlendFactor = blendFactor
            }
        }
    }
    
    func rescue(){
        let location = aim.position
        let hitNodes = nodes(at: location)
        var rescuedDog: SKNode?
        for node in hitNodes {
            if haveFuel{
                if node.name == "dog" || node.name == "pusheen" || node.name == "nyan" {
                    rescuedDog = node
                    break
                }
            }
            
        }
        if let rescuedDog = rescuedDog {
            let wait = SKAction.wait(forDuration: 0.3)
            let removeDog = SKAction.removeFromParent()
            let sequence = SKAction.sequence([wait, removeDog])
            rescuedDog.run(sequence)
            dogCount += 1
        }
    }
    func collectFuel(currentFrame: ARFrame) {
        for anchor in currentFrame.anchors {
            guard let node = sceneView.node(for: anchor),
                node.name == NodeType.fuel.rawValue
                else {continue}
            let distance = simd_distance(anchor.transform.columns.3, currentFrame.camera.transform.columns.3)
            if distance < 0.1 {
                sceneView.session.remove(anchor: anchor)
                haveFuel = true
                break
            }
        }
    }
    
    func label(){
        spaceDogLabel.fontSize = 20
        spaceDogLabel.fontName = "Futura-Medium"
        spaceDogLabel.color = .white
        spaceDogLabel.position = CGPoint(x: 0, y: 240)
        addChild(spaceDogLabel)
        numberOfDogsLabel.fontSize = 20
        numberOfDogsLabel.fontName = "Futura-Medium"
        numberOfDogsLabel.color = .white
        numberOfDogsLabel.position = CGPoint(x: 120, y: 240)
        addChild(numberOfDogsLabel)
        win.fontSize = 30
        win.fontName = "Futura-Medium"
        win.color = .white
        win.position = CGPoint(x: frame.midX, y: frame.midY)
    }

}
