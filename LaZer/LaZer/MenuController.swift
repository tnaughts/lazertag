//
//  MenuController.swift
//  LaZer
//
//  Created by Timothy Naughton on 9/5/16.
//  Copyright © 2016 Timothy Naughton. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class MenuController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    //    var kranz = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Din Daa Daa ; George Kranz", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    var backgroundSound = AVAudioPlayer()
    
    
    
    override func viewDidLoad(){
        
        
        super.viewDidLoad()
        let path = NSBundle.mainBundle().pathForResource("LazerNoise", ofType: "mp3")
        let backgroundPath = NSBundle.mainBundle().pathForResource("kranz", ofType: "mp3")
        let soundURL = NSURL(fileURLWithPath: path!)
        let backgroundSoundURL = NSURL(fileURLWithPath: backgroundPath!)
        
        
        do{
            try audioPlayer = AVAudioPlayer(contentsOfURL: soundURL)
            try backgroundSound = AVAudioPlayer(contentsOfURL: backgroundSoundURL)
            audioPlayer.prepareToPlay()
            backgroundSound.prepareToPlay()
            backgroundSound.play()
        }
        catch let err as NSError
        {
            print(err.debugDescription)
        }
        
        
        
        
    }
    func playNstop(){
        
        if audioPlayer.playing{
            
            
            audioPlayer.play()
        }else{
            
            audioPlayer.play()
        }
        
    }
    
    
    
   
    
    
    
    
}
