//
//  Constants.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 16/05/20.
//  Copyright © 2020 Cassio Diego Tavares Campos. All rights reserved.
//

import Foundation

struct Constants {

    struct Assets {
        static let firstBackground: String = "background"
        static let rockOne: NSString = "rock_1"
        static let rockTwo: NSString = "rock_2"
        static let rockThree: NSString = "rock_3"
        static let whiteStar: String = "star"
        static let yellowStar: String = "yellowStar"
        static let orangeShot: String = "orangeShot"
        static let blueShot: String = "blueShot"
        static let armory: String = "Armory"
        static let rinzler: String = "Rinzler"
        static let spacecraftLogo = "spacecraftLogo"
        static let twoShips = "twoShips"
        static let shotSound: String = "shotSound"
    }

    struct Directions {
        static let left: String = "left"
        static let right: String = "right"
    }
    struct Fonts {
        static let main: String = "Helvetica"
    }
    struct CollisionCategories {
        static let rockCategory: UInt32 = 0x1 << 1
        static let shotCategory: UInt32 = 0x1 << 0
        static let playerCategory: UInt32 = 0x1 << 0
        static let EdgeBody: UInt32 = 0x1 << 4
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
    struct SupportedLanguages {
        static let english: [String] = ["en"]
        static let portuguese: [String] = ["pt", "pt-BR", "pt-PT"]
        static let spanish: [String] = ["es", "es-ES", "es-HN", "es-CO", "es-PA", "es-SV", "es-CR", "es-PE", "es-BO", "es-GQ", "es-MX", "es-GT", "es-419", "es-AR", "es-PR", "es-US", "es-NI", "es-PY", "es-UY", "es-DO", "es-CL", "es-VE"]
    }
    struct Levels {
    }

}
