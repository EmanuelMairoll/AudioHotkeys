//
//  DefaultsManager.swift
//  AudioHotkeys
//
//  Created by Emanuel Mairoll on 05.07.18.
//  Copyright © 2018 Emanuel Mairoll. All rights reserved.
//

import Foundation

class MonoStatePersistor{
    
    let defaults = UserDefaults.standard
    var monoStates:[String : Bool]
    
    init(){
        if let stored = defaults.dictionary(forKey: "monoStates") as? [String : Bool]{
            monoStates = stored
        }else{
            monoStates = [String : Bool]()
            
            defaults.set(monoStates, forKey: "monoStates")
            defaults.synchronize()
        }
    }
    
    func forDevice(name: String) -> Bool{
        if let value = monoStates[name]{
            return value
        }else{
            setForDevice(name: name, isSet: false)
            return false
        }
    }
    
    func setForDevice(name: String, isSet: Bool ){
        monoStates[name] = isSet
        
        defaults.set(monoStates, forKey: "monoStates")
        defaults.synchronize()
    }
}

