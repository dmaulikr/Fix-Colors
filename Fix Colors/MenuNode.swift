//
//  MenuNode.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit

protocol MenuNodeDelegate {
    func playButtonTouched()
    func levelButtonTouched()
    func shareButtonTouched()
    func rateUsButtonTouched()
    func tutButtonTouched()
    func disableUserInteraction()
    func enableUserInteraction()
}

class MenuNode: SKNode {
    private let settings: Settings
    
    var delegate: MenuNodeDelegate?
    
    private let playButton = SKSpriteNode(imageNamed: SpriteNames.PlayButtonName)
    private let levelsButton = SKSpriteNode(imageNamed: SpriteNames.LevelsButtonName)
    private let rateUsButton = SKSpriteNode(imageNamed: SpriteNames.RateUsButtonName)
    private let shareButton = SKSpriteNode(imageNamed: SpriteNames.ShareButtonName)
    private let muteButton = SKSpriteNode(imageNamed: SpriteNames.MuteButtonName)
    private let unmuteButton = SKSpriteNode(imageNamed: SpriteNames.UnmuteButtonName)
    private let tutButton = SKSpriteNode(imageNamed: SpriteNames.TutorialButtonName)
    
    private let MenuNodeTreshold: CGFloat = 12.0
    
    init(settings: Settings) {
        self.settings = settings
        super.init()
        
        setupTitle()
        setupButtons()
        isUserInteractionEnabled = false
    }
    
    private func setupTitle() {
        let titleLabel = SKLabelNode(fontNamed: MainFont)
        titleLabel.text = Titles.GameTitle
        titleLabel.fontSize = 38.0
        titleLabel.fontColor = FontColor
        titleLabel.setShadow()
        titleLabel.position = CGPoint(x: 0.0, y: MainSize.height * 0.25)
        addChild(titleLabel)
    }
    
    private func setupButtons() {
        playButton.position = CGPoint(x: 0.0 - playButton.frame.size.width / 2.0 - MenuNodeTreshold / 2.0, y: 0.0)
        addChild(playButton)
        
        levelsButton.position = CGPoint(x: 0.0 + levelsButton.frame.size.width / 2.0 + MenuNodeTreshold / 2.0, y: 0.0)
        addChild(levelsButton)
        
        let y = playButton.frame.size.height / 2.0 + rateUsButton.frame.size.height / 2.0 + MenuNodeTreshold
        let x = rateUsButton.frame.size.width / 2.0 + rateUsButton.frame.size.width / 2.0 + MenuNodeTreshold
        rateUsButton.position = CGPoint(x: 0.0 - x, y: playButton.position.y - y)
        addChild(rateUsButton)
        
        muteButton.name = Names.MuteButtonName
        muteButton.alpha = settings.sound ? 1.0 : 0.0
        muteButton.position = CGPoint(x: 0.0, y: playButton.position.y - y)
        addChild(muteButton)
        
        unmuteButton.name = Names.UnmuteButtonName
        unmuteButton.alpha = settings.sound ? 0.0 : 1.0
        unmuteButton.position = CGPoint(x: 0.0, y: playButton.position.y - y)
        addChild(unmuteButton)
        
        shareButton.position = CGPoint(x: 0.0 + x, y: playButton.position.y - y)
        addChild(shareButton)
        
        tutButton.position = CGPoint(x: 0.0, y: shareButton.position.y - tutButton.frame.size.height - MenuNodeTreshold)
        addChild(tutButton)
    }
    
    private func showLevelsNode() {
        let duration = TimeInterval(0.4)
        levelsButton.run(Actions.fadeInAction(duration: duration), completion: {
            self.isUserInteractionEnabled = true
        })
    }
    
    private func hideLevelsNode() {
        let duration = TimeInterval(0.4)
        levelsButton.run(Actions.fadeOutAction(duration: duration), completion: {
            self.isUserInteractionEnabled = true
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if playButton.contains(location) {
                Actions.buttonIsTouched(playButton as SKNode, sound: settings.sound, completion: {
                    self.delegate?.playButtonTouched()
                })
            } else if levelsButton.contains(location) {
                Actions.buttonIsTouched(levelsButton as SKNode, sound: settings.sound, completion: {
                    self.delegate?.levelButtonTouched()
                })
            } else if rateUsButton.contains(location) {
                Actions.buttonIsTouched(rateUsButton as SKNode, sound: settings.sound, completion: {
                    self.delegate?.rateUsButtonTouched()
                })
            } else if shareButton.contains(location) {
                Actions.buttonIsTouched(shareButton as SKNode, sound: settings.sound, completion: {
                    self.delegate?.shareButtonTouched()
                })
            } else if tutButton.contains(location) {
                Actions.buttonIsTouched(tutButton as SKNode, sound: settings.sound, completion: {
                    self.delegate?.tutButtonTouched()
                })
            }
            
            let node = self.atPoint(location)
            if let name = node.name {
                switch name {
                case Names.MuteButtonName:
                    Actions.buttonIsTouched(muteButton as SKNode, sound: settings.sound, completion: {
                        self.unmuteButton.run(Actions.fadeInAction(duration: 0.01), completion: {
                            self.muteButton.run(Actions.fadeOutAction(duration: 0.01))
                            self.settings.sound = false
                        })
                    })
                case Names.UnmuteButtonName:
                    Actions.buttonIsTouched(unmuteButton as SKNode, sound: settings.sound, completion: {
                        self.muteButton.run(Actions.fadeInAction(duration: 0.01), completion: {
                            self.unmuteButton.run(Actions.fadeOutAction(duration: 0.01))
                            self.settings.sound = true
                        })
                    })
                default: break
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
