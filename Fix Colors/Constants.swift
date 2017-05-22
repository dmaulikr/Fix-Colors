//
//  Constants.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit

let MainSize = UIScreen.main.bounds.size
let BgColor: SKColor = SKColor(red: 56.0/255.0, green: 84.0/255.0, blue: 116.0/255.0, alpha: 1.0)
let FontColor: SKColor = SKColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
let MovesColor: SKColor = SKColor(red: 93.0/255.0, green: 152.0/255.0, blue: 105.0/255.0, alpha: 1.0)
let GoldenColor: SKColor = SKColor(red: 172.0/255.0, green: 148.0/255.0, blue: 82.0/255.0, alpha: 1.0)
let MainFont: String = "Courier-Bold"
let MaxLevel: Int = 60
let Treshold: CGFloat = 10.0

struct SpriteNames {
    static let PlayButtonName: String = "PLAY_BUTTON"
    static let RateUsButtonName: String = "RATE_US_BUTTON"
    static let ShareButtonName: String = "SHARE_BUTTON"
    static let PauseButtonName: String = "PAUSE_BUTTON"
    static let LevelsButtonName: String = "LEVELS_BUTTON"
    static let BackButtonName: String = "BACK_BUTTON"
    static let ReplayButtonName: String = "REPLAY_BUTTON"
    static let TutorialButtonName: String = "TUTORIAL_BUTTON"
    static let MuteButtonName: String = "MUTE_BUTTON"
    static let UnmuteButtonName: String = "UNMUTE_BUTTON"
    static let LevelSpriteName: String = "LEVEL_SPRITE"
    static let LeftName: String = "LEFT"
    static let RightName: String = "RIGHT"
    static let DotSpriteName: String = "DOT"
    static let BlueOvalName: String = "BLUE_OVAL"
    static let RedOvalName: String = "RED_OVAL"
    static let GreenOvalName: String = "GREEN_OVAL"
    static let YellowOvalName: String = "YELLOW_OVAL"
    static let PurpleOvalName: String = "PURPLE_OVAL"
    static let OrangeOvalName: String = "ORANGE_OVAL"
    static let BlueTileName: String = "BLUE_TILE"
    static let RedTileName: String = "RED_TILE"
    static let GreenTileName: String = "GREEN_TILE"
    static let YellowTileName: String = "YELLOW_TILE"
    static let PurpleTileName: String = "PURPLE_TILE"
    static let OrangeTileName: String = "ORANGE_TILE"
}

struct Titles {
    static let GameTitle: String = "FIX COLORS"
    static let CompletedTitle: String = "COMPLETED"
    static let LevelTitle: String = "LEVELS"
    static let TutorialsTitle: String = "TUTORIAL"
    static let ComingSoonTitle: String = "COMING SOON"
}

struct Names {
    static let MuteButtonName: String = "MuteButtonName"
    static let UnmuteButtonName: String = "UnmuteButtonName"
    static let LabelShadowName: String = "LabelShadowName"
}

struct SoundNames {
    static let ButtonClickSoundName: String = "button_click_sound"
    static let CompletionSoundName: String = "completion_sound"
    static let SwishSoundName: String = "swish_sound"
    static let GridSwishSoundName: String = "grid_swish_sound"
}

struct ActionNames {
    static let BlinkOvalName = "BlinkOvalName"
    static let BackActionName = "BackActionName"
}

struct SNames {
    static let SoundSName: String = "SoundSName"
    static let CurrentLevelSName: String = "CurrentLevelSName"
    static let CompletedLevelsSName: String = "CompletedLevelsSName"
    static let AllMovesSName: String = "AllMovesSName"
}

extension SKNode {
    func returnScaleFactor() -> CGFloat {
        return self.xScale
    }
}

extension Dictionary {
    static func loadJSONfromBundle(filename: String) -> Dictionary<String, AnyObject>? {
        var dataOk: Data
        var dicOK: NSDictionary = NSDictionary()
        if let path = Bundle.main.url(forResource: filename, withExtension: "json") {
            let _: Error?
            do {
                let data = try Data(contentsOf: path, options: Data.ReadingOptions())
                dataOk = data
            }
            catch {
                print("Could not load level file: \(filename), error: \(error)")
                return nil
            }
            do {
                let dictionary = try JSONSerialization.jsonObject(with: dataOk, options: JSONSerialization.ReadingOptions()) as AnyObject!
                dicOK = (dictionary as? Dictionary<String, AnyObject>) as NSDictionary!
            }
            catch {
                print("Level file: \(filename) is not valid JSON: \(error)")
                return nil
            }
        }
        return dicOK as? Dictionary<String, AnyObject>
    }
}

extension Int {
    func getLevelName() -> String {
        return self < 10 ? "#00\(self)" : self < 100 ? "#0\(self)" : "#\(self)"
    }
}

extension SKLabelNode {
    func setShadow() {
        self.horizontalAlignmentMode = .center
        self.verticalAlignmentMode = .center
        let shadow = SKLabelNode(fontNamed: MainFont)
        shadow.text = self.text
        shadow.zPosition = self.zPosition - 1.0
        shadow.fontColor = SKColor.black
        if self.fontSize > 20.0 {
            shadow.position = CGPoint(x: 0.0, y: -2.3)
        } else {
            shadow.position = CGPoint(x: 0.0, y: -1.6)
        }
        shadow.fontSize = self.fontSize
        shadow.horizontalAlignmentMode = .center
        shadow.verticalAlignmentMode = .center
        shadow.alpha = 0.6
        shadow.name = Names.LabelShadowName
        self.addChild(shadow)
    }
    func updateShadowNode() {
        if let shadow = self.childNode(withName: Names.LabelShadowName) as? SKLabelNode {
            shadow.text = self.text
        }
    }
}
