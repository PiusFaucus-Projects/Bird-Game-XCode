//
//  endViewController.swift
//  16053213
//
//  Created by ri17aab on 11/01/2020.
//  Copyright © 2020 ri17aab. All rights reserved.
//

import UIKit


class endViewController: UIViewController
{
    
    @IBOutlet weak var replayButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //runs the giff
        
        var ReplayArray: [UIImage]
        
        ReplayArray = [UIImage(named: "Replay1.png")!,
                       UIImage(named: "Replay2.png")!,
                       UIImage(named: "Replay3.png")!,
                       UIImage(named: "Replay4.png")!,
                       UIImage(named: "Replay5.png")!,
                       UIImage(named: "Replay6.png")!,]
        replayButton.image = UIImage.animatedImage(with: ReplayArray, duration: 1)
        
        
}




}
