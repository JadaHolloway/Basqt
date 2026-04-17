//
//  AudioPlayer.swift
//  NationalParks
//
//  Created by Osman Balci on 3/24/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI
import Observation
import AVFoundation
 
fileprivate var playerOfAudio: AVAudioPlayer!
 
@Observable
class AudioPlayer: NSObject, AVAudioPlayerDelegate {
  
    // Instance Variable
    var isPlaying = false
   
    /*
     ***************************************************************************
     Observation Framework for Implementing the Publish-Subscribe Design Pattern
     ***************************************************************************
     The Observation framework must be imported.
     PUBLISH:
         All class instance variables (properties) are automatically observed (published)
         when the class is annotated with the @Observable macro. If you do not
         want an instance variable (property) to be automatically observed (published), use
    
         @ObservationIgnored var someVar = initialValue
    
     SUBSCRIBE:
         Only one object is instantiated from the @Observable class (Singleton
         Design Pattern). We refer to that object with the following in a UI file:
        
         let audioPlayer: AudioPlayer
        
         The state of the audioPlayer object is defined by the values of its instance
         variables (properties). Any instance variable (i.e., isPlaying) value change causes
         the object's state to change. When the state changes the UI is refreshed.
     */
   
    /*
     ******************************************************************
     CREATE Audio Player to play the audio contained in a file with url
     ******************************************************************
     */
    func createAudioPlayer(url: URL) {
        do {
            playerOfAudio = try AVAudioPlayer(contentsOf: url)
            playerOfAudio.prepareToPlay()
        } catch {
            print("Unable to create AVAudioPlayer from URL!")
        }
    }
 
    /*
     ************************************************************
     CREATE Audio Player to play the audio contained in audioData
     ************************************************************
     */
    func createAudioPlayer(audioData: Data) {
        do {
            playerOfAudio = try AVAudioPlayer(data: audioData)
            playerOfAudio!.prepareToPlay()
        } catch {
            print("Unable to create AVAudioPlayer from audioData!")
        }
    }
  
    /*
     ***********************
     START Playing the Audio
     ***********************
     */
    func startAudioPlayer() {
      
        let audioSession = AVAudioSession.sharedInstance()
      
        do {
            /*
             AVAudioSession.PortOverride.speaker option causes the system to route audio
             to the built-in speaker and microphone regardless of other settings.
             */
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Unable to route audio to the built-in speaker!")
        }
      
        if let player = playerOfAudio {
            /*
             Make this class to be a delegate for the AVAudioPlayerDelegate protocol so that
             we can implement the audioPlayerDidFinishPlaying protocol method below.
             */
            player.delegate = self
          
            player.play()
            isPlaying = true
        }
    }
  
    /*
     ***********************
     PAUSE Playing the Audio
     ***********************
     */
    func pauseAudioPlayer() {
        if let player = playerOfAudio {
            player.pause()
            isPlaying = false
        }
    }
  
    /*
     **********************
     STOP Playing the Audio
     **********************
     */
    func stopAudioPlayer() {
        if let player = playerOfAudio {
            player.stop()
            isPlaying = false
        }
    }
  
    /*
     *************************************
     AVAudioPlayerDelegate Protocol Method
     *************************************
     */
   
    // Set isPlaying to false when the Audio Player finishes playing.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
  
}

