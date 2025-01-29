//
//  Constants.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 16/05/20.
//  Copyright © 2020 Cassio Diego Tavares Campos. All rights reserved.
//

import Foundation
import UIKit

struct Constants {

    struct Assets {
        static let firstBackground: String = "background"
        static let auroraOne: String = "auroraOne"
        static let rockOne: NSString = "rockOne"
        static let rockTwo: NSString = "rockTwo"
        static let rockThree: NSString = "rockThree"
        static let whiteStar: String = "whiteStar"
        static let starParticle: String = "starParticle"
        static let yellowStar: String = "yellowStar"
        static let orangeShot: String = "orangeShot"
        static let blueShot: String = "blueShot"
        static let armory: String = "Armory"
        static let rinzler: String = "Rinzler"
        static let spacecraftLogo = "spacecraftLogo"
        static let twoShips = "twoShips"
        static let shotSound: String = "shotSound"
        static let backgroundMusicOne: String = "backgroundMusicOne"
        static let scoreBackgroundOne: String = "scoreBackgroundOne"
        static let scoreBackgroundTwo: String = "scoreBackgroundTwo"
        static let scoreIcon: String = "scoreIcon"
        static let heartIcon: String = "heartIcon"
        static let exitButton: String = "x"
        static let life: String = "heartIcon"  // Adicionada constante para a imagem da vida
    }

    struct Directions {
        static let left: String = "left"
        static let right: String = "right"
    }
    
    struct UI {
        static let spacecraftBlue: UIColor = Utils.hexStringToUIColor(hex: "#1C5FAA")
    }
    
    struct Fonts {
        static let main: String = "Helvetica"
        static let pressStart: String = "PressStart2P-Regular"
    }
    
    struct CollisionCategories {
        static let rockCategory: UInt32 = 0x1 << 1
        static let shotCategory: UInt32 = 0x1 << 0
        static let playerCategory: UInt32 = 0x1 << 0
        static let life: UInt32 = 0x1 << 2  // Adicionada constante para a categoria de colisão da vida
        static let EdgeBody: UInt32 = 0x1 << 4
    }
    
    struct GameHeaderProportions {
        static let scoreIconXProportion: CGFloat = 0.12
        static let livesIconXProportion: CGFloat = 0.48
        static let exitButtonXProportion: CGFloat = 0.84
        static let iconsYProportion: CGFloat = 0.895
        static let exitButtonYProportion: CGFloat = 0.896
        static let zPosition: CGFloat = 20
        static let exitButtonScale: CGFloat = 0.50
    }

    struct DataConfigKeys {
        static let highscore: String = "highscore"
        static let ship: String = "ship"
        static let soundStatus: String = "soundStatus"
        static let musicStatus: String = "musicStatus"
    }
    
    struct GameCenterConfig {
        static let leaderboardId: String = "LeaderboardSpacecraftI"
    }

    struct GameConfigInitialValues {
        static let velocity = 200/1
    }
    
    struct AcelerometerValues {
        static let accelerometerUpdateInterval: Double = 0.1
        static let accelerationXMult: Double = 500
    }
    
    struct RockAssetsValues {
        static let firstLevelValue: Int = 25
        static let secondLevelValue: Int = 50
        static let thirdLevelvalue: Int = 200
    }
    
    struct Author {
        static let email: String = "hello@cassiodiego.com"
        static let site: String = "cassiodiego.com"
    }
    
    struct GameSceneObjects {
        static let playerInitialYPosition: CGFloat = 30.0
        static let playerZPosition: CGFloat = 5.0
        static let velocityMultiplier: CGFloat = 900.0
        static let jetXOffset: CGFloat = 10.0
        static let jetYOffset: CGFloat = 30.0
        static let auroraZPosition: CGFloat = 2.0
        static let auroraMoveDuration: TimeInterval = 25.0
        static let explosionFrameTime: TimeInterval = 0.09
        static let explosionScale: CGFloat = 0.6
        static let explosionZPosition: CGFloat = 6.0
        static let explosionRemovalDelay: TimeInterval = 0.1
        static let jetFrameTime: TimeInterval = 0.09
        static let jetScale: CGFloat = 0.05
        static let jetZPosition: CGFloat = 4.0
        static let rockZPosition: CGFloat = 4.0
        static let rockHighScoreMinDuration: Int = 1
        static let rockHighScoreMaxDuration: Int = 1
        static let rockMidScoreMinDuration: Int = 1
        static let rockMidScoreMaxDuration: Int = 4
        static let rockLowScoreMinDuration: Int = 2
        static let rockLowScoreMaxDuration: Int = 4
    }
    
