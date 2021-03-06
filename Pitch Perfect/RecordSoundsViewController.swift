//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kamlesh Bokdia on 22/01/15.
//  Copyright (c) 2015 Kamlesh Bokdia. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var statusLable: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.hidden = true
        statusLable.text = "Tap to record"
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as! String
        
        let currentTime = NSDate()
        let formatter = NSDateFormatter()
        
        // Creating file Name in Date format
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentTime) + ".wav"
        let pathArray = [dirPath,recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //Creating and Assigning audioRecorder object delegate to self
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        
        //Recording
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        statusLable.text = "recording"
        statusLable.hidden = false
        stopButton.hidden = false
        
    }
    
    //On record completion delegate method invoked
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag{
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent, filePathURL: recorder.url)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            println("Recording was not saved successfully")
            stopButton.hidden = true
            recordButton.enabled = true
        }
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording"{
            var playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }

    @IBAction func stopRec(sender: UIButton) {
        audioRecorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
        statusLable.hidden = true
    }
    
}

