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
    var Player = SKSpriteNode(imageNamed: "9-inc2.png")
    var audioPlayer: AVAudioPlayer!
    var Timer = NSTimer()

    
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
        
        
        Timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(StartScene.rotatePlayer), userInfo: nil, repeats: true)
        Player.position = CGPointMake(self.size.width/2, self.size.height/3)
//        Player.setScale(0.4)
        
        
        
        self.addChild(Player)
        self.addChild(myLabel)
    }
    
    func rotatePlayer(){
        if Player.zRotation == CGFloat(M_PI){
            Player.zRotation = 0
        }
        rotation -= Float(M_PI)/500
//        Player.removeFromParent()
        Player.zRotation = CGFloat(rotation)
//        self.addChild(Player)
    }
    func destroyScene(){
        let gameSceneTemp = GameScene(fileNamed: "GameScene")
        gameSceneTemp!.scaleMode = .AspectFill
        self.scene!.view?.presentScene(gameSceneTemp!, transition: SKTransition.fadeWithDuration(1.5))
        Timer.invalidate()
        Player.alpha=1
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if audioPlayer != nil {
            audioPlayer.stop()
            audioPlayer = nil
        }
        
        Timer.invalidate()
        var action = Array<SKAction>()
        action.append(SKAction.rotateToAngle(round(Player.zRotation/CGFloat(2*M_PI))*CGFloat(2*M_PI), duration: 1.0))
//        NSLog("\(round(Player.zRotation/CGFloat(2*M_PI))), \(round(Player.zRotation/CGFloat(2*M_PI))*CGFloat(2*M_PI)), \(Player.zRotation), \(2*M_PI)")
        action.append(SKAction.moveTo(CGPointMake(self.size.width/2, self.size.height/6), duration: 1.0))
        action.append(SKAction.scaleTo(0.283, duration: 1.0))
        let group = SKAction.group(action)
        Player.runAction(group)
        
        Timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(StartScene.destroyScene), userInfo: nil, repeats: true)
        
        
        
        
        
        
        
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}