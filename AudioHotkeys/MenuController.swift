//
//  MenuController.swift
//  AudioHotkeys
//
//  Created by Emanuel Mairoll on 06/05/2017.
//  Copyright © 2017 Emanuel Mairoll. All rights reserved.
//

import Cocoa

class MenuController: NSObject {
    
    @IBOutlet weak var shortcutView: MASShortcutView!
    let statusItem:NSStatusItem
    let monoManager = MonoState()
    
    var currentMode:Mode?
    var currentDeviceName:String = SettingsWrapper.currentDeviceName()
    
    override init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.menu = NSMenu()
        
        super.init()
        
        initMenu()
        initShortcuts()
        initListener()
        
        changeDisplayedMode(to: Mode.detectCurrent())

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
            statusItem.menu!.addItem(item)
        }
        
        let separator = NSMenuItem.separator()
        statusItem.menu!.addItem(separator)
        
        let quitItem = NSMenuItem()
        quitItem.title = "Quit"
        quitItem.target = self
        quitItem.action = #selector(self.quitClicked)
        statusItem.menu!.addItem(quitItem)
    }
    
    func initShortcuts(){
        for mode in Mode.knownModes{
            MASShortcutMonitor.shared().register(MASShortcut(keyCode: UInt(mode.keyCode), modifierFlags: 1835008), withAction: {
                mode.apply(oldMode: self.currentMode)
                self.changeDisplayedMode(to: mode)
            })
        }
        
        //DEBUG
        /*
        MASShortcutMonitor.shared().register(MASShortcut(keyCode: UInt(kVK_ANSI_U), modifierFlags: 1835008), withAction: {
            self.changeDisplayedMode(to: Mode.detectCurrent())
        })
        */
    }
    
    func initListener(){
        SettingsWrapper.addHardwareListener(#selector(onHardwareChanged), withTarget: self)
        SettingsWrapper.addMonoListener(#selector(onMonoChanged), withTarget: self)
        SettingsWrapper.addBalanceListener(#selector(onBalanceChanged), withTarget: self)
    }
    
    @objc func onHardwareChanged(){
        let updatedName = SettingsWrapper.currentDeviceName()!;
        if currentDeviceName != updatedName {
            NSLog("onHardwareChanged (checked)")
            monoManager.setForDevice(name: currentDeviceName, isSet: SettingsWrapper.isMonoAudio())
            SettingsWrapper.setMonoAudio(monoManager.forDevice(name: updatedName))
            currentDeviceName = updatedName;

            self.changeDisplayedMode(to: Mode.detectCurrent())
        }
    }
    
    @objc func onMonoChanged(){
        NSLog("onMonoChanged")
        monoManager.setForDevice(name: currentDeviceName, isSet: SettingsWrapper.isMonoAudio())
        self.changeDisplayedMode(to: Mode.detectCurrent())
    }
    
    @objc func onBalanceChanged(){
        NSLog("onBalanceChanged")
        self.changeDisplayedMode(to: Mode.detectCurrent())
    }
    
    func changeDisplayedMode(to newMode: Mode){
        
        let icon = newMode.icon
        icon.isTemplate = true
        statusItem.image = icon
        
        for menuItem in statusItem.menu!.items {
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

