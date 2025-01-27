//
//  BaseSceneObjects.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 27/01/24.
//  Copyright (c) 2024 Cassio Diego Tavares Campos. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class BaseSceneObjects: SKScene {
    
    var exitButton: SKSpriteNode = SKSpriteNode()
    let assets = Constants.Assets.self
    let gameHeaderProportion = Constants.GameHeaderProportions.self
    let screenSize = UIScreen.main.bounds

    func setupExitButton() {
        exitButton = SKSpriteNode(imageNamed: assets.exitButton)
        exitButton.position = CGPoint(x: screenSize.width * gameHeaderProportion.exitButtonXProportion, y: screenSize.height * gameHeaderProportion.exitButtonYProportion)
        exitButton.zPosition = gameHeaderProportion.zPosition
        exitButton.setScale(gameHeaderProportion.exitButtonScale)
        self.addChild(exitButton)
    }

    func setupStars() {
        if let starParticles = SKEmitterNode(fileNamed: "StarEmitter.sks") {
            starParticles.position = CGPoint(x: size.width / 2, y: size.height)
            starParticles.name = assets.starParticle
            starParticles.targetNode = scene
            addChild(starParticles)
        }
    }
}
