//
//  GameOverSceneObjects.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 27/01/24.
//  Copyright (c) 2024 Cassio Diego Tavares Campos. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class GameOverSceneObjects: SKScene {
    
    var background: SKSpriteNode = SKSpriteNode()
    var exitButton: SKSpriteNode = SKSpriteNode()
    var message: String = String()
    var scoreMessage: String = String()
    
    let assets = Constants.Assets.self
    let gameHeaderProportion = Constants.GameHeaderProportions.self
    let screenSize = UIScreen.main.bounds

    func setupBackground() {
        self.backgroundColor = SKColor.black
        background = SKSpriteNode(imageNamed: assets.firstBackground)
        background.position = CGPoint(x: (screenSize.width * 0.40), y: (screenSize.height * 0.500))
        self.addChild(background)
    }
    
    func setupScoreBackground() {
        let scoreBackground: SKSpriteNode = SKSpriteNode(imageNamed: Constants.Assets.scoreBackgroundTwo)
        scoreBackground.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.834))
        scoreBackground.setScale(0.76)
        scoreBackground.zPosition = 3
        self.addChild(scoreBackground)
    }
    
    func setupSpacecraftLogo() {
        let spacecraftLogo: SKSpriteNode = SKSpriteNode(imageNamed: Constants.Assets.spacecraftLogo)
        spacecraftLogo.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.690))
        spacecraftLogo.zPosition = 3
        spacecraftLogo.setScale(0.22)
        self.addChild(spacecraftLogo)
    }
    
    func setupScoreLabel(won: Bool, score: String) {
        let scoreLabelText: String = NSLocalizedString("SCORE_LABEL", comment: "Last Score")
        let scoreLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        scoreLabel.text = scoreLabelText+score
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.465))
        scoreLabel.zPosition = 4
        self.addChild(scoreLabel)
    }
    
    func setupMessageLabel(won: Bool) {
        let messageLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        won ? (messageLabel.text = NSLocalizedString("WINNER_MESSAGE", comment: "Winner Message")) :
              (messageLabel.text = NSLocalizedString("GAME_OVER_LABEL", comment: "Loser Message"))
        messageLabel.fontColor = SKColor.white
        messageLabel.fontSize = 33
        messageLabel.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.540))
        messageLabel.zPosition = 3
        self.addChild(messageLabel)
    }
    
    func setupScoreTextLabel(highscore: String, score: String) {
        let scoreTextLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        (Int(score)! < Int(highscore)!) ? (scoreTextLabel.text = "\(highscore)") : (scoreTextLabel.text = "\(score)")
        scoreTextLabel.fontSize = 35
        scoreTextLabel.fontColor = SKColor.white
        scoreTextLabel.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.830))
        scoreTextLabel.zPosition = 2
        self.addChild(scoreTextLabel)
    }
    
    func setupEmailLabel() {
        let emailLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        emailLabel.text = Constants.Author.email
        emailLabel.fontSize = 14
        emailLabel.fontColor = SKColor.yellow
        emailLabel.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.070))
        emailLabel.zPosition = 1
        self.addChild(emailLabel)
    }
    
    func setupSpacecraftWebsiteLabel() {
        let spacecraftWebsiteLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        spacecraftWebsiteLabel.text = Constants.Author.site
        spacecraftWebsiteLabel.fontSize = 18
        spacecraftWebsiteLabel.fontColor = SKColor.yellow
        spacecraftWebsiteLabel.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.100))
        spacecraftWebsiteLabel.zPosition = 1
        self.addChild(spacecraftWebsiteLabel)
    }
    
    func setupTouchToRestartLabel() {
        let touchToRestartLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        touchToRestartLabel.text = NSLocalizedString("RESTART_LABEL", comment: "Restart game")
        touchToRestartLabel.fontSize = 10
        touchToRestartLabel.fontColor = SKColor.white
        touchToRestartLabel.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.360))
        touchToRestartLabel.zPosition = 1
        self.addChild(touchToRestartLabel)
    }
    
    func setupStars() {
        if let starParticles = SKEmitterNode(fileNamed: "StarEmitter.sks") {
            starParticles.position = CGPoint(x: size.width/2, y: size.height)
            starParticles.name = assets.starParticle
            starParticles.targetNode = scene
            addChild(starParticles)
        }
    }
    
    func setupExitButton() {
        exitButton = SKSpriteNode(imageNamed: assets.exitButton)
        exitButton.position = CGPoint(x: screenSize.width * gameHeaderProportion.exitButtonXProportion, y: screenSize.height * gameHeaderProportion.exitButtonYProportion)
        exitButton.zPosition = gameHeaderProportion.zPosition
        exitButton.setScale(gameHeaderProportion.exitButtonScale)
        self.addChild(exitButton)
    }
}
