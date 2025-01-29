//
//  GameSceneObjects.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 16/05/20.
//  Copyright (c) 2020 Cassio Diego Tavares Campos. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class GameSceneObjects: BaseSceneObjects {
    
    var xAcceleration: CGFloat = 0.0
    
    var player: SKSpriteNode = SKSpriteNode()
    var leftJet: SKSpriteNode = SKSpriteNode()
    var rightJet: SKSpriteNode = SKSpriteNode()
    var livesIcon: SKSpriteNode = SKSpriteNode()
    var scoreIcon: SKSpriteNode = SKSpriteNode()
    
    var explosion: SKSpriteNode!
    var fireLeft: SKSpriteNode!
    var fireRight: SKSpriteNode!
    
    let directions = Constants.Directions.self
    let collisions = Constants.CollisionCategories.self

    let dataConfigKeys = Constants.DataConfigKeys.self
    let gameConfigInitialValues = Constants.GameConfigInitialValues.self
    let gameSceneObjects = Constants.GameSceneObjects.self
        
    func alreadyExist(key: String) -> Bool { return UserDefaults.standard.object(forKey: key) != nil }
    
    func getKindShip() -> String {
        let playerChoosedShip = alreadyExist(key: dataConfigKeys.ship)
        !playerChoosedShip ? UserDefaults.standard.set(assets.armory, forKey: dataConfigKeys.ship) : nil
        return (UserDefaults.standard.object(forKey: dataConfigKeys.ship)! as? String)!
    }
    
    func setupPlayer() {
        var spritePlayer: String = ""
        self.getKindShip() == assets.armory ? (spritePlayer = assets.armory) : (spritePlayer = assets.rinzler)
        player = SKSpriteNode(imageNamed: spritePlayer)
        player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 + gameSceneObjects.playerInitialYPosition)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody!.isDynamic = true
        player.physicsBody!.categoryBitMask = collisions.playerCategory
        player.physicsBody!.contactTestBitMask = collisions.rockCategory
        player.physicsBody!.categoryBitMask = collisions.EdgeBody
        player.physicsBody!.collisionBitMask = 0
        player.physicsBody!.usesPreciseCollisionDetection = true
        player.physicsBody?.velocity = CGVector(dx: xAcceleration * gameSceneObjects.velocityMultiplier, dy: 0)
        player.zPosition = gameSceneObjects.playerZPosition
        
        self.addChild(player)
        
        setupJet(x: self.player.position.x - gameSceneObjects.jetXOffset, y: self.player.position.y - gameSceneObjects.jetYOffset, side: self.directions.left)
        setupJet(x: self.player.position.x + gameSceneObjects.jetXOffset, y: self.player.position.y - gameSceneObjects.jetYOffset, side: self.directions.right)
    }
    
    func setupAurora() {
        let aurora = SKSpriteNode(imageNamed: assets.auroraOne)
        aurora.zPosition = gameSceneObjects.auroraZPosition
        
        let minX = aurora.size.width / 2
        let maxX = self.frame.size.width - aurora.size.width / 2
        let positionX = CGFloat.random(in: minX...maxX)
        
        aurora.position = CGPoint(x: positionX, y: self.frame.size.height + aurora.size.height)
        self.addChild(aurora)
        
        let moveDuration = gameSceneObjects.auroraMoveDuration
        let moveAction = SKAction.move(to: CGPoint(x: positionX, y: -aurora.size.height), duration: moveDuration)
        let removeAction = SKAction.removeFromParent()
        aurora.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    func setupExplosion(x: CGFloat, y: CGFloat) {
        let textures = (1...9).map { SKTexture(imageNamed: "e-\($0)") }
        let boom = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: gameSceneObjects.explosionFrameTime))
        
        explosion = SKSpriteNode(texture: textures.first)
        explosion.setScale(gameSceneObjects.explosionScale)
        explosion.position = CGPoint(x: x, y: y)
        explosion.zPosition = gameSceneObjects.explosionZPosition
        explosion.run(boom)
        self.addChild(explosion)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + gameSceneObjects.explosionRemovalDelay) {
            self.explosion.removeFromParent()
        }
    }
    
    func jetAnimation() -> SKAction {
        let textures = (1...39).map { SKTexture(imageNamed: "f-\($0)") }
        let anim = SKAction.animate(with: textures, timePerFrame: gameSceneObjects.jetFrameTime)
        return anim
    }
    
    func setupJet(x: CGFloat, y: CGFloat, side: String) {
        let anim = self.jetAnimation()
        let boom = SKAction.repeatForever(anim)
        let fire = SKSpriteNode(texture: SKTexture(imageNamed: "f-1"))
        fire.setScale(gameSceneObjects.jetScale)
        fire.position = CGPoint(x: x, y: y)
        fire.zPosition = gameSceneObjects.jetZPosition
        fire.run(boom)
        
        if (side == directions.left) {
            fireLeft = fire
            self.addChild(fireLeft)
        } else if (side == directions.right) {
            fireRight = fire
            self.addChild(fireRight)
        }
    }
    
    func setupRock(_ rockType: NSString, score: Int) {
        let rock = SKSpriteNode(imageNamed: rockType as String)
        
        let minX = rock.size.width / 2
        let maxX = frame.size.width - rock.size.width / 2
        let positionX = CGFloat.random(in: minX...maxX)
        
        rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
        rock.physicsBody?.isDynamic = true
        rock.physicsBody?.categoryBitMask = collisions.rockCategory
        rock.physicsBody?.contactTestBitMask = collisions.shotCategory | collisions.playerCategory
        rock.physicsBody?.collisionBitMask = 0
        rock.zPosition = gameSceneObjects.rockZPosition
        rock.position = CGPoint(x: positionX, y: frame.size.height + rock.size.height)
        addChild(rock)
        
        let (minDuration, maxDuration) = getDurations(for: score)
        let duration = TimeInterval(Int.random(in: minDuration...maxDuration))
        
        let moveAction = SKAction.move(to: CGPoint(x: positionX, y: -rock.size.height), duration: duration)
        let removeAction = SKAction.removeFromParent()
        rock.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    func setupLife() {
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
    
    private func getDurations(for score: Int) -> (Int, Int) {
        switch score {
        case let x where x > 100:
            return (gameSceneObjects.rockHighScoreMinDuration, gameSceneObjects.rockHighScoreMaxDuration)
        case let x where x > 50:
            return (gameSceneObjects.rockMidScoreMinDuration, gameSceneObjects.rockMidScoreMaxDuration)
        default:
            return (gameSceneObjects.rockLowScoreMinDuration, gameSceneObjects.rockLowScoreMaxDuration)
        }
    }
    
    func setupHeader() {
        setupScoreIcon()
        setupLivesIcon()
        setupExitButton()
    }
    
    func setupScoreIcon() {
        scoreIcon = SKSpriteNode(imageNamed: assets.scoreIcon)
        scoreIcon.position = CGPoint(x: screenSize.width * gameHeaderProportion.scoreIconXProportion, y: screenSize.height * gameHeaderProportion.iconsYProportion)
        scoreIcon.zPosition = gameHeaderProportion.zPosition
        self.addChild(scoreIcon)
    }
    
    func setupLivesIcon() {
        livesIcon = SKSpriteNode(imageNamed: assets.heartIcon)
        livesIcon.position = CGPoint(x: screenSize.width * gameHeaderProportion.livesIconXProportion, y: screenSize.height * gameHeaderProportion.iconsYProportion)
        livesIcon.zPosition = gameHeaderProportion.zPosition
        self.addChild(livesIcon)
    }
}
