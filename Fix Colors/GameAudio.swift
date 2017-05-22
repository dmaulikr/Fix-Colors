//
//  GameAudio.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import AVFoundation

class GameAudio {
    static let shared = GameAudio()
    private var buttonClickSound = AVAudioPlayer()
    private var completionSound = AVAudioPlayer()
    private var swishSound = AVAudioPlayer()
    private var gridSwishSound = AVAudioPlayer()
    private let Volume: Float = 0.8
    private let soundQueue = OperationQueue()
    
    func setupSounds() {
        if let path = Bundle.main.path(forResource: SoundNames.ButtonClickSoundName, ofType: "mp3") {
            let url = URL(fileURLWithPath: path )
            do {
                buttonClickSound = try AVAudioPlayer(contentsOf: url)
            } catch {
                print(error)
            }
        }
        if let path = Bundle.main.path(forResource: SoundNames.CompletionSoundName, ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                completionSound = try AVAudioPlayer(contentsOf: url)
            } catch {
                print(error)
            }
        }
        if let path = Bundle.main.path(forResource: SoundNames.SwishSoundName, ofType: "mp3") {
            let url = URL(fileURLWithPath: path )
            do {
                swishSound = try AVAudioPlayer(contentsOf: url)
            } catch {
                print(error)
            }
        }
        if let path = Bundle.main.path(forResource: SoundNames.GridSwishSoundName, ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                gridSwishSound = try AVAudioPlayer(contentsOf: url)
            } catch {
                print(error)
            }
        }
        buttonClickSound.volume = Volume
        completionSound.volume = Volume
        swishSound.volume = Volume
        gridSwishSound.volume = Volume
        soundQueue.qualityOfService = .background
    }
    
    func playButtonClickSound() {
        soundQueue.addOperation {
            self.buttonClickSound.play()
        }
    }
    
    func playCompletionSound() {
        soundQueue.addOperation {
            self.completionSound.play()
        }
    }
    
    func playSwishSound() {
        soundQueue.addOperation {
            self.swishSound.play()
        }
    }
    
    func playGridSwishSound() {
        soundQueue.addOperation {
            self.gridSwishSound.play()
        }
    }
}
