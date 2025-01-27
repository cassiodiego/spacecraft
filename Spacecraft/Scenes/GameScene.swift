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
    var gameSceneActions: GameSceneActions!

    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        setupStars()
        setupPlayer()
        setupAcelerometer()
        gameSceneActions = GameSceneActions(scene: self)
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
            gameSceneActions.setupAurora()
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
        newscore > 25 && newscore < 50 ? self.setupRock(self.assets.rockOne, score: newscore) : nil
        newscore > 50 ? self.setupRock(self.assets.rockTwo, score: newscore) : nil
        newscore > 200 ? self.setupRock(self.assets.rockThree, score: newscore) : nil
    }
    
    func livesLabelUpdate(_ numberOfLives: Int) {
        livesLabel.text = "\(numberOfLives)"
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if exitButton.contains(location) {
            exitGame()
        } else {
            gameSceneActions.handleTouchEnded(at: location)
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        gameSceneActions.didBegin(contact)
    }
    
    func exitGame() {
        guard let view = self.view else { return }
        _ = SKTransition.flipHorizontal(withDuration: 0.5)
        
        if let mainVC = view.window?.rootViewController as? MainViewController {
            view.window?.rootViewController = mainVC
            mainVC.dismiss(animated: true, completion: nil)
        }
    }
}
