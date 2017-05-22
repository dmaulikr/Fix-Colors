//
//  GameSceneNode.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit

protocol GameSceneNodeDelegate {
    func levelCompleted()
    func replay()
    func prepareLevel()
    func pauseButtonPressed()
    func endOfGame()
}

protocol AdsDelegate {
    func showAds()
}

class GameSceneNode: SKNode, GridDelegate, HUDNodeDelegate, CompletionNodeDelegate {
    var delegate: GameSceneNodeDelegate?
    var adsDelegate: AdsDelegate?
    
    let settings: Settings
    var level: Level?
    var grid: Grid?
    var gameScenePaused: Bool = false
    let hudNode: HUDNode
    let completionNode: CompletionNode
    var completionOn: Bool = false {
        didSet {
            if !completionOn {
                completionNode.alpha = 0.0
            }
        }
    }
    var adIsPresenting: Bool = false
    
    init(settings: Settings) {
        self.settings = settings
        self.completionNode = CompletionNode(settings: settings)
        self.hudNode = HUDNode(settings: settings)
        
        super.init()
        
        hudNode.position = CGPoint(x: 0.0, y: MainSize.height * 0.44)
        hudNode.zPosition = 40.0
        hudNode.delegate = self
        addChild(hudNode)
        
        completionNode.delegate = self
        completionNode.alpha = 0.0
        completionNode.position = CGPoint(x: 0.0, y: 0.0)
        completionNode.zPosition = 60.0
        addChild(completionNode)
    }
    
    func setup() {
        makeGrid()
    }
    
    internal func updateMovesLabel() {
        hudNode.updateLabelTexts()
    }
    
    internal func completionLevel() {
        addCompletionScene()
    }
    
    internal func disableHUD() {
        hudNode.isUserInteractionEnabled = false
    }
    
    internal func enableHUD() {
        hudNode.isUserInteractionEnabled = true
    }
    
    internal func pauseNodeTouched() {
        self.gameScenePaused = true
        self.delegate?.pauseButtonPressed()
    }
    
    internal func replayButtonTouched() {
        if settings.sound && !completionOn {
            GameAudio.shared.playGridSwishSound()
        }
        if completionOn {
            completionNode.animate(scaleFactor: 0.0, alpha: 0.0, completion: {
                
            })
        }
        self.grid!.run(Actions.removeGridAction(), completion: {
            self.completionOn = false
            self.delegate?.replay()
            self.hudNode.updateLabelTexts()
            self.hudNode.isUserInteractionEnabled = true
            self.isUserInteractionEnabled = true
        })
    }
    
    internal func touchesEnabled() {
        isUserInteractionEnabled = false
    }
    
    internal func continueButtonTouched() {
        completionOn = false
        continueGame()
    }
    
    private func makeGrid() {
        if grid != nil { return }
        hudNode.updateLabelTexts()
        let width = level!.getWidth()
        let (columns, rows) = level!.getColumnsAndRows()
        grid = Grid(settings: settings, level: level!, columns: columns, rows: rows, width: width)
        grid!.delegate = self
        
        let y = (MainSize.height / 2.0 - MainSize.height * 0.38) / 2.0
        grid!.position = CGPoint(x: 0.0, y: -y)
        grid!.addSpritesToScene()
        addChild(grid!)
    }
    
    private func addCompletionScene() {
        if settings.sound {
            GameAudio.shared.playCompletionSound()
        }
        completionNode.alpha = 1.0
        showAd(level: settings.level)
        completionNode.animate(scaleFactor: 1.0, alpha: 1.0) {
            self.completionOn = true
            self.hudNode.isUserInteractionEnabled = true
        }
    }
    
    private func showAd(level: Int) {
        if level == 1 || level % 4 == 0 {
            adsDelegate?.showAds()
        }
    }
    
    private func continueGame() {
        settings.nextLevel()
        let action = Actions.fadeOutAction(duration: 0.2)
        completionNode.run(action, completion: {
            if self.settings.level == MaxLevel {
                self.delegate?.endOfGame()
            } else {
                self.delegate?.prepareLevel()
                self.delegate?.levelCompleted()
                self.hudNode.updateLabelTexts()
                self.hudNode.isUserInteractionEnabled = true
            }
        })
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if hasActions() { return }
        guard let g = grid else { return }
        if g.hasActions() { return }
        g.touchesEnded(touches, with: event)
        if !hudNode.isUserInteractionEnabled { return }
        hudNode.touchesEnded(touches, with: event)
        if completionOn {
            completionNode.touchesEnded(touches, with: event)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
