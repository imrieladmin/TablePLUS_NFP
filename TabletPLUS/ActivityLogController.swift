//
//  ActivityLogController.swift
//  TabletPLUS
//
//  Created by Ruchi Salvi on 10/06/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import UIKit

class ActivityLogController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    var activityLogItems:[ActivityLog] = [ActivityLog]()
    var utility = Utility()
    var previousIdentifier:String = ""
    
    @IBOutlet var sendMailBtn: UIButton!
    @IBOutlet var menuBtn: UIBarButtonItem!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: true)
        
//        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: navigationController, action: "popToRoot:")
//        navigationItem.leftBarButtonItem = backButton
//        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
//        navigationController.setNavigationBarHidden(false, animated:true)
//        var myBackButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
//        myBackButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        
//        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
//        self.navigationItem.leftBarButtonItem = myCustomBackButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("previousIdentifier in activity log  >> \(previousIdentifier)")
        self.navigationController?.navigationBar.tintColor = utility.uicolorFromHex(0x70B420)
        self.navigationController?.navigationBar.barTintColor = utility.uicolorFromHex(0x70B420)
        
        
        sendMailBtn.backgroundColor = UIColor.clearColor()
        sendMailBtn.layer.cornerRadius = 5
        sendMailBtn.layer.borderWidth = 1
        sendMailBtn.layer.borderColor = UIColor.whiteColor().CGColor
//        
//        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
//        navigationItem.leftBarButtonItem = backButton
//        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        super.title = "Registro De Atividade" as String
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        if self.navigationController != nil {
            self.navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        }
        
        activityLogItems = ActivityLog.AcrivityLogArr()
        
         menuBtn.tintColor = UIColor.whiteColor()
        
        
        //Side menu Start
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rightViewRevealWidth = 270
        }
    }
    func popToRoot(sender:UIBarButtonItem){
        //self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        
        return  self.activityLogItems.count
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        
        let activityLogItem=activityLogItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityLogCell", forIndexPath: indexPath) as! ActivityLogCell
        
        
        
        if (indexPath.row%2 == 0)
        {
            cell.backgroundColor = utility.uicolorFromHex(0xFFFFFF);
        }
        else{
            cell.backgroundColor = utility.uicolorFromHex(0xF7F9F5);
        }
        
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = utility.uicolorFromHex(0xD6D4D6).CGColor;
        
                cell.setActivityCell(activityLogItem.logStr as String ,strActivityDateTime: activityLogItem.dateStr)
        
        
        
        return cell
    }
}
