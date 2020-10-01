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

        let preferredLanguage = NSLocale.preferredLanguages[0] as String

        self.backgroundColor = SKColor.black

        var message: NSString = NSString()
        var scoreLabel: NSString = NSString()

        let screenSize = UIScreen.main.bounds
        _ = screenSize.width
        _ = screenSize.height

        background = SKSpriteNode(imageNamed: "background")
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
        Utils.alreadyExistDataForKey(key: Constants.DataConfigKeys.highscore) ? (highscore = (UserDefaults.standard.object(forKey: "highscore")! as? String)!) : (highscore = "0")

        if (Int(score))! > (Int(highscore))! {
            UserDefaults.standard.set(score, forKey: "highscore")
            GameCenterViewController().syncScore()
        }
        self.addChild(background)

        let bgScore: SKSpriteNode = SKSpriteNode(imageNamed: "score2")
        bgScore.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.834))
        bgScore.setScale(0.76)
        bgScore.zPosition = 3
        self.addChild(bgScore)

        let logo: SKSpriteNode = SKSpriteNode(imageNamed: "SpacecraftLogo")
        logo.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.690))
        logo.zPosition = 3
        logo.setScale(0.22)
        self.addChild(logo)

        let label1 = SKLabelNode(fontNamed: "Helvetica")
        label1.text = message as String
        label1.fontColor = SKColor.white
        label1.fontSize = 33
        label1.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.540))
        label1.zPosition = 3
        self.addChild(label1)

        let label2 = SKLabelNode(fontNamed: "Helvetica")
        label2.text = scoreLabel as String
        label2.fontSize = 20
        label2.fontColor = SKColor.white
        label2.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.465))
        label2.zPosition = 4
        self.addChild(label2)

        let label3 = SKLabelNode(fontNamed: "Helvetica")
        if Int(score)! < Int(highscore)! {
            label3.text = "\(highscore)"
        } else { label3.text = "\(score)" }
        label3.fontSize = 35
        label3.fontColor = SKColor.white
        label3.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.830))
        label3.zPosition = 2
        self.addChild(label3)
        let label4 = SKLabelNode(fontNamed: "Helvetica")
        if preferredLanguage == "pt-BR" {
            label4.text = "TOQUE NA TELA PARA RECOMEÇAR"
            } else if spanish.contains(preferredLanguage) {

            label4.text = "TOQUE PARA REINICIAR"
        } else {
            label4.text = "TOUCH TO RESTART"
        }
        label4.fontSize = 10
        label4.fontColor = SKColor.white
        label4.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.360))
        label4.zPosition = 1
        self.addChild(label4)

        let label5 = SKLabelNode(fontNamed: "Helvetica")
        label5.text = "spacecraft.com.br"
        label5.fontSize = 18
        label5.fontColor = SKColor.yellow
        label5.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.100))
        label5.zPosition = 1
        self.addChild(label5)

        let label6 = SKLabelNode(fontNamed: "Helvetica")
        if preferredLanguage == "pt-BR" {
            label6.text = "contato@cassiodiego.com"
            } else if spanish.contains(preferredLanguage) {
            label6.text = "contacto@cassiodiego.com"
        } else {
            label6.text = "contact@cassiodiego.com"
        }
        label6.fontSize = 14
        label6.fontColor = SKColor.yellow
        label6.position = CGPoint(x: (screenSize.width * 0.50), y: (screenSize.height * 0.070))
        label6.zPosition = 1
        self.addChild(label6)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) { }
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
