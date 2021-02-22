//
//  GameScene.swift
//  SuperPancakeFlipper
//
//  Created by KNIGHT, THOMAS (Student) on 12/11/2020.
//  Copyright © 2020 KNIGHT, THOMAS (Student). All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import AVFoundation

class GameScene: SKScene {
    
    //Get screen details
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //Add sprites
    let fryingPan = SKSpriteNode(imageNamed: "Spr_FryingPanSPF")
    let currentPancake = SKSpriteNode(imageNamed: "Spr_PancakeSPF0")
    let hob = SKSpriteNode(imageNamed: "Spr_Hob")
    let finishButton = SKSpriteNode(imageNamed: "Spr_New")
    let binButton = SKSpriteNode(imageNamed: "Spr_Bin")
    
    //Set Cooking Variables
    var cookedLevelTop : CGFloat = 0.0
    var cookedLevelBottom : CGFloat = 0.0
    var canSeeTop = true
    let hobCentreX = UIScreen.main.bounds.width * 0.5
    let hobCentreY = UIScreen.main.bounds.height * 0.5
    var panPreviousX : CGFloat = 0.0
    var panPreviousY : CGFloat = 0.0
    
    //Set Frying Pan and Pancake Variables
    var holdingPan = true
    var distToFingerX : CGFloat = 0
    var distToFingerY : CGFloat = 0
    let pancakeImgName = "Spr_PancakeSPF"
    
    //Set Gyro Variables
    var motion = CMMotionManager()
    var gyroTimer = NSObject()
    
    //Set Button Variables
    let buttonX : CGFloat = 20.0
    let buttonY : CGFloat = 20.0
    let binButtonX : CGFloat = 20.0
    let binButtonY : CGFloat = 160.0
    
    //Set Scoring Variables
    var score = 0
    var finishedPancake = true
    var highScore = 0
    
    //Set Score Text
    let scoreLabel = SKLabelNode(fontNamed: "ARCADECLASSIC")
    let scoreLabelPos = CGPoint(x: UIScreen.main.bounds.width * 0.5,
                                y: UIScreen.main.bounds.height - 70.0)
    let HSLabel = SKLabelNode(fontNamed: "ARCADEClASSIC")
    let HSLabelPos = CGPoint(x: UIScreen.main.bounds.width * 0.5,
                             y: UIScreen.main.bounds.height - 30.0)
    
    //Set Audio Variables
    var music : AVAudioPlayer?
    var SFX: AVAudioPlayer?
    let musicURL = URL(fileURLWithPath: Bundle.main.path(forResource: "SPFTheme.wav", ofType: nil)!)
    let buttonURL = URL(fileURLWithPath: Bundle.main.path(forResource: "ButtonSFX.wav", ofType: nil)!)
    let BinURL = URL(fileURLWithPath: Bundle.main.path(forResource: "BinSFX.wav", ofType: nil)!)
    let FinishURL = URL(fileURLWithPath: Bundle.main.path(forResource: "FinishedSFX.wav", ofType: nil)!)
    
    //Set background variables
    let BGColour = UIColor.orange
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = BGColour
        
        //Setup Score Text
        scoreLabel.text = "Score - \(score)"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = scoreLabelPos
        scoreLabel.zPosition = 4
        HSLabel.text = "Highscore - \(highScore)"
        HSLabel.fontColor = SKColor.white
        HSLabel.position = HSLabelPos
        HSLabel.zPosition = 4
        
        //Setup frying pan
        fryingPan.anchorPoint = CGPoint(x: 0.5, y: 0.715)
        fryingPan.position.x = hobCentreX
        fryingPan.position.y = hobCentreY
        fryingPan.zPosition = 1
        fryingPan.zRotation = .pi / 2
        panPreviousX = hobCentreX
        panPreviousY = hobCentreY

