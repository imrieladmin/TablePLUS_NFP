//
//  SideMenuController.swift
//  TabletPLUS
//
//  Created by Ruchi Salvi on 04/06/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import UIKit

@objc
protocol SidePanelViewControllerDelegate {
    func SidePanelViewControllerDelegate(flag: String)
}

class SideMenuContoller: UIViewController {
    var delegate: SidePanelViewControllerDelegate?
    
    override func viewDidLoad() {
        println("view side panel controller")
        super.viewDidLoad()
        
       
    }
}

