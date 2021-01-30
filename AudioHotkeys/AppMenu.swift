//
//  AppMenu.swift
//  AudioHotkeys
//
//  Created by test on 29.01.21.
//  Copyright © 2021 Emanuel Mairoll. All rights reserved.
//

import Cocoa
import HotKey

class AppMenu: NSMenu {
    let parent: NSStatusItem
    let monoStatePersistor = MonoStatePersistor()
    
    var currentMode:Mode?
    var currentDeviceName:String = SettingsWrapper.currentDeviceName()

    var hotkeys: [HotKey] = []
    
    init(parent: NSStatusItem) {
        self.parent = parent
        
        super.init(title: "")
    
        initMenu()
        initShortcuts()
        initListener()
        
        changeDisplayedMode(to: Mode.detectCurrent())
        
    }
        
    required init(coder: NSCoder) {
        let p:NSStatusItem? = nil
        self.parent = p!
        
        super.init(coder: coder)
        print("Hoden2")
    }
    
    func initMenu(){
        for mode in Mode.knownModes{
            let item = NSMenuItem()
            item.title = mode.displayName
            let image = mode.icon
            image.isTemplate = true
            item.image = image
            item.target = self
            item.action = #selector(self.modeClicked)
            self.addItem(item)
        }
        
        let separator = NSMenuItem.separator()
        self.addItem(separator)
        
        let quitItem = NSMenuItem()
        quitItem.title = "Quit"
        quitItem.target = self
        quitItem.action = #selector(self.quitClicked)
        self.addItem(quitItem)
    }
    
    func initShortcuts(){
        for mode in Mode.knownModes{
            let test = HotKey(key: .r, modifiers: [.command, .option])
            test.keyDownHandler = {
                print("test")
            }
            
            if let key = mode.key{
                let hotKey = HotKey(key: key, modifiers: [.command, .option, .control])
                hotKey.keyDownHandler = {
                    mode.apply(oldMode: self.currentMode)
                    self.changeDisplayedMode(to: mode)
                }
                
                hotkeys.append(hotKey)
            }
        }
    }
    
    func initListener(){
        SettingsWrapper.addHardwareListener(#selector(onHardwareChanged), withTarget: self)
        SettingsWrapper.addMonoListener(#selector(onMonoChanged), withTarget: self)
        SettingsWrapper.addBalanceListener(#selector(onBalanceChanged), withTarget: self)
    }
    
    @objc func onHardwareChanged(){
        if let updatedName = SettingsWrapper.currentDeviceName(), currentDeviceName != updatedName {
            NSLog("onHardwareChanged (checked)")
            monoStatePersistor.setForDevice(name: currentDeviceName, isSet: SettingsWrapper.isMonoAudio())
            SettingsWrapper.setMonoAudio(monoStatePersistor.forDevice(name: updatedName))
            currentDeviceName = updatedName;

            self.changeDisplayedMode(to: Mode.detectCurrent())
        }
    }
    
    @objc func onMonoChanged(){
        NSLog("onMonoChanged")
        monoStatePersistor.setForDevice(name: currentDeviceName, isSet: SettingsWrapper.isMonoAudio())
        self.changeDisplayedMode(to: Mode.detectCurrent())
    }
    
    @objc func onBalanceChanged(){
        NSLog("onBalanceChanged")
        self.changeDisplayedMode(to: Mode.detectCurrent())
    }
    
    func changeDisplayedMode(to newMode: Mode){
        let icon = newMode.icon
        icon.isTemplate = true
        parent.button?.image = icon
        
        for menuItem in self.items {
            menuItem.state = newMode === menuItem.mode() ? NSControl.StateValue.on : NSControl.StateValue.off
        }
        
        currentMode = newMode
    }
    
    @IBAction func modeClicked(sender: NSMenuItem){
        let newMode = sender.mode()
        newMode.apply(oldMode: self.currentMode)
        self.changeDisplayedMode(to: newMode)
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
