//
//  ViewController.swift
//  TabletPLUS
//
//  Created by dhaval shah on 21/05/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var txtUsrName: UITextField!
    
    @IBOutlet var txtPassword: UITextField!
    
    @IBOutlet var btnLogin: UIButton!
    
    @IBOutlet var lblErrorMsg: UILabel!
    
    @IBOutlet var loginActivityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func btnLoginAction(sender: AnyObject) {
        
        self.loginActivityIndicator.hidden = false
        self.loginActivityIndicator.startAnimating()
        
        if txtUsrName.text=="" || txtUsrName.text==nil
        {
            self.lblErrorMsg.text="Please enter User name / Email"
            self.lblErrorMsg.hidden=false
            self.loginActivityIndicator.stopAnimating()
            self.loginActivityIndicator.hidden = true
            
        }
        else if txtPassword.text=="" || txtPassword.text==nil
        {
            self.lblErrorMsg.text="Please enter password"
            self.lblErrorMsg.hidden=false
            self.loginActivityIndicator.stopAnimating()
            self.loginActivityIndicator.hidden = true
            
        }else{
            self.lblErrorMsg.text=""
            self.lblErrorMsg.hidden=true
            
            self.loginActivityIndicator.stopAnimating()
            self.loginActivityIndicator.hidden = true
            
            dispatch_async(dispatch_get_main_queue()) {
                let propertyListing = self.storyboard?.instantiateViewControllerWithIdentifier("PropertyListing") as! PropertyListingController
                self.showViewController(propertyListing as UIViewController, sender: propertyListing )
            }
            
        }
    }
    
   /* override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
      
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: "launch-landscape.png")!)
                
        }
        else if (UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.PortraitUpsideDown) {
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: "launch-portrait-2x.png")!)
                
        }
        

       
    }*/
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        
        // Do any additional setup after loading the view, typically from a nib.
        loginActivityIndicator.stopAnimating()
        loginActivityIndicator.hidden = true
        
        //Padding
        let unamePaddingView = UIView(frame: CGRectMake(0, 0, 10, self.txtUsrName.frame.height))
        txtUsrName.leftView = unamePaddingView
        txtUsrName.leftViewMode = UITextFieldViewMode.Always
        
        let pwdPaddingView = UIView(frame: CGRectMake(0, 0, 10, self.txtPassword.frame.height))
        txtPassword.leftView = pwdPaddingView
        txtPassword.leftViewMode = UITextFieldViewMode.Always
        
        //Border
        var border = CALayer()
        var width = CGFloat(0.5)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: txtUsrName.frame.size.height - width, width:  txtUsrName.frame.size.width, height: txtUsrName.frame.size.height)
        
        border.borderWidth = width
        txtUsrName.layer.addSublayer(border)
        txtUsrName.layer.masksToBounds = true
        
        self.lblErrorMsg.hidden = true;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
    }
}

