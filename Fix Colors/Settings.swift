//
//  Settings.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import Foundation

class Settings: NSObject, NSCoding {
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("settings")
    
    var level: Int = 1 {
        didSet {
            print("level: \(level)")
            save()
        }
    }
    
    var sound: Bool = true {
        didSet {
            save()
        }
    }
    
    private var completedLevels = [1: false] {
        didSet {
            print("completedLevel: \(completedLevels)")
            save()
        }
    }
    
    var moves: Int = 0
    var amountOfMoves: Int = 0
    
    private var allMoves = [1: 0] {
        didSet {
            print("allMoves: \(allMoves)")
            save()
        }
    }
    
    override init() {
        super.init()
    }
    
    func nextLevel() {
        if level < MaxLevel {
            level += 1
        }
    }
    
    func update() {
        if completedLevels.keys.contains(level) && completedLevels[level] != true {
            completedLevels[level] = true
        }
        if (level + 1) <= MaxLevel && !(completedLevels.keys.contains(level + 1)) {
            completedLevels[level + 1] = false
        }
        if allMoves.keys.contains(level) {
            if allMoves[level]! == 0 || allMoves[level]! > moves {
                allMoves[level] = moves
            }
        }
        if (level + 1 <= MaxLevel) && !(allMoves.keys.contains(level + 1)) {
            allMoves[level + 1] = 0
        }
        moves = 0
    }
    
    func returnCompletedLevels() -> [Int: Bool] {
        return completedLevels
    }
    
    func returnBestMoves() -> Int {
        if let move = allMoves[level] {
            return move
        }
        return 0
    }
    
    func returnLastLevel() -> Int {
        return completedLevels.keys.max()!
    }
    
    required init?(coder aDecoder: NSCoder) {
        level = aDecoder.decodeInteger(forKey: SNames.CurrentLevelSName)
        sound = aDecoder.decodeBool(forKey: SNames.SoundSName)
        completedLevels = aDecoder.decodeObject(forKey: SNames.CompletedLevelsSName) as! [Int: Bool]
        allMoves = aDecoder.decodeObject(forKey: SNames.AllMovesSName) as! [Int: Int]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(level, forKey: SNames.CurrentLevelSName)
        aCoder.encode(sound, forKey: SNames.SoundSName)
        aCoder.encode(completedLevels, forKey: SNames.CompletedLevelsSName)
        aCoder.encode(allMoves, forKey: SNames.AllMovesSName)
    }
    
    func loadGame() -> Settings? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Settings.ArchiveURL.path) as? Settings
    }
    
    func save() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: Settings.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save Settings...")
        }
    }
}
