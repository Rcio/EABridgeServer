//
//  ViewController.swift
//  EABridgeServer
//
//  Created by rcio on 15/10/12.
//  Copyright (c) 2015年 rcio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if P2PController.instance.connected == false {
            self.presentViewController(P2PController.instance.peerPicker, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

