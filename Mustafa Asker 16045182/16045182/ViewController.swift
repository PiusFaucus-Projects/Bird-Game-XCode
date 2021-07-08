//
//  ViewController.swift
//  16053213
//
//  Created by ri17aab on 12/12/2019.
//  Copyright © 2019 ri17aab. All rights reserved.
//

import UIKit
import AVFoundation

protocol subviewDelegate {
    func GenerateBall() // call to generate ball
    func updateBallAngle(currentLocation: CGPoint) // update the ball angle
}


class ViewController: UIViewController, subviewDelegate {

    
    var player: AVAudioPlayer?
    
    var dynamicAnimator:                UIDynamicAnimator!
    var dynamicItemBehavior:            UIDynamicItemBehavior!
    var collisionBehavior:              UICollisionBehavior!
    var birdCollisionBehaviour:         UICollisionBehavior!
    var BallArray: [UIImageView]   = []
    var BirdArray: [UIImageView]    = []
    var scoreX                          = 0
    var timevalue =                       20
    let W = UIScreen.main.bounds.width
    let H = UIScreen.main.bounds.height
    
    var vectorX: CGFloat!
    var vectorY: CGFloat!
    var timer = Timer()

    
    
    @IBOutlet weak var Score: UILabel!
    private var score = 0
    
    @IBOutlet weak var Aim: DragImageView!
    
    @IBOutlet weak var timelabel: UILabel!
    
    
  
     // array for the birds puts all the birds to array
    
    let ArrayforBird = [UIImage(named: "bird1.png")!,
                        UIImage(named: "bird2.png")!,
                        UIImage(named: "bird3.png")!,
                        UIImage(named: "bird4.png")!,
                        UIImage(named: "bird5.png")!,
                        UIImage(named: "bird6.png")!,
                        UIImage(named: "bird7.png")!,
                        UIImage(named: "bird9.png")!,
                        UIImage(named: "bird10.png")!,
                        UIImage(named: "bird11.png")!,
                        UIImage(named: "bird12.png")!,
                        UIImage(named: "bird13.png")!
                          
    ]
    
    
     
    
 
    //updates the ball angle
    
    func updateBallAngle(currentLocation: CGPoint){
        vectorX = currentLocation.x
        vectorY = currentLocation.y
    }
    
    //settings for the ball
    func GenerateBall() {
        let BallImage = UIImageView(image: nil)
        BallImage.image = UIImage(named: "ball")
        BallImage.frame = CGRect(x: W*0.08, y: H*0.47, width: W*0.05, height: H*0.10)
        
        self.view.addSubview(BallImage)
    
        let angleX = vectorX - self.Aim.bounds.midX
        let angleY = vectorY - H*0.5
        
        BallArray.append(BallImage)
        dynamicItemBehavior.addItem(BallImage)
        dynamicItemBehavior.addLinearVelocity(CGPoint(x: angleX*5, y: angleY*5), for: BallImage)
        collisionBehavior.addItem(BallImage)
        
    }
    
    func collision()
    {
        // adding animator and collision Behavior
               dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
               dynamicItemBehavior = UIDynamicItemBehavior(items: BallArray)
               dynamicAnimator.addBehavior(dynamicItemBehavior)
               dynamicAnimator.addBehavior(birdCollisionBehaviour)
               collisionBehavior = UICollisionBehavior(items: [])
               collisionBehavior = UICollisionBehavior(items: BallArray)
               
        
        // setting boundary screen
               collisionBehavior.addBoundary(withIdentifier: "LEFTBOUNDARY" as NSCopying, from: CGPoint(x: self.W*0.0, y: self.H*0.0), to: CGPoint(x: self.W*0.0, y: self.H*1.0))
               collisionBehavior.addBoundary(withIdentifier: "TOPBOUNDARY" as NSCopying, from: CGPoint(x: self.W*0.0, y: self.H*0.0), to: CGPoint(x: self.W*1.0, y: self.H*0.0))
               collisionBehavior.addBoundary(withIdentifier: "BOTTOMBOUNDARY" as NSCopying, from: CGPoint(x: self.W*0.0, y: self.H*1.0), to: CGPoint(x: self.W*1.0, y: self.H*1.0))
               dynamicAnimator.addBehavior(collisionBehavior)
        
    }

    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "mainMusic", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startUp()
         
        self.Aim.center.x = self.W * 0.10
        self.Aim.center.y = self.H * 0.50
        Aim.myDelegate = self
        collision()
         
        // countdown
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.Endgame), userInfo: nil, repeats: true)
        
        
        
    
    }
    override func didReceiveMemoryWarning() {
                   super.didReceiveMemoryWarning()
    }

    
    func GenerateBirdImage(){
        let number = 6
        let birdSize = Int(self.H)/number-1
                   

        for index in 0...1000{
            let when = DispatchTime.now() + (Double(index)/2)
            DispatchQueue.main.asyncAfter(deadline: when) {
                               
                while true {
                                   
                    let randomHeight = Int(self.H)/number * Int.random(in: 0...number)
                    let birdView = UIImageView(image: nil)
                                   
                    birdView.image = self.ArrayforBird.randomElement()
                    birdView.frame = CGRect(x: self.W-CGFloat(birdSize), y:  CGFloat(randomHeight), width: CGFloat(birdSize),
                    height: CGFloat(birdSize))
                                   
                    self.view.addSubview(birdView)
                    self.view.bringSubviewToFront(birdView)
                                   
                    for anyBirdView in self.BirdArray {
                        if birdView.frame.intersects(anyBirdView.frame) {
                            birdView.removeFromSuperview()
                            continue
                        }
                    }
                                   
                    self.BirdArray.append(birdView)
                    break;
                }
            }
        }
    }

        
    func startUp(){
        
        playSound()
            
        Score.text = "Score: " + String(scoreX)
        self.GenerateBirdImage()
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
            
        Aim.frame = CGRect(x:W*0.02, y: H*0.4, width: W*0.2, height: H*0.2)
        Aim.myDelegate = self
            
        birdCollisionBehaviour = UICollisionBehavior(items: BirdArray)
            
        self.birdCollisionBehaviour.action = {
            //let remainder1 = 1
            for ballView in self.BallArray {
                for birdView in self.BirdArray {
                    let index = self.BirdArray.firstIndex(of: birdView)
                    if ballView.frame.intersects(birdView.frame)
                    
                    {
                        let before = self.view.subviews.count
                        birdView.removeFromSuperview()
                        self.BirdArray.remove(at: index!)
                        let after = self.view.subviews.count
                        
                        if(before != after)
                        {
                            self.score += 1
                            
                        }
                        
                    }
                }
            }
                
            self.Score.text = "Score: " + String(self.score)
        }
            
        dynamicAnimator.addBehavior(birdCollisionBehaviour)
    }
    
    @objc func Endgame()
     {
         timevalue -= 1
         timelabel.text = String(timevalue)
         
         if (timevalue == 0)
         {
             timer.invalidate()
             //ResetBoard()
             Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.ResetBoard), userInfo: nil, repeats: false)
            player?.stop()
         }
     }
    
@objc func ResetBoard()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "endScreen") as! endViewController
        self.present(storyboard,animated: false, completion: nil)
    }
    
}