        //Setup pancake
        currentPancake.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        currentPancake.position.x = fryingPan.position.x
        currentPancake.position.y = fryingPan.position.y
        currentPancake.zPosition = 2
        currentPancake.isHidden = true
        
        //Setup Hob
        hob.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        hob.position.x = hobCentreX
        hob.position.y = hobCentreY
        hob.zPosition = 0
        
        //Setup Buttons
        finishButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        finishButton.position.x = buttonX
        finishButton.position.y = buttonY
        finishButton.zPosition = 3
        binButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        binButton.position.x = binButtonX
        binButton.position.y = binButtonY
        binButton.zPosition = 3
        
        //Add Children
        addChild(currentPancake)
        addChild(fryingPan)
        addChild(hob)
        addChild(finishButton)
        addChild(binButton)
        addChild(scoreLabel)
        addChild(HSLabel)
        
        //Start gyro
        startGyros()
        
        //Play music
        do {
            music = try AVAudioPlayer(contentsOf: musicURL)
            music?.play()
            music?.numberOfLoops = -1
        } catch {
            //Error
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //If currently cooking pancake
        if (!finishedPancake) {
        
            //Update Pancake's position to frying pan
            if (currentPancake.position != fryingPan.position) {
                currentPancake.position = fryingPan.position
            }
        
            //Get distance to the hob
            let xDist = hobCentreX - fryingPan.position.x
            let yDist = hobCentreY - fryingPan.position.y
            let distToHob = ((xDist * xDist) + (yDist * yDist)).squareRoot()
        
            //Get speed at which the pan is moving
            let speedX = fryingPan.position.x - panPreviousX
            let speedY = fryingPan.position.y - panPreviousY
            let panSpeed = ((speedX * speedX) + (speedY * speedY)).squareRoot()
            panPreviousX = fryingPan.position.x
            panPreviousY = fryingPan.position.y
        
            //Adjust rate at which the pancake cooks
            //Closer to the hob centre, faster it cooks
            var cookingRate = (100 - distToHob) * 0.0002
            //The faster the pan is moving, the slower it cooks
            cookingRate += -(panSpeed * 0.0005)
            //If less than 0 set to 0 so it doesn't uncook itself
            if (cookingRate < 0) {
                cookingRate = 0
            }
        
            //Cook pancake
            if (canSeeTop) {
                if (cookedLevelBottom < 17) {
                    cookedLevelBottom += cookingRate
                }
            } else {
                if (cookedLevelTop < 17) {
                    cookedLevelTop += cookingRate
                }
            }
        }
    }
    
