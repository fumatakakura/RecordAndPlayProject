//
//  ViewController.swift
//  RecordandPlayProject
//
//  Created by 高倉楓麻 on 2019/11/22.
//  Copyright © 2019 高倉楓麻. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    var recordingSession : AVAudioSession!
    
    var fileName : String = "audioFile.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecorder()
        playButton.isEnabled = false
        
    }
    
    func getDocumentsDirector() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func setupRecorder() {
        print("レコーダー呼び出し")
        let audioFilename = getDocumentsDirector().appendingPathComponent(fileName)
        let recordSetting = [ AVFormatIDKey : kAudioFormatAppleLossless ,
                              AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                              AVEncoderBitRateKey : 320000,
                              AVNumberOfChannelsKey : 2,
                              AVSampleRateKey : 44100.2 ] as [String : Any]
        do {
            soundRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
            print("レコーダー呼び出し完了")
        } catch {
            print(error)
        }
    }
    
    func setupPlayer() {
        print("プレーヤー呼び出し")
        let audioFilename = getDocumentsDirector().appendingPathComponent(fileName)
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
            print(error)
        }

    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playButton.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        playButton.setTitle("Play", for: .normal)
    }
    
    
    
    @IBAction func recordAct(_ sender: Any) {
        if recordButton.titleLabel?.text == "Record" {
            soundRecorder.record()
            recordButton.setTitle("Stop", for: .normal)
            playButton.isEnabled = false
            print("レコード中")
        } else {
            soundRecorder.stop()
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = false
            print("レコード完了")
        }
        
    }
    
    @IBAction func playAct(_ sender: Any) {
        if recordButton.titleLabel?.text == "Play" {
                   playButton.setTitle("Stop", for: .normal)
                   recordButton.isEnabled = false
                   //プレーヤー呼び出しできてない
                   setupPlayer()
                   soundPlayer.play()
               } else {
                   soundPlayer.stop()
                   playButton.setTitle("Play", for: .normal)
                   recordButton.isEnabled = false
               }
    }
    

}

