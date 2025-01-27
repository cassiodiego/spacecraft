//
//  GameSceneActions.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 01/07/20.
//  Copyright (c) 2020 Cassio Diego Tavares Campos. All rights reserved.
//

import SpriteKit
import AudioToolbox.AudioServices

class GameSceneActions {

    weak var scene: GameScene?

    init(scene: GameScene) {
        self.scene = scene
    }

    func setupAurora() {
        guard let scene = scene else { return }

        let aurora = SKSpriteNode(imageNamed: scene.assets.auroraOne)
        aurora.zPosition = 2

        let minX = aurora.size.width / 2
        let maxX = scene.frame.size.width - aurora.size.width / 2
        let positionX = CGFloat.random(in: minX...maxX)

        aurora.position = CGPoint(x: positionX, y: scene.frame.size.height + aurora.size.height)
        scene.addChild(aurora)

        let moveDuration = 25.0
        let moveAction = SKAction.move(to: CGPoint(x: positionX, y: -aurora.size.height), duration: moveDuration)
        let removeAction = SKAction.removeFromParent()
        aurora.run(SKAction.sequence([moveAction, removeAction]))
    }

    func handleTouchEnded(at location: CGPoint) {
        guard let scene = scene else { return }

        let spriteShot = determineShotSprite()
        let shot = createShotNode(with: spriteShot, at: scene.player.position)
        let finalDestination = calculateShotDestination(from: shot.position, to: location)
        let moveDuration = calculateMoveDuration()

        playShotSoundIfNeeded()
        
        if isShotValid(from: shot.position, to: location) {
            scene.addChild(shot)
            runShotActions(on: shot, to: finalDestination, duration: moveDuration)
        }
    }

    func determineShotSprite() -> String {
        guard let scene = scene else { return "" }
        return scene.getKindShip() == scene.assets.armory ? scene.assets.orangeShot : scene.assets.blueShot
    }

    func createShotNode(with imageName: String, at position: CGPoint) -> SKSpriteNode {
        let shot = SKSpriteNode(imageNamed: imageName)
        shot.position = position
        shot.physicsBody = SKPhysicsBody(circleOfRadius: shot.size.width / 2)
        shot.physicsBody?.isDynamic = false
        shot.physicsBody?.categoryBitMask = scene?.collisions.shotCategory ?? 0
        shot.physicsBody?.contactTestBitMask = scene?.collisions.rockCategory ?? 0
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
        guard let scene = scene else { return 0 }
        return TimeInterval(Float(scene.size.width) / Float(scene.gameConfigInitialValues.velocity))
    }

    func playShotSoundIfNeeded() {
        guard let scene = scene else { return }
        let soundIsOn = UserDefaults.standard.bool(forKey: scene.dataConfigKeys.soundStatus)
        if soundIsOn {
            scene.run(SKAction.playSoundFileNamed(scene.assets.shotSound, waitForCompletion: false))
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
        guard let scene = scene else { return }
        
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        let thirdBody: SKPhysicsBody
        let width = UIScreen.main.bounds.size.width
        let score = scene.scoreLabel.text
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
        guard let scene = scene else { return }
        if (firstBody.categoryBitMask & scene.collisions.shotCategory) != 0 && (secondBody.categoryBitMask & scene.collisions.rockCategory) != 0 {
            if let shotNode = firstBody.node as? SKSpriteNode, let rockNode = secondBody.node as? SKSpriteNode {
                shotDidCollideWithRock(shot: shotNode, rock: rockNode)
            }
        }
    }
    
    func shotDidCollideWithRock(shot: SKSpriteNode, rock: SKSpriteNode) {
        guard let scene = scene else { return }
        rock.removeFromParent()
        scene.rocksDestroyed += 1
        scene.scoreLabelUpdate(scene.rocksDestroyed)
    }

    func checkPlayerPositionAndCollisions(firstBody: SKPhysicsBody, thirdBody: SKPhysicsBody, width: CGFloat, score: String?, transition: SKTransition) {
        guard let scene = scene else { return }
        if (scene.player.position.x == firstBody.node!.position.x) ||
           (scene.player.position.y == firstBody.node!.position.y) ||
           (scene.player.position.x == thirdBody.node!.position.x) ||
           (scene.player.position.y == thirdBody.node!.position.y) ||
           (scene.player.position.x < (0.0 + (scene.player.size.width / 2))) ||
           (scene.player.position.x > (width - (scene.player.size.width / 2))) {
            
            scene.setupExplosion(x: scene.player.position.x, y: scene.player.position.y)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            
            scene.spacecraftColisions -= 1
            scene.livesLabelUpdate(scene.spacecraftColisions)
            
            if scene.spacecraftColisions == 0 {
                scene.view!.presentScene(GameOverScene(size: scene.size, won: false, score: score!), transition: transition)
            }
        }
    }

    func checkForGameOver(score: String?, transition: SKTransition) {
        guard let scene = scene else { return }
        if scene.scoreLabel.text == "9999" {
            scene.view!.presentScene(GameOverScene(size: scene.size, won: true, score: score!), transition: transition)
        }
    }
}
