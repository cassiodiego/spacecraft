//
//  GameScene.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 31/05/16.
//  Copyright (c) 2016 Cassio Diego Tavares Campos. All rights reserved.

import SpriteKit
import CoreMotion
import AudioToolbox.AudioServices
import AVFoundation

class GameScene: GameSceneObjects, SKPhysicsContactDelegate {

    var motionManager = CMMotionManager()
    var lastYieldTimeIntervalRock: TimeInterval = TimeInterval()
    var lastUpdateTimerIntervalRock: TimeInterval = TimeInterval()
    var lastYieldTimeIntervalAurora: TimeInterval = TimeInterval()
    var lastUpdateTimerIntervalAurora: TimeInterval = TimeInterval()
    var rocksDestroyed: Int = 0
    var spacecraftColisions: Int = 4
    var scoreLabel: SKLabelNode = SKLabelNode()
    var livesLabel: SKLabelNode = SKLabelNode()

    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        setupStars()
        setupPlayer()
        setupAcelerometer()

    }

    override init(size: CGSize) {

        super.init(size: size)

        self.view?.isMultipleTouchEnabled = false
        self.physicsBody?.collisionBitMask = collisions.EdgeBody
        self.physicsBody?.allowsRotation = false
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor.black
        var background: SKSpriteNode = SKSpriteNode()
        let screenSize = UIScreen.main.bounds
        _ = screenSize.width
        _ = screenSize.height

        background = SKSpriteNode(imageNamed: self.assets.firstBackground)
        background.position = CGPoint(x: (screenSize.width * 0.40), y: (screenSize.height * 0.500))
        background.zPosition = 1

        self.addChild(background)
        
        setupHeader()
        
        scoreLabel.position = CGPoint(x: (screenSize.width * 0.24), y: (screenSize.height * 0.88))
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
        scoreLabelUpdate(0)

        livesLabel.position = CGPoint(x: (screenSize.width * 0.57), y: (screenSize.height * 0.88))
        livesLabel.zPosition = 2
        self.addChild(livesLabel)
        livesLabelUpdate(4)
            
    }

    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }

    func setupAcelerometer() {
        
        if motionManager.isAccelerometerAvailable == true {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { data, _ in

                let currentX = self.player.position.x

                if (data!.acceleration.x < 0) { self.xAcceleration = currentX + CGFloat((data?.acceleration.x)! * 500) } else if (data!.acceleration.x > 0) { self.xAcceleration = currentX + CGFloat((data?.acceleration.x)! * 500) }
            })
        }
        
    }

    func updateWithTimeSinceLastUpdate(_ timeSinceLastUpdate: CFTimeInterval) {
        
        lastYieldTimeIntervalRock += timeSinceLastUpdate
        lastYieldTimeIntervalAurora += timeSinceLastUpdate
        var speed: Double = 3
        speed -= 0.1

        if (lastYieldTimeIntervalRock > 1) {
            lastYieldTimeIntervalRock = 0
            self.setupRock(self.assets.rockOne, score: 1)
        }

        if (lastYieldTimeIntervalAurora > 5) {
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
        if (timeSinceLastUpdate > 1) {
            timeSinceLastUpdate = 1/60
            lastUpdateTimerIntervalRock = currentTime
        }
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
        
    }
    
    func scoreLabelUpdate(_ newscore: Int) {
        
        scoreLabel.text = "\(newscore)"
        newscore > 25 && newscore < 50 ? setupRock(self.assets.rockOne, score: newscore) : nil
        newscore > 50 ? setupRock(self.assets.rockTwo, score: newscore) : nil
        newscore > 200 ? setupRock(self.assets.rockThree, score: newscore) : nil
        
    }
    
    func livesLabelUpdate(_ numberOfLives: Int) {
        
        livesLabel.text = "\(numberOfLives)"
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        handleTouchEnded(at: touch.location(in: self))
    }

    func handleTouchEnded(at location: CGPoint) {
        let spriteShot = determineShotSprite()
        let shot = createShotNode(with: spriteShot, at: player.position)
        let finalDestination = calculateShotDestination(from: shot.position, to: location)
        let moveDuration = calculateMoveDuration()

        playShotSoundIfNeeded()
        
        if isShotValid(from: shot.position, to: location) {
            self.addChild(shot)
            runShotActions(on: shot, to: finalDestination, duration: moveDuration)
        }
    }

    func determineShotSprite() -> String {
        return self.getKindShip() == assets.armory ? self.assets.orangeShot : self.assets.blueShot
    }

    func createShotNode(with imageName: String, at position: CGPoint) -> SKSpriteNode {
        let shot = SKSpriteNode(imageNamed: imageName)
        shot.position = position
        shot.physicsBody = SKPhysicsBody(circleOfRadius: shot.size.width / 2)
        shot.physicsBody?.isDynamic = false
        shot.physicsBody?.categoryBitMask = collisions.shotCategory
        shot.physicsBody?.contactTestBitMask = collisions.rockCategory
        shot.physicsBody?.collisionBitMask = 0
        shot.physicsBody?.usesPreciseCollisionDetection = true
        shot.zPosition = 3
        return shot
    }

    func calculateShotDestination(from startPosition: CGPoint, to touchLocation: CGPoint) -> CGPoint {
        let offset = Utils.vecSub(touchLocation, b: startPosition)
        let direction = Utils.vecNormalize(offset)
        let shotLength = Utils.vecMult(direction, b: 300)
        return Utils.vecAdd(shotLength, b: startPosition)
    }

    func calculateMoveDuration() -> TimeInterval {
        return TimeInterval(Float(self.size.width) / Float(gameConfigInitialValues.velocity))
    }

    func playShotSoundIfNeeded() {
        let soundIsOn = UserDefaults.standard.bool(forKey: dataConfigKeys.soundStatus)
        if soundIsOn {
            self.run(SKAction.playSoundFileNamed(self.assets.shotSound, waitForCompletion: false))
        }
    }

    func isShotValid(from startPosition: CGPoint, to touchLocation: CGPoint) -> Bool {
        let offset = Utils.vecSub(touchLocation, b: startPosition)
        return offset.y >= 0
    }

    func runShotActions(on shot: SKSpriteNode, to destination: CGPoint, duration: TimeInterval) {
        let moveAction = SKAction.move(to: destination, duration: duration)
        let removeAction = SKAction.removeFromParent()
        shot.run(SKAction.sequence([moveAction, removeAction]))
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        let thirdBody: SKPhysicsBody
        let width = UIScreen.main.bounds.size.width
        let score = scoreLabel.text
        let transition: SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
        
        (firstBody, secondBody, thirdBody) = initializeBodies(contact: contact)
        
        handleShotCollision(firstBody: firstBody, secondBody: secondBody)
        
        checkPlayerPositionAndCollisions(firstBody: firstBody, thirdBody: thirdBody, width: width, score: score, transition: transition)
        
        checkForGameOver(score: score, transition: transition)
    }

    func initializeBodies(contact: SKPhysicsContact) -> (SKPhysicsBody, SKPhysicsBody, SKPhysicsBody) {
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            return (contact.bodyA, contact.bodyB, contact.bodyB)
        } else {
            return (contact.bodyB, contact.bodyA, contact.bodyB)
        }
    }

    func handleShotCollision(firstBody: SKPhysicsBody, secondBody: SKPhysicsBody) {
        if (firstBody.categoryBitMask & collisions.shotCategory) != 0 && (secondBody.categoryBitMask & collisions.rockCategory) != 0 {
            if let shotNode = firstBody.node as? SKSpriteNode, let rockNode = secondBody.node as? SKSpriteNode {
                shotDidCollideWithRock(shot: shotNode, rock: rockNode)
            }
        }
    }

    func checkPlayerPositionAndCollisions(firstBody: SKPhysicsBody, thirdBody: SKPhysicsBody, width: CGFloat, score: String?, transition: SKTransition) {
        if (player.position.x == firstBody.node!.position.x) ||
           (player.position.y == firstBody.node!.position.y) ||
           (player.position.x == thirdBody.node!.position.x) ||
           (player.position.y == thirdBody.node!.position.y) ||
           (player.position.x < (0.0 + (player.size.width / 2))) ||
           (player.position.x > (width - (player.size.width / 2))) {
            
            setupExplosion(x: player.position.x, y: player.position.y)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            
            spacecraftColisions -= 1
            livesLabelUpdate(spacecraftColisions)
            
            if spacecraftColisions == 0 {
                self.view!.presentScene(GameOverScene(size: self.size, won: false, score: score!), transition: transition)
            }
        }
    }

    func checkForGameOver(score: String?, transition: SKTransition) {
        if scoreLabel.text == "9999" {
            self.view!.presentScene(GameOverScene(size: self.size, won: true, score: score!), transition: transition)
        }
    }
    
    func shotDidCollideWithRock(shot: SKSpriteNode, rock: SKSpriteNode) {
        rock.removeFromParent()
        rocksDestroyed += 1
        scoreLabelUpdate(rocksDestroyed)
        
    }
    
}