    struct GameOverSceneObjects {
        static let backgroundXProportion: CGFloat = 0.40
        static let backgroundYProportion: CGFloat = 0.500
        static let scoreBackgroundXProportion: CGFloat = 0.50
        static let scoreBackgroundYProportion: CGFloat = 0.834
        static let scoreBackgroundScale: CGFloat = 0.76
        static let scoreBackgroundZPosition: CGFloat = 3.0
        static let spacecraftLogoXProportion: CGFloat = 0.50
        static let spacecraftLogoYProportion: CGFloat = 0.690
        static let spacecraftLogoScale: CGFloat = 0.22
        static let spacecraftLogoZPosition: CGFloat = 3.0
        static let scoreLabelFontSize: CGFloat = 20
        static let scoreLabelXProportion: CGFloat = 0.50
        static let scoreLabelYProportion: CGFloat = 0.465
        static let scoreLabelZPosition: CGFloat = 4.0
        static let messageLabelFontSize: CGFloat = 33
        static let messageLabelXProportion: CGFloat = 0.50
        static let messageLabelYProportion: CGFloat = 0.540
        static let messageLabelZPosition: CGFloat = 3.0
        static let scoreTextLabelFontSize: CGFloat = 35
        static let scoreTextLabelXProportion: CGFloat = 0.50
        static let scoreTextLabelYProportion: CGFloat = 0.830
        static let scoreTextLabelZPosition: CGFloat = 2.0
        static let emailLabelFontSize: CGFloat = 14
        static let emailLabelXProportion: CGFloat = 0.50
        static let emailLabelYProportion: CGFloat = 0.070
        static let emailLabelZPosition: CGFloat = 1.0
        static let spacecraftWebsiteLabelFontSize: CGFloat = 18
        static let spacecraftWebsiteLabelXProportion: CGFloat = 0.50
        static let spacecraftWebsiteLabelYProportion: CGFloat = 0.100
        static let spacecraftWebsiteLabelZPosition: CGFloat = 1.0
        static let touchToRestartLabelFontSize: CGFloat = 10
        static let touchToRestartLabelXProportion: CGFloat = 0.50
        static let touchToRestartLabelYProportion: CGFloat = 0.360
        static let touchToRestartLabelZPosition: CGFloat = 1.0
    }

    struct GameSceneConstants {
        static let initialSpacecraftCollisions: Int = 4
        static let backgroundXProportion: CGFloat = 0.40
        static let backgroundYProportion: CGFloat = 0.50
        static let backgroundZPosition: CGFloat = 1
        static let scoreLabelXProportion: CGFloat = 0.24
        static let scoreLabelYProportion: CGFloat = 0.88
        static let scoreLabelZPosition: CGFloat = 2
        static let livesLabelXProportion: CGFloat = 0.57
        static let livesLabelYProportion: CGFloat = 0.88
        static let livesLabelZPosition: CGFloat = 2
        static let maxUpdateInterval: TimeInterval = 1.0 / 60.0
        static let playerMoveDuration: TimeInterval = 1.0
        static let jetXOffset: CGFloat = 10.0
        static let rockYieldInterval: TimeInterval = 1.0
        static let auroraYieldInterval: TimeInterval = 5.0
        static let lifeYieldInterval: TimeInterval = 10.0
        static let lifeZPosition: CGFloat = 5.0
        static let lifeFallDuration: TimeInterval = 6.0
    }
}
