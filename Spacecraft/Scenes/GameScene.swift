//
//  GameScene.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 31/05/16.
//  Copyright (c) 2016 Cassio Diego Tavares Campos. All rights reserved.
//

import SpriteKit
import CoreMotion
import AudioToolbox.AudioServices
import AVFoundation

class GameScene: GameSceneObjects, SKPhysicsContactDelegate {

    let acelerometerValues = Constants.AcelerometerValues.self
    let rockAssetValues = Constants.RockAssetsValues.self
    let gameSceneConstants = Constants.GameSceneConstants.self
    var motionManager = CMMotionManager()
    var lastYieldTimeIntervalRock: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    var lastYieldTimeIntervalAurora: TimeInterval = 0
    var lastYieldTimeIntervalLife: TimeInterval = 0
    var rocksDestroyed: Int = 0
    var spacecraftColisions: Int = Constants.GameSceneConstants.initialSpacecraftCollisions
    var scoreLabel: SKLabelNode = SKLabelNode()
    var livesLabel: SKLabelNode = SKLabelNode()
    var gameSceneActions: GameSceneActions!

    override init(size: CGSize) {
        super.init(size: size)
        initializeScene()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeScene() {
        self.view?.isMultipleTouchEnabled = false
        self.physicsBody?.collisionBitMask = collisions.EdgeBody
        self.physicsBody?.allowsRotation = false
        self.physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = .black
        setupBackground()
        setupHeader()
        setupLabels()
    }

    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: assets.firstBackground)
        let screenSize = UIScreen.main.bounds
        background.position = CGPoint(x: screenSize.width * Constants.GameSceneConstants.backgroundXProportion, y: screenSize.height * Constants.GameSceneConstants.backgroundYProportion)
        background.zPosition = Constants.GameSceneConstants.backgroundZPosition
        self.addChild(background)
    }

    private func setupLabels() {
        setupScoreLabel()
        setupLivesLabel()
    }

    private func setupScoreLabel() {
        scoreLabel.position = CGPoint(x: UIScreen.main.bounds.width * Constants.GameSceneConstants.scoreLabelXProportion, y: UIScreen.main.bounds.height * Constants.GameSceneConstants.scoreLabelYProportion)
        scoreLabel.zPosition = Constants.GameSceneConstants.scoreLabelZPosition
        self.addChild(scoreLabel)
        updateScoreLabel(0)
    }

    private func setupLivesLabel() {
        livesLabel.position = CGPoint(x: UIScreen.main.bounds.width * Constants.GameSceneConstants.livesLabelXProportion, y: UIScreen.main.bounds.height * Constants.GameSceneConstants.livesLabelYProportion)
        livesLabel.zPosition = Constants.GameSceneConstants.livesLabelZPosition
        self.addChild(livesLabel)
        updateLivesLabel(Constants.GameSceneConstants.initialSpacecraftCollisions)
    }

    override func didMove(to view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        setupStars()
        setupPlayer()
        setupAccelerometer()
        gameSceneActions = GameSceneActions(scene: self)
    }

    override func update(_ currentTime: TimeInterval) {
        let timeSinceLastUpdate = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        updatePlayerPosition()
        updateWithTimeSinceLastUpdate(min(timeSinceLastUpdate, Constants.GameSceneConstants.maxUpdateInterval))
    }

    private func updatePlayerPosition() {
        let moveAction = SKAction.moveTo(x: xAcceleration, duration: Constants.GameSceneConstants.playerMoveDuration)
        let moveActionLeftJet = SKAction.moveTo(x: xAcceleration - Constants.GameSceneConstants.jetXOffset, duration: Constants.GameSceneConstants.playerMoveDuration)
        let moveActionRightJet = SKAction.moveTo(x: xAcceleration + Constants.GameSceneConstants.jetXOffset, duration: Constants.GameSceneConstants.playerMoveDuration)
        player.run(moveAction)
        fireLeft.run(moveActionLeftJet)
        fireRight.run(moveActionRightJet)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        exitButton.contains(location) ? exitGame() : gameSceneActions.handleTouchEnded(at: location)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB

        if (firstBody.categoryBitMask == Constants.CollisionCategories.playerCategory && secondBody.categoryBitMask == Constants.CollisionCategories.life) ||
           (secondBody.categoryBitMask == Constants.CollisionCategories.playerCategory && firstBody.categoryBitMask == Constants.CollisionCategories.life) {
            if firstBody.categoryBitMask == Constants.CollisionCategories.life {
                firstBody.node?.removeFromParent()
            } else {
                secondBody.node?.removeFromParent()
            }
            spacecraftColisions += 1
            updateLivesLabel(spacecraftColisions)
        }

        if (firstBody.categoryBitMask == Constants.CollisionCategories.shotCategory && secondBody.categoryBitMask == Constants.CollisionCategories.life) ||
           (secondBody.categoryBitMask == Constants.CollisionCategories.shotCategory && firstBody.categoryBitMask == Constants.CollisionCategories.life) {
            if firstBody.categoryBitMask == Constants.CollisionCategories.life {
                firstBody.node?.removeFromParent()
            } else {
                secondBody.node?.removeFromParent()
            }
        }

        gameSceneActions.didBegin(contact)
    }

    private func setupAccelerometer() {
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.accelerometerUpdateInterval = acelerometerValues.accelerometerUpdateInterval
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self = self, let data = data else { return }
            self.xAcceleration = self.player.position.x + CGFloat(data.acceleration.x * self.acelerometerValues.accelerationXMult)
        }
    }

    private func updateWithTimeSinceLastUpdate(_ timeSinceLastUpdate: TimeInterval) {
        lastYieldTimeIntervalRock += timeSinceLastUpdate
        lastYieldTimeIntervalAurora += timeSinceLastUpdate
        lastYieldTimeIntervalLife += timeSinceLastUpdate

        if lastYieldTimeIntervalRock > Constants.GameSceneConstants.rockYieldInterval {
            lastYieldTimeIntervalRock = 0
            setupRock(assets.rockOne, score: 1)
        }

        if lastYieldTimeIntervalAurora > Constants.GameSceneConstants.auroraYieldInterval {
            lastYieldTimeIntervalAurora = 0
            gameSceneActions.setupAurora()
        }

        if lastYieldTimeIntervalLife > Constants.GameSceneConstants.lifeYieldInterval {
            lastYieldTimeIntervalLife = 0
            setupLife()
        }
    }

    private func setupLife() {
        let life = SKSpriteNode(imageNamed: Constants.Assets.life)
        let randomXPosition = CGFloat.random(in: 0...self.size.width)
        life.position = CGPoint(x: randomXPosition, y: self.size.height + life.size.height)
        life.zPosition = Constants.GameSceneConstants.lifeZPosition
        life.physicsBody = SKPhysicsBody(rectangleOf: life.size)
        life.physicsBody?.isDynamic = true
        life.physicsBody?.categoryBitMask = Constants.CollisionCategories.life
        life.physicsBody?.contactTestBitMask = Constants.CollisionCategories.playerCategory | Constants.CollisionCategories.shotCategory
        life.physicsBody?.collisionBitMask = 0

        let moveAction = SKAction.move(to: CGPoint(x: randomXPosition, y: -life.size.height), duration: Constants.GameSceneConstants.lifeFallDuration)
        let removeAction = SKAction.removeFromParent()
        life.run(SKAction.sequence([moveAction, removeAction]))

        self.addChild(life)
    }

    func updateScoreLabel(_ newScore: Int) {
        scoreLabel.text = "\(newScore)"
        updateRockAssets(for: newScore)
    }

    private func updateRockAssets(for score: Int) {
        (score > rockAssetValues.firstLevelValue && score < rockAssetValues.secondLevelValue) ?
            setupRock(assets.rockOne, score: score) : nil
        (score > rockAssetValues.secondLevelValue) ?
            setupRock(assets.rockTwo, score: score) : nil
        (score > rockAssetValues.thirdLevelvalue) ?
            setupRock(assets.rockThree, score: score) : nil
    }

    func updateLivesLabel(_ numberOfLives: Int) {
        livesLabel.text = "\(numberOfLives)"
    }
}
