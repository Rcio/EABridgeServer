//
//  P2PController.swift
//  EABridgeServer
//
//  Created by rcio on 10/12/15.
//  Copyright (c) 2015 rcio. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol P2PControllerDelegate: NSObjectProtocol {
    func p2pDidReceiveData(data: NSData!)
}

class P2PController: NSObject, MCBrowserViewControllerDelegate, MCSessionDelegate {
    static let instance = P2PController()
    
    
    let peerPicker: MCBrowserViewController
    weak var delegate: P2PControllerDelegate!

    var connected = false

    override init() {
        let peerID = MCPeerID(displayName: "EAServer2")
        let session = MCSession(peer: peerID)
        peerPicker = MCBrowserViewController(serviceType: "EABridge", session: session)

        super.init()
        
        peerPicker.delegate = self
        peerPicker.maximumNumberOfPeers = 1
        peerPicker.minimumNumberOfPeers = 1
        
        peerPicker.delegate = self;
    }
    
    func sendData(data: NSData!) {
        peerPicker.session.sendData(data, toPeers: peerPicker.session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: nil)
    }
    
    
    func browserViewController(browserViewController: MCBrowserViewController!, shouldPresentNearbyPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) -> Bool {
        return true
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
        peerPicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        delegate.p2pDidReceiveData(data)
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        switch (state) {
        case .Connected:
            print("Peer connected\n")
            connected = true
        case .NotConnected:
            print("Peer disconnected")
            connected = false
        case .Connecting:
            print("Peer connecting\n")
        }
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
    }
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
    }
}
