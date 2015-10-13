//
//  EAController.swift
//  EABridgeServer
//
//  Created by rcio on 10/13/15.
//  Copyright (c) 2015 rcio. All rights reserved.
//

import UIKit
import ExternalAccessory

class EAController: NSObject, EAAccessoryDelegate, NSStreamDelegate {
    static let instance = EAController()
    
    var device: EAAccessory?
    var inputStream: NSInputStream?
    var outputStream: NSOutputStream?
    
    //let inputBuffer: UnsafeMutablePointer<UInt8>
    //let outputBuffer: UnsafeMutablePointer<UInt8>

    override init() {
        super.init()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("accessoryDidConnected:"), name: EAAccessoryDidConnectNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func refreshAccessory() {
        let accessories = EAAccessoryManager.sharedAccessoryManager().connectedAccessories
        if accessories.count == 0 {
            return
        }
        
        for accessory in accessories as! [EAAccessory] {
            for proto in accessory.protocolStrings as! [String] {
                if proto == "protocol" {
                    device = accessory
                    device?.delegate = self

                    let session = EASession(accessory: device!, forProtocol: proto)
                    inputStream = session.inputStream
                    outputStream = session.outputStream
                    
                    inputStream?.delegate = self
                    inputStream?.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
                    inputStream?.open()
                    
                    outputStream?.delegate = self
                    outputStream?.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
                    outputStream?.open()
                    
                    break
                }
            }
        }
    }
    
    func accessoryDidConnected(sender: NSNotification!) {
        self.refreshAccessory()
    }
    
    
    func accessoryDidDisconnect(accessory: EAAccessory!) {
        if accessory.isEqual(device) {
            device = nil

            inputStream?.close()
            outputStream?.close()
            inputStream = nil
            outputStream = nil
        }
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
    }
    
}
