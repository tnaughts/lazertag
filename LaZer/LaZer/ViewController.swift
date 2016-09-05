//
//  ViewController.swift
//  LaZer
//
//  Created by Timothy Naughton on 9/2/16.
//  Copyright © 2016 Timothy Naughton. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
//    var kranz = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Din Daa Daa ; George Kranz", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    var backgroundSound = AVAudioPlayer()
    var tags = 0
    
    
    
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
        TagsFired.text = "Tags Fired \(tags)"
       playNstop()
        if let videoConnection = sessionOutput.connectionWithMediaType(AVMediaTypeVideo){
            
            sessionOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                buffer, error in
                
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
                
                })
        }
    }


}

