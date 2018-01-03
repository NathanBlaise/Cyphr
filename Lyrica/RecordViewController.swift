//
//  RecordViewController.swift
//  Lyrica
//
//  Created by Nathan Lewis on 7/13/17.
//  Copyright © 2017 Nathan Lewis. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var textDisplay: UITextView!
    
    var rapText = ""
    
    var mergeAudioURL = NSURL()
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:243/255, green:226/255, blue:172/255, alpha:1.0)]
        
        let borderColor : UIColor = UIColor(red: 53/255, green: 58/255, blue: 93/255, alpha: 1.0)
        textDisplay.layer.borderWidth = 0.5
        textDisplay.layer.borderColor = borderColor.cgColor
        textDisplay.layer.cornerRadius = 5.0
        textDisplay.text = rapText
        
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        let soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        stopButton.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        

    @IBAction func startRecording(_ sender: Any) {
        stopButton.isHidden = false
        guard let instruUrl = Bundle.main.url(forResource: "appInstrumental", withExtension: "mp3") else {
            print("error")
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: instruUrl)
            guard let player = audioPlayer else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        if audioRecorder?.isRecording == false {
            stopButton.isEnabled = true
            audioRecorder?.record()
        }
    }

    @IBAction func stopRecording(_ sender: Any) {
        stopButton.isHidden = true
        stopButton.isEnabled = false
        recordButton.isEnabled = true
        guard let instruUrl = Bundle.main.url(forResource: "appInstrumental", withExtension: "mp3") else {
            print("error")
            return
        }
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
            audioPlayer?.stop()
        } else {
            audioPlayer?.stop()
        }
        let arr = [audioRecorder!.url, instruUrl] as! [URL]
        print(arr)
        concatenateFiles(audioFiles: arr)
        

    }
    
    func concatenateFiles(audioFiles: [URL]) {
        // Result file
        var nextClipStartTime = kCMTimeZero
        let composition = AVMutableComposition()
        let track = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        // Add each track
        for audio in audioFiles {
            let asset = AVURLAsset(url: NSURL(fileURLWithPath: audio.path) as URL, options: nil)
            if let assetTrack = asset.tracks(withMediaType: AVMediaTypeAudio).first {
                let timeRange = CMTimeRange(start: kCMTimeZero, duration: asset.duration)
                do {
                    try track.insertTimeRange(timeRange, of: assetTrack, at: nextClipStartTime)
                    nextClipStartTime = CMTimeAdd(nextClipStartTime, timeRange.duration)
                } catch {
                    print("Error concatenating file - \(error)")
                    return
                }
            }
        }
        
        // Export the new file
        if let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            
            let format = DateFormatter()
            format.dateFormat = "yyyy:MM:dd-HH:mm:ss"
            let currentFileName = "REC:\(format.string(from: Date()))"
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            
            let fileURL = documentsDirectory.appendingPathComponent("\(currentFileName).m4a")
            // Remove existing file
            do {
                print(audioFiles.count)
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed \(fileURL)")
            } catch {
                print("Could not remove file - \(error)")
            }
            
            // Configure export session output
            mergeAudioURL = fileURL as NSURL
            exportSession.outputURL = fileURL as URL
            exportSession.outputFileType = AVFileTypeAppleM4A
            // Perform the export
            exportSession.exportAsynchronously() { () -> Void in
                switch exportSession.status
                {
                case AVAssetExportSessionStatus.failed:
                    return print("failed to MERGE )")
                case AVAssetExportSessionStatus.cancelled:
                    return print("cancelled merge)")
                default:
                    print("complete")
                    do{
                        try self.audioPlayer = AVAudioPlayer(contentsOf:
                            self.mergeAudioURL as URL)
                        self.audioPlayer?.prepareToPlay()
                        self.audioPlayer?.play()
                    } catch let error as NSError {
                        print("audioPlayer error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
     

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
