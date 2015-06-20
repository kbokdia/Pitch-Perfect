//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kamlesh Bokdia on 22/01/15.
//  Copyright (c) 2015 Kamlesh Bokdia. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    var recievedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var session:AVAudioSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = AVAudioSession.sharedInstance()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathURL, error: nil)
        
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)

        // Do any additional setup after loading the view.
        if (recievedAudio != nil){
            let fileURL = recievedAudio.filePathURL
            self.audioPlayer = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
            self.audioPlayer.enableRate = true
        }
        else{
            println("FilePath empty")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAudioSlow(sender: AnyObject) {
        playAudio(0.5)
    }

    @IBAction func playAudioFast(sender: AnyObject) {
        playAudio(2.0)
    }
    
    func playAudio(rate:Float){
        self.audioPlayer.stop()
        self.audioPlayer.rate = rate
        self.audioPlayer.currentTime = 0.0
        self.audioPlayer.play()
    }
    
    @IBAction func playChipmunk(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: AnyObject){
        playAudioWithVariablePitch(-1000)
    }
    @IBAction func stopAudio(sender: AnyObject) {
        self.audioPlayer.stop()
    }
    
    func playAudioWithVariablePitch(pitch:Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        changePitchEffect.rate = 1.2
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
