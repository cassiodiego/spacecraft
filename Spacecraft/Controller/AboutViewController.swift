//
//  AboutViewController.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 12/12/16.
//  Copyright (c) 2016 Cassio Diego Tavares Campos. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var howToPlaylabel: UILabel!
    @IBOutlet weak var howToPlayTextView: UITextView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var warningTextView: UITextView!
    @IBOutlet weak var spacecraftWebsite: UILabel!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        aboutTextView.text = NSLocalizedString("ABOUT_TEXTVIEW", comment: "About TextView")
        howToPlaylabel.text = NSLocalizedString("HOW_TO_PLAY_LABEL", comment: "How To Play Label")
        howToPlayTextView.text = NSLocalizedString("HOW_TO_PLAY_TEXTVIEW", comment: "How To Play TextView")
        warningLabel.text = NSLocalizedString("WARNING_LABEL", comment: "Warning Label")
        warningTextView.text = NSLocalizedString("WARNING_TEXTVIEW", comment: "Warning TextView")
        spacecraftWebsite.text = Constants.Author.site
        
        (Utils.alreadyExistDataForKey(key: Constants.DataConfigKeys.highscore)) ? (scoreLabel.text = (UserDefaults.standard.object(forKey: Constants.DataConfigKeys.highscore)! as? String)!) : (scoreLabel.text = "0")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}
