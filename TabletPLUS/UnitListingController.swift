//
//  UnitListingController.swift
//  TabletPLUS
//
//  Created by Ruchi Salvi on 28/05/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

class UnitListingController : UIViewController , NSURLConnectionDataDelegate, NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate,UIPopoverPresentationControllerDelegate, UnitProtocol {
    
    
    @IBOutlet var segmentControll: UISegmentedControl!
    
    @IBOutlet var tableHeaderView: UIView!
    
    @IBOutlet var unitTableView: UITableView!
    
    @IBOutlet var lblUnitName: UILabel!
    
    @IBOutlet var lblPropritor: UILabel!
    
    @IBOutlet var lblOccupier: UILabel!
    
    @IBOutlet var lblArea: UILabel!
    
    @IBOutlet var lblStatus: UILabel!
    
    @IBOutlet var lblConstructionDate: UILabel!
    
    @IBOutlet var lblAdministration: UILabel!
    
    @IBOutlet var lblContact: UILabel!
    
    @IBOutlet var constructionDateView: UIView!
    
    @IBOutlet var administrationView: UIView!
    
    @IBOutlet var contactView: UIView!
    
    
    var parser = NSXMLParser()
    var constants = Constants()
    var utility = Utility()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var units:[Unit] = [Unit]()
    var unit = Unit()
    var property = Property()
    
    var xmlUnitName = NSMutableString()
    var xmlUnitCode = NSMutableString()
    var xmlUnitOccupierName = NSMutableString()
    var xmlUnitLandlord = NSMutableString()
    var xmlUnitArea = NSMutableString()
    var xmlUnitStatus = NSMutableString()
    
    var xmlUnitEffectiveDate = ""
    var xmlUnitExclusionDate = ""
    var xmlUnitLineOfBusinessOccupier = ""
    var xmlUnitLineOfBusinessProprietor = ""
    var xmlUnitTypeOfOccupier = ""
    var xmlUnitVacantDate = ""
    
    var sortingBtn : UIBarButtonItem = UIBarButtonItem()
    var menuBtn : UIBarButtonItem = UIBarButtonItem()
    var sortingImg   : UIImage = UIImage(named: "Sorting")!
    var menuImg : UIImage = UIImage(named: "Slider")!
    
    var tempPendingImg : UIImage = UIImage();
    var tempCompletedBtn : UIButton = UIButton();
    var tempNotCompltedBtn : UIButton = UIButton();
    var imageDict = NSMutableDictionary()
    
    @IBOutlet var btnPropertyMap: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = utility.uicolorFromHex(0x70B420)
        self.navigationController?.navigationBar.barTintColor = utility.uicolorFromHex(0x70B420)
        
        var attr = NSDictionary(object: UIFont(name: "Helvetica", size: 16.0)!, forKey: NSFontAttributeName)
        segmentControll.setTitleTextAttributes(attr as [NSObject : AnyObject], forState: .Normal)
        
        //Navigation Buttons - start
        sortingBtn = UIBarButtonItem(image: sortingImg,  style: UIBarButtonItemStyle.Done, target: self, action:            Selector("sortingPressed:"))
        
        menuBtn = UIBarButtonItem(image: menuImg,  style: UIBarButtonItemStyle.Plain, target: self, action: Selector ("menuPressed:"))
        
        sortingBtn.tintColor = UIColor.whiteColor()
        menuBtn.tintColor = UIColor.whiteColor()
        var buttons : NSArray = [menuBtn,sortingBtn]
        
        self.navigationItem.rightBarButtonItems = buttons as [AnyObject]
        self.navigationItem.setRightBarButtonItems([menuBtn,sortingBtn], animated: true)
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //Navigation Buttons - End
        
        //Border for property titles
        utility.addBorderToView(constructionDateView,  color:UIColor.greenColor(),border: "right")
        utility.addBorderToView(administrationView,  color:UIColor.greenColor(),border: "right")
        
        lblUnitName.textColor = UIColor.whiteColor()
        lblConstructionDate.text = property.dateOfConstruction as String
        lblAdministration.text = property.administration as String
        
        var contactStr : String = ""
        
        if (!isEmpty(property.contactName as String)) {
            contactStr = property.contactName as String
        }
        if (!isEmpty(property.contactNumber as String)) {
            
            if (!isEmpty(contactStr)) {
                contactStr += "," + (property.contactNumber as String)
            }
        }
        lblContact.text = contactStr
        
        var currentVC = SortingUnitPopoverController()
        currentVC.mDelegate = self
        
