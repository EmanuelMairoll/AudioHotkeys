//
//  Mode.swift
//  AudioHotkeys
//
//  Created by Emanuel Mairoll on 07/05/2017.
//  Copyright © 2017 Emanuel Mairoll. All rights reserved.
//

import Foundation
import HotKey

class Mode{
    static let STEREO = Mode(displayName:"Stereo", monoState:false, lrBalance:LR_BALANCE_CENTERVALUE, iconName: "icon_stereo", key:.upArrow)
    static let MONO = Mode(displayName:"Mono", monoState:true, lrBalance:LR_BALANCE_CENTERVALUE, iconName: "icon_mono", key:.downArrow)
    static let LEFT = Mode(displayName:"Left", monoState:true, lrBalance:LR_BALANCE_MINVALUE, iconName: "icon_left", key:.leftArrow)
    static let RIGHT = Mode(displayName:"Right", monoState:true, lrBalance:LR_BALANCE_MAXVALUE, iconName: "icon_right", key:.rightArrow)
    static let UNKNOWN = Mode(displayName:"Unknown", monoState:nil, lrBalance:nil, iconName: "icon_unknown", key: nil)
    
    static let knownModes = [STEREO, MONO, LEFT, RIGHT] as [Mode]
    
    init(displayName:String, monoState:Bool?, lrBalance:Float?, iconName:String, key: Key?) {
        self.displayName = displayName
        self.monoState = monoState
        self.lrBalance = lrBalance
        self.icon = NSImage(named: iconName)!
        self.key = key
    }
    
    let displayName:String
    let monoState:Bool?
    let lrBalance:Float?
    let icon:NSImage
    let key: Key?
    
    static func detectCurrent() -> Mode {
        let monoState = SettingsWrapper.isMonoAudio()
        let lrBalance = SettingsWrapper.getLRBalance()
        
        if (monoState){
            if (lrBalance == LR_BALANCE_MINVALUE){
                return Mode.LEFT
            }else if (lrBalance == LR_BALANCE_CENTERVALUE){
                return Mode.MONO
            }else if (lrBalance == LR_BALANCE_MAXVALUE){
                return Mode.RIGHT
            }else{
                return Mode.UNKNOWN
            }
        }else{
            if (lrBalance == LR_BALANCE_CENTERVALUE){
                return Mode.STEREO
            }else{
                return Mode.UNKNOWN
            }
        }
    }
    
    func apply(oldMode:Mode?) {
        if let newMonoState = self.monoState{
            if newMonoState != oldMode?.monoState{
                SettingsWrapper.setMonoAudio(newMonoState)
            }
        }
        
        if let newLRBalance = self.lrBalance{
            if newLRBalance != oldMode?.lrBalance{
                SettingsWrapper.setLRBalance(newLRBalance)
            }
        }
    }
}

extension NSMenuItem{
    func mode() -> Mode{
        for mode in Mode.knownModes {
            if (mode.displayName == self.title){
                return mode
            }
        }
        return Mode.UNKNOWN
    }
}



