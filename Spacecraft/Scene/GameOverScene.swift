//
//  GameOverScene.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 31/05/16.
//  Copyright (c) 2016 Cassio Diego Tavares Campos. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import GameKit

class GameOverScene: GameSceneObjects {

    var background: SKSpriteNode = SKSpriteNode()
    var viewController: UIViewController?
    var message: String = String()
    var scoreMessage: String = String()
    let screenSize = UIScreen.main.bounds
    
    init(size: CGSize, won: Bool, score: String) {
        
        super.init(size: size)
        
        setupBackground()
        
        var highscore: String
        Utils.alreadyExistDataForKey(key: Constants.DataConfigKeys.highscore) ? (highscore = (UserDefaults.standard.object(forKey: Constants.DataConfigKeys.highscore)! as? String)!) : (highscore = "0")

        if (Int(score))! > (Int(highscore))! {
            UserDefaults.standard.set(score, forKey: Constants.DataConfigKeys.highscore)
            GameCenterViewController().syncScore()
        }

        setupScoreBackground()
        setupSpacecraftLogo()
        setupMessageLabel(won: won)
        setupScoreLabel(won: won, score: score)
        setupScoreTextLabel(highscore: highscore, score: score)
        setupTouchToRestartLabel()
        setupSpacecraftWebsiteLabel()
        setupEmailLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupStars()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if touchLocation.x != 0 {
            let transition: SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameScene: SKScene = GameScene(size: self.size)
            self.view!.presentScene(gameScene, transition: transition)
        }
    }
    
    func setupBackground() {
        self.backgroundColor = SKColor.black
        background = SKSpriteNode(imageNamed: self.assets.firstBackground)
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
        let scoreLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        won ? (scoreLabel.text = NSLocalizedString("SCORE: \(score)", comment: "Winner Score")) :
              (scoreLabel.text = NSLocalizedString("SCORE: \(score)", comment: "Looser Score"))
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.465))
        scoreLabel.zPosition = 4
        self.addChild(scoreLabel)
    }
    
    func setupMessageLabel(won: Bool) {
        let messageLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        won ? (messageLabel.text = NSLocalizedString("YOU WIN, CONGRATULATIONS!", comment: "Winner Message")) :
              (messageLabel.text = NSLocalizedString("GAME OVER", comment: "Looser Message"))
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
        touchToRestartLabel.text = NSLocalizedString("TOUCH TO RESTART", comment: "Restart game") as NSString as String
        touchToRestartLabel.fontSize = 10
        touchToRestartLabel.fontColor = SKColor.white
        touchToRestartLabel.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.360))
        touchToRestartLabel.zPosition = 1
        self.addChild(touchToRestartLabel)
    }
    
}
