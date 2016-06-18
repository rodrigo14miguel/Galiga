//
//  EndScene.swift
//  Galiga 1
//
//  Created by Rodrigo Ferreira on 07/06/16.
//  Copyright © 2016 Rodrigo Ferreira. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class EndScene: SKScene {
    
    
    var restartBTN: UIButton!
    var HighScore: Int!
    var ScoreLabel: UILabel!
    var HighScoreLabel: UILabel!
    var audioPlayer: AVAudioPlayer!
    
    override func didMoveToView(view: SKView) {
        
        let path = NSBundle.mainBundle().pathForResource("gameSounds/SteveCombs_Adrift.mp3", ofType:nil)!
        let url = NSURL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            audioPlayer = sound
            
            sound.volume = 0.0
            sound.play()
            sound.numberOfLoops = -1
        } catch {
            // couldn't load file :(
        }
        
        //fade in sound em 100 passos durante 2 segundos
        let fadeSteps = 100
        let timePerStep = 5.0/Float(fadeSteps)
        for step in 0...fadeSteps{
            let delayInSeconds = Float(step) * timePerStep
            
            let popTime = dispatch_time(DISPATCH_TIME_NOW,Int64(delayInSeconds * Float(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue(), { 
                let fraction = (Float(step) / Float(fadeSteps))
                self.audioPlayer.volume = fraction
            })
        }
        
        
        scene?.backgroundColor = UIColor.whiteColor()
        
        restartBTN = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 3, height: view.frame.size.height / 20 ))
        restartBTN.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 5)
        
        restartBTN.setTitle("Restart", forState: UIControlState.Normal)
        restartBTN.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        //delay para mostrar botao restart
        restartBTN.addTarget(self, action: #selector(EndScene.restart), forControlEvents: UIControlEvents.TouchUpInside)
        let popTime = dispatch_time(DISPATCH_TIME_NOW,Int64(5.0 * Float(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.view?.addSubview(self.restartBTN)
        })
        
        
        let ScoreDefault = NSUserDefaults.standardUserDefaults()
        let Score = ScoreDefault.valueForKey("Score") as! NSInteger
        
        let HighScoreDefault = NSUserDefaults.standardUserDefaults()
        HighScore = HighScoreDefault.valueForKey("HighScore") as! NSInteger
        
        ScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 2, height: view.frame.size.height / 20 ))
        ScoreLabel.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 4)
        ScoreLabel.text = "Your Score: \(Score)"
        self.view?.addSubview(ScoreLabel)
        
        HighScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width / 2, height: view.frame.size.height / 20 ))
        HighScoreLabel.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 3)
        HighScoreLabel.text = "High Score: \(HighScore)"
        self.view?.addSubview(HighScoreLabel)
        
    }
    
    
    func restart(){
        restartBTN.removeFromSuperview()
        if let scene =  GameScene(fileNamed: "GameScene"){
            scene.backgroundColor = SKColor.darkGrayColor()
            scene.scaleMode = .AspectFill
            let fadeSteps = 100
            let timePerStep = 1.0/Float(fadeSteps)
            for step in 0...fadeSteps{
                let delayInSeconds = Float(step) * timePerStep
                
                let popTime = dispatch_time(DISPATCH_TIME_NOW,Int64(delayInSeconds * Float(NSEC_PER_SEC)))
                dispatch_after(popTime, dispatch_get_main_queue(), {
                    let fraction = (Float(step) / Float(fadeSteps))
                    self.audioPlayer.volume = 1.0-fraction
                })
            }
            let transition = SKTransition.crossFadeWithDuration(1.5)
            self.scene?.view?.presentScene(scene, transition: transition)
            ScoreLabel.removeFromSuperview()
            HighScoreLabel.removeFromSuperview()
        }
    }
}