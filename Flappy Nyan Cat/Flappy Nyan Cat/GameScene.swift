//
//  GameScene.swift
//  Flappy Nyan Cat
//
//  Created by GWC2 on 7/23/19.
//  Copyright © 2019 GWC. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate  {
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var lastScoreUpdateTime: TimeInterval = 0.0
    var logo: SKSpriteNode!
    var game:Bool = false
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    func Createlogo(){
        logo = SKSpriteNode(imageNamed: "Logo.png")
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(logo)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosionTexture = SKTexture(imageNamed: "explosion")
        let explosion = SKSpriteNode(texture: explosionTexture)
        explosion.position = player.position
        addChild(explosion)
        player.removeFromParent()
        speed = 0
        game = false
        restart()
        
    }
    
    func restart(){
        let scene = GameScene(fileNamed: "GameScene")!
        let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 2)
        self.view?.presentScene(scene, transition: transition)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if game{
            updateScore(withCurrentTime: currentTime)
        }
        
    }
    
    func updateScore(withCurrentTime currentTime: TimeInterval) {
        let elapsedTime = currentTime - lastScoreUpdateTime
        if elapsedTime > 1.0 {
            score += 1
            lastScoreUpdateTime = currentTime
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1)
        create()
        createBG()
        createG()
        createScore()
        Createlogo()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !game {
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let remove = SKAction.removeFromParent()
            let wait = SKAction.wait(forDuration: 0.5)
            let sequence = SKAction.sequence([fadeOut, remove, wait])
            logo.run(sequence)
            startOB()
            player.physicsBody?.isDynamic = true
            game = true
        }else{
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0.05))
        }
       
    }
    
    func create() {
        let playerTexture = SKTexture(imageNamed:"nyan1")
        
        player = SKSpriteNode(texture: playerTexture)
        player.size = CGSize(width: 200, height: 200)
        player.zPosition = 20
        player.position = CGPoint(x: frame.width/4, y: frame.height*0.75)
        addChild(player)
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: player.size)
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        player.physicsBody?.isDynamic = false
        player.physicsBody?.collisionBitMask = 0
        //Setup the animation of the sprite so it looks like it's running
        let frame2 = SKTexture(imageNamed: "nyan2")
        let frame3 = SKTexture(imageNamed: "nyan3")
        let frame4 = SKTexture(imageNamed: "nyan4")
        let frame5 = SKTexture(imageNamed: "nyan5")
        let frame6 = SKTexture(imageNamed: "nyan6")
        let frame7 = SKTexture(imageNamed: "nyan7")
        let animation = SKAction.animate(with: [playerTexture, frame2, frame3, frame4, frame5, frame6, frame7],   timePerFrame: 0.5)
        let runForever = SKAction.repeatForever((animation))
        
        //Run the SKActions on the player sprite
        player.run(runForever)
    }
    
    func createBG() {
        let BGTexture = SKTexture(imageNamed:"background")
        for i in 0...1 {
            let bg = SKSpriteNode(texture: BGTexture)
            bg.zPosition = -30
            bg.anchorPoint = CGPoint.zero
            bg.position = CGPoint(x: (BGTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 0)
            addChild(bg)
            let moveLeft = SKAction.moveBy(x: -BGTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: BGTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            bg.run(moveForever)
            
        }
    }
    
    func createG() {
        let groundTexture = SKTexture(imageNamed:"ground")
        for i in 0...1 {
            let ground = SKSpriteNode(texture: groundTexture)
            //ground.size = CGSize(width: 540, height: 125)
            ground.zPosition = -10
            ground.position = CGPoint(x: (groundTexture.size().width/4.0 + (groundTexture.size().width*CGFloat(i))), y: groundTexture.size().height/4)
            ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
            ground.physicsBody?.isDynamic = false
            addChild(ground)
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x:groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            ground.run(moveForever)
            
        }
    }
    
    
    func createOB(){
        let OBTexture = SKTexture(imageNamed:"rock")
        
        let ob1 = SKSpriteNode(texture: OBTexture)
        ob1.physicsBody = SKPhysicsBody(texture: OBTexture, size: OBTexture.size())
        ob1.physicsBody?.isDynamic = false
        ob1.zPosition = -20
        
        let ob2 = SKSpriteNode(texture: OBTexture)
        ob2.physicsBody = SKPhysicsBody(texture: OBTexture, size: OBTexture.size())
        ob2.physicsBody?.isDynamic = false
        ob2.zPosition = -20
        addChild(ob1)
        addChild(ob2)
        
        let xPosition = frame.width + ob1.frame.width
        let max = CGFloat(frame.height/3)
        let yPosition = CGFloat.random(in: -50...max)
        let rockDistance: CGFloat = 70
        ob1.position = CGPoint(x: xPosition, y: yPosition + ob1.size.height*1.5 + rockDistance)
        ob2.position = CGPoint(x: xPosition, y: yPosition)
        let endPos = frame.width+(ob1.frame.width*2)
        let moveAction = SKAction.moveBy(x: -endPos, y: 0, duration: 6)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        ob1.run(moveSequence)
        ob2.run(moveSequence)
        
    }
    
    func startOB(){
        let create = SKAction.run { [unowned self] in
            self.createOB()
        }
        let wait = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([create,wait])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }
    
    func createScore()  {
        scoreLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 60)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontColor = UIColor.black
        addChild(scoreLabel)
    }
}
