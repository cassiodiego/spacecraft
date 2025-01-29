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

class GameOverSceneObjects: BaseSceneObjects {
    
    var background: SKSpriteNode = SKSpriteNode()
    var message: String = String()
    var scoreMessage: String = String()
    
    let gameOverSceneObjects = Constants.GameOverSceneObjects.self
    
    func setupBackground() {
        self.backgroundColor = SKColor.black
        background = SKSpriteNode(imageNamed: Constants.Assets.firstBackground)
        background.position = CGPoint(x: (screenSize.width * gameOverSceneObjects.backgroundXProportion), y: (screenSize.height * gameOverSceneObjects.backgroundYProportion))
        self.addChild(background)
    }
    
    func setupScoreBackground() {
        let scoreBackground: SKSpriteNode = SKSpriteNode(imageNamed: Constants.Assets.scoreBackgroundTwo)
        scoreBackground.position = CGPoint(x: (screenSize.width * gameOverSceneObjects.scoreBackgroundXProportion), y: (screenSize.height * gameOverSceneObjects.scoreBackgroundYProportion))
        scoreBackground.setScale(gameOverSceneObjects.scoreBackgroundScale)
        scoreBackground.zPosition = gameOverSceneObjects.scoreBackgroundZPosition
        self.addChild(scoreBackground)
    }
    
    func setupSpacecraftLogo() {
        let spacecraftLogo: SKSpriteNode = SKSpriteNode(imageNamed: Constants.Assets.spacecraftLogo)
        spacecraftLogo.position = CGPoint(x: (screenSize.width * gameOverSceneObjects.spacecraftLogoXProportion), y: (screenSize.height * gameOverSceneObjects.spacecraftLogoYProportion))
        spacecraftLogo.zPosition = gameOverSceneObjects.spacecraftLogoZPosition
        spacecraftLogo.setScale(gameOverSceneObjects.spacecraftLogoScale)
        self.addChild(spacecraftLogo)
    }
    
    func setupScoreLabel(won: Bool, score: String) {
        let scoreLabelText: String = NSLocalizedString("SCORE_LABEL", comment: "Last Score")
        let scoreLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        scoreLabel.text = scoreLabelText + score
        scoreLabel.fontSize = gameOverSceneObjects.scoreLabelFontSize
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: (screenSize.width * gameOverSceneObjects.scoreLabelXProportion), y: (screenSize.height * gameOverSceneObjects.scoreLabelYProportion))
        scoreLabel.zPosition = gameOverSceneObjects.scoreLabelZPosition
        self.addChild(scoreLabel)
    }
    
    func setupMessageLabel(won: Bool) {
        let messageLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        won ? (messageLabel.text = NSLocalizedString("WINNER_MESSAGE", comment: "Winner Message")) : (messageLabel.text = NSLocalizedString("GAME_OVER_LABEL", comment: "Loser Message"))
        messageLabel.fontColor = SKColor.white
        messageLabel.fontSize = gameOverSceneObjects.messageLabelFontSize
        messageLabel.position = CGPoint(x: (screenSize.width * gameOverSceneObjects.messageLabelXProportion), y: (screenSize.height * gameOverSceneObjects.messageLabelYProportion))
        messageLabel.zPosition = gameOverSceneObjects.messageLabelZPosition
        self.addChild(messageLabel)
    }
    
    func setupScoreTextLabel(highscore: String, score: String) {
        let scoreTextLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        (Int(score)! < Int(highscore)!) ? (scoreTextLabel.text = "\(highscore)") : (scoreTextLabel.text = "\(score)")
        scoreTextLabel.fontSize = gameOverSceneObjects.scoreTextLabelFontSize
        scoreTextLabel.fontColor = SKColor.white
        scoreTextLabel.position = CGPoint(x: (screenSize.width * gameOverSceneObjects.scoreTextLabelXProportion), y: (screenSize.height * gameOverSceneObjects.scoreTextLabelYProportion))
        scoreTextLabel.zPosition = gameOverSceneObjects.scoreTextLabelZPosition
        self.addChild(scoreTextLabel)
    }
    
    func setupEmailLabel() {
        let emailLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        emailLabel.text = Constants.Author.email
        emailLabel.fontSize = gameOverSceneObjects.emailLabelFontSize
        emailLabel.fontColor = SKColor.yellow
        emailLabel.position = CGPoint(x: (screenSize.width * gameOverSceneObjects.emailLabelXProportion), y: (screenSize.height * gameOverSceneObjects.emailLabelYProportion))
        emailLabel.zPosition = gameOverSceneObjects.emailLabelZPosition
        self.addChild(emailLabel)
    }
    
    func setupSpacecraftWebsiteLabel() {
        let spacecraftWebsiteLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        spacecraftWebsiteLabel.text = Constants.Author.site
        spacecraftWebsiteLabel.fontSize = gameOverSceneObjects.spacecraftWebsiteLabelFontSize
        spacecraftWebsiteLabel.fontColor = SKColor.yellow
        spacecraftWebsiteLabel.position = CGPoint(x: (screenSize.width * gameOverSceneObjects.spacecraftWebsiteLabelXProportion), y: (screenSize.height * gameOverSceneObjects.spacecraftWebsiteLabelYProportion))
        spacecraftWebsiteLabel.zPosition = gameOverSceneObjects.spacecraftWebsiteLabelZPosition
        self.addChild(spacecraftWebsiteLabel)
    }
    
    func setupTouchToRestartLabel() {
        let touchToRestartLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        touchToRestartLabel.text = NSLocalizedString("RESTART_LABEL", comment: "Restart game")
        touchToRestartLabel.fontSize = gameOverSceneObjects.touchToRestartLabelFontSize
        touchToRestartLabel.fontColor = SKColor.white
        touchToRestartLabel.position = CGPoint(x: (screenSize.width * gameOverSceneObjects.touchToRestartLabelXProportion), y: (screenSize.height * gameOverSceneObjects.touchToRestartLabelYProportion))
        touchToRestartLabel.zPosition = gameOverSceneObjects.touchToRestartLabelZPosition
        self.addChild(touchToRestartLabel)
    }
}
