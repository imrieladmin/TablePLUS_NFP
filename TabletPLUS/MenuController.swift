//
//  MenuController.swift
//  TabletPLUS
//
//  Created by Ruchi Salvi on 09/06/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import Foundation

import UIKit

class MenuController: UITableViewController {
    
    
    @IBOutlet var logoImageView: UIView!
    @IBOutlet var menuTableView: UITableView!
    var sideMenuItems:[MenuItem] = [MenuItem]()
    var email="dhaval@imriel.net"
     var window: UIWindow?
    var utility = Utility()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.tintColor = utility.uicolorFromHex(0x70B420)
        self.navigationController?.navigationBar.barTintColor = utility.uicolorFromHex(0x70B420)
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        
        self.menuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        utility.addBorderToView(logoImageView ,color: utility.uicolorFromHex(0x4F4E4E), border: "bottom")
        self.menuTableView.rowHeight = 60.0
        sideMenuItems = MenuItem.sideMenuArr()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didSelectRowAtIndexPath...")
//        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
//       selectedCell.contentView.backgroundColor = utility.uicolorFromHex(0x3A3A3A)
//        selectedCell.tintColor = UIColor.blackColor()
        
        var selectedCell = tableView.cellForRowAtIndexPath(indexPath)
//        
//        let selectionColor = UIView() as UIView
//        selectionColor.layer.borderWidth = 1
//        selectionColor.layer.borderColor = utility.uicolorFromHex(0x3A3A3A).CGColor
//        selectionColor.backgroundColor = utility.uicolorFromHex(0x3A3A3A)
//        selectedCell!.contentView.backgroundColor = utility.uicolorFromHex(0x3A3A3A)
//        selectedCell!.selectedBackgroundView = selectionColor
        
//        var i:Int = 0
//        
//        let list = self.menuTableView.indexPathsForVisibleRows() as! [NSIndexPath]
//         while i < self.sideMenuItems.count {
//            if i==indexPath.row{
//                println("sele i >> \(i)")
//                selectedCell!.contentView.backgroundColor = utility.uicolorFromHex(0x3A3A3A)
//            }
//            else{
//                
//               self.menuTableView.cellForRowAtIndexPath(list[i])!.contentView.backgroundColor = utility.uicolorFromHex(0x292929)
//            }
//            i = i+1
//        }
        
        
        if(indexPath.row==0){
            
            self.performSegueWithIdentifier("PropertyListingSegue", sender: nil)
            
        }
        else if(indexPath.row==1){
            let email = "mailto://\(self.email.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)"
            if let url: NSURL? = NSURL(string: email)
            {
                
                UIApplication.sharedApplication().openURL(url!)
            }
        }
        else if(indexPath.row==2){
            dispatch_async(dispatch_get_main_queue()) {
                let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("RevealController") as! SWRevealViewController
                self.showViewController(viewController as UIViewController, sender: viewController )
            }
        }
        else if(indexPath.row==3){
            
        }
        else if(indexPath.row==4)
        {
             println("id >>...\(self.parentViewController?.restorationIdentifier)")
             println("id >>...\(self.view?.restorationIdentifier)")
            self.performSegueWithIdentifier("ActivityLogSegue", sender: nil)            
        }
        else if(indexPath.row==5){
            let email = "mailto://\(self.email.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)"
            if let url: NSURL? = NSURL(string: email)
            {
                
                UIApplication.sharedApplication().openURL(url!)
            }

        }
        
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
     var selectedCell = tableView.cellForRowAtIndexPath(indexPath)
         selectedCell!.contentView.backgroundColor = utility.uicolorFromHex(0x3A3A3A)
    }
    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
     var selectedCell = tableView.cellForRowAtIndexPath(indexPath)
         selectedCell!.contentView.backgroundColor = utility.uicolorFromHex(0x292929)
    }

//    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
//        var selectedCell = tableView.cellForRowAtIndexPath(indexPath)
//        
//        let selectionColor = UIView() as UIView
//        selectionColor.layer.borderWidth = 1
//        selectionColor.layer.borderColor = utility.uicolorFromHex(0x292929).CGColor
//        selectionColor.backgroundColor = utility.uicolorFromHex(0x292929)
//        selectedCell!.contentView.backgroundColor = utility.uicolorFromHex(0x292929)
//        selectedCell!.selectedBackgroundView = selectionColor
//    }
    // if tableView is set in attribute inspector with selection to multiple Selection it should work.
    
    // Just set it back in deselect
    override func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        
        return  self.sideMenuItems.count
    }
    
//    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        println("didDeselectRowAtIndexPath...")
//        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
//       
//        cellToDeSelect.contentView.backgroundColor = utility.uicolorFromHex(0x292929)
//        
//        
//    }
//   
    
    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
       
        
        let sideMenuItem=sideMenuItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
 
        var border = CALayer()
        
        var width = CGFloat(0.5)
        border.borderColor = utility.uicolorFromHex(0x3A3A3A).CGColor
        border.frame = CGRect(x: 0, y: cell.frame.size.height - width, width:  cell.frame.size.width, height: cell.frame.size.height)
        
        border.borderWidth = width
        cell.layer.addSublayer(border)
        cell.layer.masksToBounds = true
        
        
        println(sideMenuItem.title)
        println(sideMenuItem.image)
        
        cell.setMenuCell(sideMenuItem.title as String ,menuIconImage: sideMenuItem.image!)
       
        //cell.frame.height = 60
      //  let txtPadding = UIView(frame: CGRectMake(0, 0, cell.frame.width,60))
      
        //  cell.frame =  CGRectMake(0, 0, cell.frame.width,1100)
        
        return cell
    }
    
   
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//        
//        if segue.identifier == "PropertyListingSegue" {
//          println("property listing")
//            
//            
//        }
//        else if segue.identifier == "ViewController" {
//            println("view controler")
//        }
//    }
    
    
//    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
//        println("indexPath.row >>")
//        let menuCell1: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("menuCell") as! MenuCell
//        menuCell1.layer.borderWidth = 2
//        return menuCell1
//    }
    
   // override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! UITableViewCell
//    
//        var border = CALayer()
//        var width = CGFloat(0.5)
//        border.borderColor = UIColor.lightGrayColor().CGColor
//        border.frame = CGRect(x: 0, y: cell.frame.size.height - width, width:  cell.frame.size.width, height: cell.frame.size.height)
//        
//        border.borderWidth = width
//        cell.layer.addSublayer(border)
//        cell.layer.masksToBounds = true
//        
//        
//        // Configure the cell...
//        if indexPath.row == 0 {
//            println("row 0 pressed ")
//            
//        } else if indexPath.row == 1 {
//            println("row 1 pressed ")
//            
//        } else if indexPath.row == 2 {
//            println("row 2 pressed ")
//            
//            
//        } else if indexPath.row == 3 {
//            println("row 3 pressed ")
//            
//        } else {
//            println("row 4 pressed ")
//        }
//        
       // return cell
   // }
    
    
  
    
   
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if(indexPath.row==0){
//        }
//    let cell = tableView.dequeueReusableCellWithIdentifier("menuCell1", forIndexPath: indexPath) as! UITableViewCell
//    
//    // Configure the cell...
//    
//    return cell
//    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        println("segue \(segue.identifier)")
                
    }
  
    }



