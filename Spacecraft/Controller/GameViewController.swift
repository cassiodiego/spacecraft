//
//  GameViewController.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 31/05/16.
//  Copyright (c) 2016 Casssio Diego Tavares Campos. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import GameKit

extension SKNode {
    
    class func unarchiveFromFile(_ file : NSString) -> SKNode? {
        
        let path = Bundle.main.path(forResource: file as String, ofType: "sks")
        
        var sceneData = Data()
        
        do {
            
            try sceneData = Data(contentsOf: URL(fileURLWithPath: path!), options:NSData.ReadingOptions.mappedIfSafe)
            
        } catch { abort() }
        
        let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        
        let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
        
        archiver.finishDecoding()
        
        return scene
    }
}

class GameViewController: UIViewController {
        
    var backgroundMusicPlayer:AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
    }
    
    override func viewWillLayoutSubviews() {
        
        let musicIsOn = UserDefaults.standard.bool(forKey: "musicStatus")
        
        if musicIsOn {
            let bgMusicURL:URL = Bundle.main.url(forResource: "Spacecraft", withExtension: "mp3")!
            backgroundMusicPlayer = try! AVAudioPlayer(contentsOf: bgMusicURL)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        }
        
        let skView:SKView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        
        let scene = GameScene(size: view.bounds.size)
        _ = GameScene(size:skView.bounds.size)
        scene.scaleMode = SKSceneScaleMode.aspectFill
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        
    }

    override var shouldAutorotate : Bool {
        
        return false
        
    }

    @IBAction func backHome(_ sender: Any) {
        
        self.view.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)

        
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            return UIInterfaceOrientationMask.allButUpsideDown
            
        } else {
            
            return UIInterfaceOrientationMask.all
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override var prefersStatusBarHidden : Bool {
        
        return true
        
    }
    
}
