//
//  ViewController.swift
//  LaZer
//
//  Created by Timothy Naughton on 9/2/16.
//  Copyright © 2016 Timothy Naughton. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class ViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
//    var kranz = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Din Daa Daa ; George Kranz", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    var backgroundSound = AVAudioPlayer()
    var tags = 0
    var redTeamScore = 0
    var blueTeamScore = 0
    
    
    @IBOutlet weak var blueTeamLabel: UILabel!
    
    func redTeamInfo() {
          Alamofire.request(.GET, "http://localhost:3000/teams/1.json").responseJSON{(response) -> Void in
            
            if let redTeam = response.result.value {
                self.redTeamScore = (redTeam["score"] as! Int)
                var redTeamName = (redTeam["name"] as! String)
                print(redTeam["name"] as! String)
                print(redTeam["score"] as! Int)
                print(redTeam)
                
            }
        }
    }


    func blueTeamInfo() {
        
            Alamofire.request(.GET, "http://localhost:3000/teams/2.json").responseJSON{(response) -> Void in
            
            if let blueTeam = response.result.value {
                self.blueTeamScore = (blueTeam["score"] as! Int)
                var blueTeamName = (blueTeam["name"] as! String)
                print(blueTeam["name"] as! String)
                print(blueTeam["score"] as! Int)
                print(blueTeam)
                
            }
        }

    }
    
    
    
    
    
    override func viewDidLoad(){
        
   
        super.viewDidLoad()
       // let path = NSBundle.mainBundle().pathForResource("LazerNoise", ofType: "mp3")
// commenting out to save MP3s on project       let backgroundPath = NSBundle.mainBundle().pathForResource("kranz", ofType: "mp3")
//        let soundURL = NSURL(fileURLWithPath: path!)
//        let backgroundSoundURL = NSURL(fileURLWithPath: backgroundPath!)
//        
//        
//        do{
//            try audioPlayer = AVAudioPlayer(contentsOfURL: soundURL)
//            try backgroundSound = AVAudioPlayer(contentsOfURL: backgroundSoundURL)
//            audioPlayer.prepareToPlay()
//            backgroundSound.prepareToPlay()
//            backgroundSound.play()
//        }
//        catch let err as NSError
//        {
//            print(err.debugDescription)
//        }
//        
//    
//    
//        
//    }
//    func playNstop(){
//        
//        if audioPlayer.playing{
//            
//            
//            audioPlayer.play()
//        }else{
//            
//            audioPlayer.play()
//        }
//     
        redTeamInfo()
        blueTeamInfo()

        
        
   }


    @IBOutlet weak var TagsFired: UILabel!

    @IBOutlet weak var CameraView: UIView!
    
    override func viewWillAppear(animated: Bool) {
        
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for device in devices {
            if device.position == AVCaptureDevicePosition.Back {
                
                do {
                    let input = try AVCaptureDeviceInput(device: device as! AVCaptureDevice)
                    if captureSession.canAddInput(input){
                        captureSession.addInput(input)
                        sessionOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                        
                        if captureSession.canAddOutput(sessionOutput){
                            captureSession.addOutput(sessionOutput)
                            captureSession.startRunning()
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeRight
                            CameraView.layer.addSublayer(previewLayer)
                            
                            previewLayer.position = CGPoint(x: self.CameraView.frame.width / 2, y: self.CameraView.frame.height / 2)
                            previewLayer.bounds = CameraView.frame
                            
                        }
                    }
                    
                }
                catch{
                    print("ERror")
                }
            }
        }
    }
    
   
    @IBAction func TakePhoto(sender: UIButton) {
        tags = tags + 1
        TagsFired.text = "Red Team Score: \(redTeamScore)"
        blueTeamLabel.text = "Blue Team Score: \(blueTeamScore)"
        redTeamInfo()
//       playNstop()
        Alamofire.request(.GET, "http://localhost:3000/teams/1/tag")
        if let videoConnection = sessionOutput.connectionWithMediaType(AVMediaTypeVideo){
            
            sessionOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                buffer, error in
                
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
                
                })
        }
    }


}