    //Handle the flipping of the pancake
    func startGyros() {
        if motion.isGyroAvailable {
            self.motion.gyroUpdateInterval = 1.0 / 10.0
            self.motion.startGyroUpdates()
        
            //Create Timer
            gyroTimer = Timer.scheduledTimer(withTimeInterval: (1.0/10.0), repeats: true) { timer in
                //Grab Gyro Data
                if let data = self.motion.gyroData {
                    let y = data.rotationRate.y
                    
                    //Check if the phone has been flicked
                    if (y >= 10.5 || y <= -10.5) {
                        
                        //If currently cooking
                        if (!self.finishedPancake) {
                        
                            //flip over pancake
                            self.canSeeTop = !self.canSeeTop
                            print("Pancake Flipped")
                            var assetName = ""
                        
                            if (self.canSeeTop) {
                                //Show how cooked the top is
                                if (self.cookedLevelTop < 17) {
                                    assetName = self.pancakeImgName + "\(self.cookedLevelTop.rounded(.down))"
                                } else {
                                    assetName = self.pancakeImgName + "16"
                                }
                            
                                self.currentPancake.texture = SKTexture(imageNamed: assetName)
                            } else {
                                //Show how cooked the bottom is
                                if (self.cookedLevelBottom < 17) {
                                    assetName = self.pancakeImgName + "\(self.cookedLevelBottom.rounded(.down))"
                                } else {
                                    assetName = self.pancakeImgName + "16"
                                }
                                
                                self.currentPancake.texture = SKTexture(imageNamed: assetName)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //Handle Player's touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Is frying pan touched
        guard let touchPos = touches.first?.location(in: self) else { return }
        let nodeTouched = nodes(at: touchPos).first
        
        if (nodeTouched == fryingPan) {
            //If player is touching handle
            if (touchPos.x >= fryingPan.position.x + 90) {
                if (touchPos.y <= fryingPan.position.y + 25 && touchPos.y >= fryingPan.position.y - 25) {
                    //Set variables for moving the pan
                    holdingPan = true
                    distToFingerX = fryingPan.position.x - touchPos.x
                    distToFingerY = fryingPan.position.y - touchPos.y
                    
                }
            }
        } else if (nodeTouched == finishButton) {
            holdingPan = false
            
            //If currently not finished
            if (!finishedPancake) {
                
                //Calculate Score
                score = 0
                //Find out how many cooking levels they are away from perfect (level 8)
                var levelsFromPerfTop = 8 - cookedLevelTop.rounded(.down)
                if (levelsFromPerfTop < 0) {
                    levelsFromPerfTop = levelsFromPerfTop * -1
                }
                var levelsFromPerfBottom = 8 - cookedLevelBottom.rounded(.down)
                if (levelsFromPerfBottom < 0) {
                    levelsFromPerfBottom = levelsFromPerfBottom * -1
                }
                //Reduce from max score based on how far pancake is away from perfect
                score = 800 - (50 * Int(levelsFromPerfTop)) - (50 * Int(levelsFromPerfBottom))
                
                //Adjust high score if need be
                if (score > highScore) {
                    highScore = score
                }
                
                //Hide pancake
                currentPancake.isHidden = true
                
                //Pancake is finished
                finishedPancake = true
                finishButton.texture = SKTexture(imageNamed: "Spr_New")
                scoreLabel.text = "Score - \(score)"
                HSLabel.text = "Highscore - \(highScore)"
                
                //Print in console
                print("Top: \(self.cookedLevelTop)")
                print("Bottom: \(self.cookedLevelBottom)")
                print("Score: \(score)")
                print("Highscore: \(highScore)")
                
                //Play SFX
                do {
                    SFX = try AVAudioPlayer(contentsOf: FinishURL)
                    SFX?.play()
                    SFX?.numberOfLoops = 0
                } catch {
                    //Error
                }
                
            } else { //Start new pancake
                
                //Reset variables
                cookedLevelTop = 0
                cookedLevelBottom = 0
                canSeeTop = true
                self.currentPancake.texture = SKTexture(imageNamed: "Spr_PancakeSPF0")
                currentPancake.isHidden = false
                
                //New Pancake started
                finishedPancake = false
                finishButton.texture = SKTexture(imageNamed: "Spr_Finish")
                
                //Play SFX
                do {
                    SFX = try AVAudioPlayer(contentsOf: buttonURL)
                    SFX?.play()
                    SFX?.numberOfLoops = 0
                } catch {
                    //Error
                }
                
            }
        } else if (nodeTouched == binButton) {
            holdingPan = false
            
            //Hide pancake
            currentPancake.isHidden = true
            
            //Pancake is binned
            finishedPancake = true
            finishButton.texture = SKTexture(imageNamed: "Spr_New")
            
            //Play SFX
            do {
                SFX = try AVAudioPlayer(contentsOf: BinURL)
                SFX?.play()
                SFX?.numberOfLoops = 0
            } catch {
                //Error
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //If pan is being held, move it based on where the finger is
        if (holdingPan) {
            
            guard let touchPos = touches.first?.location(in: self) else { return }
            
            let newPos = CGPoint(x: touchPos.x + distToFingerX, y: touchPos.y + distToFingerY)
            fryingPan.position = newPos
            
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(holdingPan) {
            holdingPan = false
        }
        
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
