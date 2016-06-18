//
//  StartScene.swift
//  Galiga 1
//
//  Created by Rodrigo Ferreira on 11/06/16.
//  Copyright © 2016 Rodrigo Ferreira. All rights reserved.
//

import SpriteKit
import AVFoundation

class StartScene: SKScene {
    var rotation:Float = 0
    var Player = SKSpriteNode(imageNamed: "9-inc.png")
    var audioPlayer: AVAudioPlayer!

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "9 - INC Games"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:self.frame.size.width/2, y: self.frame.size.height/1.2)
        let path = NSBundle.mainBundle().pathForResource("gameSounds/This_Empty_Space.mp3", ofType:nil)!
        let url = NSURL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            audioPlayer = sound
            sound.play()
            sound.numberOfLoops = -1
        } catch {
            // couldn't load file :(
        }
        
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(StartScene.rotatePlayer), userInfo: nil, repeats: true)
        Player.position = CGPointMake(self.size.width/2, self.size.height/3)
        Player.setScale(0.4)
        
        
        
        self.addChild(Player)
        self.addChild(myLabel)
    }
    
    func rotatePlayer(){
        rotation -= 0.006283185307
        Player.removeFromParent()
        Player.zRotation = CGFloat(rotation)
        self.addChild(Player)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        let gameSceneTemp = GameScene(fileNamed: "GameScene")
        gameSceneTemp!.scaleMode = .AspectFill
        if audioPlayer != nil {
            audioPlayer.stop()
            audioPlayer = nil
        }
        
        self.scene!.view?.presentScene(gameSceneTemp!, transition: SKTransition.fadeWithDuration(1.5))
        
        
        
        
        
        
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}