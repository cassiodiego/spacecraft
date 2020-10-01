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
    let spanish = Constants.SupportedLanguages.spanish.self
    let portuguese = Constants.SupportedLanguages.portuguese.self
    let english = Constants.SupportedLanguages.english.self

    init(size: CGSize, won: Bool, score: String) {
        super.init(size: size)
        self.backgroundColor = SKColor.black
        let preferredLanguage = NSLocale.preferredLanguages[0] as String
        var message: NSString = NSString()
        var scoreLabel: NSString = NSString()
        let screenSize = UIScreen.main.bounds
        _ = screenSize.width
        _ = screenSize.height

        background = SKSpriteNode(imageNamed: self.assets.firstBackground)
        background.position = CGPoint(x: (screenSize.width * 0.40), y: (screenSize.height * 0.500))

        if (won) {
            if portuguese.contains(preferredLanguage) {
                message = "VOCÊ GANHOU, PARABÉNS!"
                scoreLabel = "SCORE: \(score)" as NSString
            } else if spanish.contains(preferredLanguage) {
                message = "TE HAS GANADO, ¡PARABÉNS!"
                scoreLabel = "SCORE: \(score)" as NSString
            } else {
                message = "YOU WIN, CONGRATULATIONS!"
                scoreLabel = "SCORE: \(score)" as NSString
            }

        } else {
            if portuguese.contains(preferredLanguage) {
                message = "VOCÊ PERDEU"
                scoreLabel = "PONTUAÇÃO: \(score)" as NSString
            } else if spanish.contains(preferredLanguage) {
                message = "JUEGO TERMINADO"
                scoreLabel = "PUNTUACIÓN: \(score)" as NSString
            } else {
                message = "GAME OVER"
                scoreLabel = "SCORE: \(score)" as NSString
            }

        }
        var highscore: String
        Utils.alreadyExistDataForKey(key: Constants.DataConfigKeys.highscore) ? (highscore = (UserDefaults.standard.object(forKey: Constants.DataConfigKeys.highscore)! as? String)!) : (highscore = "0")

        if (Int(score))! > (Int(highscore))! {
            UserDefaults.standard.set(score, forKey: Constants.DataConfigKeys.highscore)
            GameCenterViewController().syncScore()
        }
        self.addChild(background)

        let bgScore: SKSpriteNode = SKSpriteNode(imageNamed: "score2")
        bgScore.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.834))
        bgScore.setScale(0.76)
        bgScore.zPosition = 3
        self.addChild(bgScore)

        let spacecraftLogo: SKSpriteNode = SKSpriteNode(imageNamed: Constants.Assets.spacecraftLogo)
        spacecraftLogo.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.690))
        spacecraftLogo.zPosition = 3
        spacecraftLogo.setScale(0.22)
        self.addChild(spacecraftLogo)

        let label1 = SKLabelNode(fontNamed: Constants.Fonts.main)
        label1.text = message as String
        label1.fontColor = SKColor.white
        label1.fontSize = 33
        label1.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.540))
        label1.zPosition = 3
        self.addChild(label1)

        let label2 = SKLabelNode(fontNamed: Constants.Fonts.main)
        label2.text = scoreLabel as String
        label2.fontSize = 20
        label2.fontColor = SKColor.white
        label2.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.465))
        label2.zPosition = 4
        self.addChild(label2)

        let scoreTextLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        if Int(score)! < Int(highscore)! {
            scoreTextLabel.text = "\(highscore)"
        } else { scoreTextLabel.text = "\(score)" }
        scoreTextLabel.fontSize = 35
        scoreTextLabel.fontColor = SKColor.white
        scoreTextLabel.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.830))
        scoreTextLabel.zPosition = 2
        self.addChild(scoreTextLabel)
        let touchToRestartLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        if preferredLanguage == "pt-BR" {
            touchToRestartLabel.text = "TOQUE NA TELA PARA RECOMEÇAR"
            } else if spanish.contains(preferredLanguage) {

            touchToRestartLabel.text = "TOQUE PARA REINICIAR"
        } else {
            touchToRestartLabel.text = "TOUCH TO RESTART"
        }
        touchToRestartLabel.fontSize = 10
        touchToRestartLabel.fontColor = SKColor.white
        touchToRestartLabel.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.360))
        touchToRestartLabel.zPosition = 1
        self.addChild(touchToRestartLabel)

        let spacecraftWebsiteLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        spacecraftWebsiteLabel.text = "cassiodiego.com"
        spacecraftWebsiteLabel.fontSize = 18
        spacecraftWebsiteLabel.fontColor = SKColor.yellow
        spacecraftWebsiteLabel.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.100))
        spacecraftWebsiteLabel.zPosition = 1
        self.addChild(spacecraftWebsiteLabel)

        let emailLabel = SKLabelNode(fontNamed: Constants.Fonts.main)
        if preferredLanguage == "pt-BR" {
            emailLabel.text = "contato@cassiodiego.com"
            } else if spanish.contains(preferredLanguage) {
            emailLabel.text = "contacto@cassiodiego.com"
        } else {
            emailLabel.text = "contact@cassiodiego.com"
        }
        emailLabel.fontSize = 14
        emailLabel.fontColor = SKColor.yellow
        emailLabel.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.070))
        emailLabel.zPosition = 1
        self.addChild(emailLabel)
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
}
