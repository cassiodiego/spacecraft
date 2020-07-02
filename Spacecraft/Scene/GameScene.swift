//
//  GameScene.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 31/05/16.
//  Modified by Cassio Diego Tavares Campos on 11/03/19.
//  Copyright (c) 2016 Cassio Diego Tavares Campos. All rights reserved.

import SpriteKit
import CoreMotion
import AudioToolbox.AudioServices
import AVFoundation

class GameScene: GameSceneObjects, SKPhysicsContactDelegate {
    
    var motionManager = CMMotionManager()
    
    var lastYieldTimeIntervalRock:TimeInterval = TimeInterval()
    var lastUpdateTimerIntervalRock:TimeInterval = TimeInterval()
    
    var lastYieldTimeIntervalAurora:TimeInterval = TimeInterval()
    var lastUpdateTimerIntervalAurora:TimeInterval = TimeInterval()
    
    var rocksDestroyed:Int = 0
    
    var scoreLabel:SKLabelNode = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        setupStars()
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        setupPlayer()
        
        setupAcelerometer()
        
    }
    
    override init(size:CGSize){
        
        super.init(size: size)
        
        self.view?.isMultipleTouchEnabled = false

        self.physicsBody?.collisionBitMask = collisions.EdgeBody
        self.physicsBody?.allowsRotation = false
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        var Background:SKSpriteNode = SKSpriteNode()

        self.backgroundColor = SKColor.black
        
        let screenSize = UIScreen.main.bounds
        _ = screenSize.width
        _ = screenSize.height
        
        Background = SKSpriteNode(imageNamed: self.assets.firstBackground)

        Background.position = CGPoint(x: (screenSize.width * 0.40), y: (screenSize.height * 0.500))

        Background.zPosition = 1
        
        self.addChild(Background)
        
        scoreLabel.position = CGPoint(x: (screenSize.width * 0.10), y: (screenSize.height * 0.88))
        
        scoreLabel.zPosition = 2
        
        self.addChild(scoreLabel)
        
        scoreLabelUpdate(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func setupAcelerometer(){
        
        if motionManager.isAccelerometerAvailable == true {
            
            motionManager.accelerometerUpdateInterval = 0.1
            
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler:{
                
                data, error in

                let currentX = self.player.position.x
                
                if (data!.acceleration.x < 0) { self.xAcceleration = currentX + CGFloat((data?.acceleration.x)! * 500) }
                    
                else if (data!.acceleration.x > 0) { self.xAcceleration = currentX + CGFloat((data?.acceleration.x)! * 500) }
            })
        }
    }
    
    func updateWithTimeSinceLastUpdate(_ timeSinceLastUpdate:CFTimeInterval){

        lastYieldTimeIntervalRock += timeSinceLastUpdate
        lastYieldTimeIntervalAurora += timeSinceLastUpdate
        var speed:Double = 3

        speed = speed - 0.1
        
        if (lastYieldTimeIntervalRock > 1){

            lastYieldTimeIntervalRock = 0
            self.setupRock(self.assets.rockOne, score: 1)
        }
        
        if (lastYieldTimeIntervalAurora > 5){

            lastYieldTimeIntervalAurora = 0
            setupAurora()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        let action = SKAction.moveTo(x: xAcceleration, duration: 1)
        let actionJetLeft = SKAction.moveTo(x: xAcceleration-10, duration: 1)
        let actionJetRight = SKAction.moveTo(x: xAcceleration+10, duration: 1)

        self.player.run(action)
        
        self.fireLeft.run(actionJetLeft)
        self.fireRight.run(actionJetRight)
        
        var timeSinceLastUpdate = currentTime - lastUpdateTimerIntervalRock
        
        lastUpdateTimerIntervalRock = currentTime
        
        if (timeSinceLastUpdate > 1){
            
            timeSinceLastUpdate = 1/60
            lastUpdateTimerIntervalRock = currentTime
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
        
    }
    
    func scoreLabelUpdate(_ newscore:Int){
        
        scoreLabel.text = "\(newscore)"

        newscore > 25 && newscore < 50 ? setupRock(self.assets.rockOne, score: newscore) : nil
        newscore > 50 ? setupRock(self.assets.rockTwo, score: newscore) : nil
        newscore > 200 ? setupRock(self.assets.rockThree, score: newscore) : nil
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        var spriteShot:String = ""
        var actionArray = [SKAction]()

        self.getKindShip() == assets.Armory ? (spriteShot = self.assets.orangeShot) : (spriteShot = self.assets.blueShot)
        
        let shot:SKSpriteNode = SKSpriteNode(imageNamed: spriteShot)
        let location = CGPoint(x: player.position.x, y:player.position.y+500)
        let offset:CGPoint = Utils.vecSub(location, b: shot.position)
        let direction:CGPoint = Utils.vecNormalize(offset)
        let shotLength:CGPoint = Utils.vecMult(direction, b: 300)
        let finalDestination:CGPoint = Utils.vecAdd(shotLength, b: shot.position)
        let moveDuration:Float = Float(self.size.width) / Float(gameConfigInitialValues.velocity)
        let soundIsOn = UserDefaults.standard.bool(forKey: dataConfigKeys.soundStatus)
        
        soundIsOn ? self.run(SKAction.playSoundFileNamed(self.assets.orangeShot, waitForCompletion: false)) : nil
        
        shot.position = player.position
        shot.physicsBody = SKPhysicsBody(circleOfRadius: shot.size.width/2)
        shot.physicsBody!.isDynamic = false
        shot.physicsBody!.categoryBitMask = collisions.shotCategory
        shot.physicsBody!.contactTestBitMask = collisions.rockCategory
        shot.physicsBody!.collisionBitMask = 0
        shot.physicsBody!.usesPreciseCollisionDetection = true
        shot.zPosition = 3

        if (offset.y < 0){ return }
        
        self.addChild(shot)

        actionArray.append(SKAction.move(to: finalDestination, duration: TimeInterval(moveDuration)))
        actionArray.append(SKAction.removeFromParent())
        
        shot.run(SKAction.sequence(actionArray))
        
    }

    func didBegin(_ contact: SKPhysicsContact){

        let firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        var thirdBody:SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            thirdBody = contact.bodyB
            
        } else {
            
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            thirdBody = contact.bodyB
            
        }

        if (firstBody.categoryBitMask & collisions.shotCategory) != 0 && (secondBody.categoryBitMask & collisions.rockCategory) != 0 {
            firstBody.node != nil && secondBody.node != nil ?
                shotDidCollideWithRock(shot: firstBody.node as! SKSpriteNode, rock: secondBody.node as! SKSpriteNode) : nil
        }
        
        if (player.position.x == firstBody.node!.position.x) || (player.position.y == firstBody.node!.position.y) || (player.position.x == thirdBody.node!.position.x) || (player.position.y == thirdBody.node!.position.y) {
            
            setupExplosion(x: player.position.x, y: player.position.y)
        
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            
            let score = scoreLabel.text
            let transition:SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene:SKScene = GameOverScene(size: self.size, won: false, score: score!)
            
            self.view!.presentScene(gameOverScene, transition: transition)
            
        }
        
        if(scoreLabel.text == "99999"){
            
            let score = scoreLabel.text
            let transition:SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene:SKScene = GameOverScene(size: self.size, won: true, score: score!)
            
            self.view!.presentScene(gameOverScene, transition: transition)
        }
    }
    
    func shotDidCollideWithRock(shot:SKSpriteNode, rock:SKSpriteNode){

        rock.removeFromParent()
        rocksDestroyed += 1
        scoreLabelUpdate(rocksDestroyed)
    }
    
}