        //Side menu Start
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rightViewRevealWidth = 270
        }
        
        
        //Side menu End
        
        self.beginParsing()
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginParsing()
    {
        
        println("procode > \(property.proCode)")
        
        parser = NSXMLParser(contentsOfURL:(NSURL(string:"\(constants.SERVER_URL)PLUSWebService/plus/companies/getUnitsXML?propertyId=\(property.proCode)")))!
        
        parser.delegate = self
        parser.parse()
        
        unitTableView!.reloadData()
        
        
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject])
    {
        
        element = elementName
        if (elementName as NSString).isEqualToString("unit")
        {
            
            elements = NSMutableDictionary.alloc()
            elements = [:]
            unit.unitCode = NSMutableString.alloc()
            unit.unitCode = ""
            unit.unitName = NSMutableString.alloc()
            unit.unitName  = ""
            unit.unitLandlord = NSMutableString.alloc()
            unit.unitLandlord = ""
            unit.unitOccupierName = NSMutableString.alloc()
            unit.unitOccupierName  = ""
            unit.unitArea = NSMutableString.alloc()
            unit.unitArea  = ""
            unit.unitStatus = NSMutableString.alloc()
            unit.unitStatus  = ""
            
        }
    }
    func parser(parser: NSXMLParser, foundCharacters string: String?)
    {
        if element.isEqualToString("unitId") {
            unit.unitCode.appendString(string!)
        } else if element.isEqualToString("unitName") {
            unit.unitName.appendString(string!)
        }
        else if element.isEqualToString("unitLandlord") {
            unit.unitLandlord.appendString(string!)
        }
        else if element.isEqualToString("unitArea") {
            unit.unitArea.appendString(string!)
        }
        else if element.isEqualToString("unitOccupier") {
            unit.unitOccupierName.appendString(string!)
        }
        else if element.isEqualToString("unitStatus") {
            unit.unitStatus.appendString(string!)
        }
        else if element.isEqualToString("unitEffectiveDate") {
            unit.unitEffectiveDate.appendString(string!)
        }
        else if element.isEqualToString("unitExclusionDate") {
            unit.unitExclusionDate.appendString(string!)
        }
        else if element.isEqualToString("unitLineOfBusinessOccupier") {
            unit.unitLineOfBusinessOccupier.appendString(string!)
        }
        else if element.isEqualToString("unitLineOfBusinessProprietor") {
            unit.unitLineOfBusinessProprietor.appendString(string!)
        }
        else if element.isEqualToString("unitTypeOfOccupier") {
            unit.unitTypeOfOccupier.appendString(string!)
        }
        else if element.isEqualToString("unitVacantDate") {
            unit.unitVacantDate.appendString(string!)
        }
    }
    
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString("unit") {
            
            if !xmlUnitCode.isEqual(nil) {
                elements.setObject(unit.unitCode, forKey: "unitId")
                
            }
            if !xmlUnitName.isEqual(nil) {
                elements.setObject(unit.unitName, forKey: "unitName")
                
            }
            if !xmlUnitLandlord.isEqual(nil) {
                elements.setObject(unit.unitLandlord, forKey: "unitLandlord")
                
            }
            if !xmlUnitArea.isEqual(nil) {
                elements.setObject(unit.unitArea, forKey: "unitArea")
                
            }
            if !xmlUnitOccupierName.isEqual(nil) {
                elements.setObject(unit.unitOccupierName, forKey: "unitOccupier")
                
            }
            if !xmlUnitStatus.isEqual(nil) {
                elements.setObject(unit.unitStatus, forKey: "unitStatus")
                
            }
            if !xmlUnitEffectiveDate.isEqual(nil) {
                elements.setObject(unit.unitStatus, forKey: "unitEffectiveDate")
                
            }
            if !xmlUnitExclusionDate.isEqual(nil) {
                elements.setObject(unit.unitStatus, forKey: "unitExclusionDate")
                
            }
            if !xmlUnitLineOfBusinessOccupier.isEqual(nil) {
                elements.setObject(unit.unitStatus, forKey: "unitLineOfBusinessOccupier")
                
            }
            if !xmlUnitLineOfBusinessProprietor.isEqual(nil) {
                elements.setObject(unit.unitStatus, forKey: "unitLineOfBusinessProprietor")
                
            }
            if !xmlUnitTypeOfOccupier.isEqual(nil) {
                elements.setObject(unit.unitStatus, forKey: "unitTypeOfOccupier")
                
            }
            if !xmlUnitVacantDate.isEqual(nil) {
                elements.setObject(unit.unitStatus, forKey: "unitVacantDate")
                
            }
            
            units.append(unit)
            unit = Unit()
        }
        
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        println("count >> \(self.units.count)")
        
        return  self.units.count
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        println("indexPath.row >>")
        let unitCell = tableView.dequeueReusableCellWithIdentifier("UnitCell") as! UnitCell
        let unitResult = units[indexPath.row]
        
        unitCell.setUnitCell(unitResult.unitName as String, lblOccupier :unitResult.unitOccupierName as String,
            lblPropritor: unitResult.unitLandlord as String, lblArea: unitResult.unitArea as String)
        
        if (indexPath.row%2 == 0)
        {
            unitCell.backgroundColor = utility.uicolorFromHex(0xFFFFFF);
        }
        else{
            unitCell.backgroundColor = utility.uicolorFromHex(0xF7F9F5);
        }
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        unitCell.layer.masksToBounds = true
        unitCell.layer.borderWidth = 0.5
        unitCell.layer.borderColor = utility.uicolorFromHex(0xD6D4D6).CGColor;
        
        //Status clickable
        let  btnCompleted = unitCell.viewWithTag(11) as? UIButton
        let  btnNotCompleted = unitCell.viewWithTag(22) as? UIButton
        let  btnPending = unitCell.viewWithTag(33) as? UIButton
        
        if btnCompleted != nil{
            btnCompleted?.addTarget(self, action: "btnCompletedAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
        }
        if btnNotCompleted != nil{
            
            btnNotCompleted?.addTarget(self, action: "btnNotCompletedAction:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        if  btnPending != nil{
            
            btnPending?.addTarget(self, action: "btnPendingAction:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        return unitCell
    }
    
    
    func btnCompletedAction(sender:UIButton){
        
        let point = sender.convertPoint(CGPointZero, toView:self.unitTableView)
        let indexPath = self.unitTableView.indexPathForRowAtPoint(point)
        
        var position: CGPoint = sender.convertPoint(CGPointZero, toView: self.unitTableView)
        if let indexPath = self.unitTableView.indexPathForRowAtPoint(position)
        {
            let currentCell = self.unitTableView.cellForRowAtIndexPath(indexPath) as! UnitCell;
            currentCell.btnPending.setImage(UIImage(named: "Status_Pending1"), forState: nil)
            currentCell.btnNotCompleted.setImage(UIImage(named: "Status_Not_Synced1"), forState: nil)
        }
        sender.setImage(UIImage(named: "Status_Completed"), forState: nil)
        
    }
    func btnNotCompletedAction(sender:UIButton){
        let point = sender.convertPoint(CGPointZero, toView:self.unitTableView)
        let indexPath = self.unitTableView.indexPathForRowAtPoint(point)
        
        var position: CGPoint = sender.convertPoint(CGPointZero, toView: self.unitTableView)
        if let indexPath = self.unitTableView.indexPathForRowAtPoint(position)
        {
            let currentCell = self.unitTableView.cellForRowAtIndexPath(indexPath) as! UnitCell;
            currentCell.btnPending.setImage(UIImage(named: "Status_Pending1"), forState: nil)
            currentCell.btnCompleted.setImage(UIImage(named: "Status_Completed1"), forState: nil)
            
        }
        sender.setImage(UIImage(named: "Status_Not_Synced"), forState: nil)
    }
    
    
    
    func btnPendingAction(sender:UIButton){
        
        let point = sender.convertPoint(CGPointZero, toView:self.unitTableView)
        let indexPath = self.unitTableView.indexPathForRowAtPoint(point)
        
        var position: CGPoint = sender.convertPoint(CGPointZero, toView: self.unitTableView)
        if let indexPath = self.unitTableView.indexPathForRowAtPoint(position)
        {
            let currentCell = self.unitTableView.cellForRowAtIndexPath(indexPath) as! UnitCell;
            
            currentCell.btnNotCompleted.setImage(UIImage(named: "Status_Not_Synced1"), forState: nil)
            currentCell.btnCompleted.setImage(UIImage(named: "Status_Completed1"), forState: nil)
            
        }
        sender.setImage(UIImage(named: "Status_Pending"), forState: nil)
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let unit = units[indexPath.row]
        
        println("UNITCODE \(unit.unitCode)")
        
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = utility.uicolorFromHex(0xEBEBEB).CGColor
        selectionColor.backgroundColor = utility.uicolorFromHex(0xEBEBEB)
        cell!.selectedBackgroundView = selectionColor
        
        dispatch_async(dispatch_get_main_queue())
            {
                
                let unitEditController = self.storyboard?.instantiateViewControllerWithIdentifier("UnitEditController") as! UnitEditController
                
                unitEditController.unit = unit
                unitEditController.property = self.property
                self.showViewController(unitEditController as UIViewController, sender: unitEditController)
                
                
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        
        return nil
    }
    
    func sortingPressed(sender: AnyObject){
        var sortingPopView = SortingUnitPopoverController(nibName: "UnitSortingVIew",bundle: nil )
        
        sortingPopView.mDelegate = self
        sortingPopView.units = units
        sortingPopView.setValue(units, forKey: "units")
        
        var sortingPopoverController = UIPopoverController(contentViewController: sortingPopView)
        
        sortingPopoverController.popoverContentSize = CGSize(width: 250, height: 90)
        
        
        sortingPopoverController.presentPopoverFromBarButtonItem(sortingBtn, permittedArrowDirections: UIPopoverArrowDirection.Up
            , animated: true)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sorting" { // your identifier here
            let controller = segue.destinationViewController as! SortingUnitPopoverController
            controller.mDelegate = self
        }
    }
    
    
    @IBAction func btnPropertyMapAction(sender: AnyObject) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            
            let propertyMapController = self.storyboard?.instantiateViewControllerWithIdentifier("IndividualPropertyMap") as! PropertyMapController
            
            propertyMapController.property = self.property
            self.showViewController(propertyMapController as UIViewController, sender: propertyMapController )
            
            
        }
        
    }
    
    func refreshPageController(sortedUnits:[Unit]) {
        println("------------------")
        for unit in sortedUnits
        {
            println(unit.unitOccupierName as String)
        }
        units = sortedUnits
        unitTableView!.reloadData()
        
        println("------------------")
    }
    
    
    
}