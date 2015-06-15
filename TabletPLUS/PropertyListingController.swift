//
//  PropertyListingController.swift
//  TabletPLUS
//
//  Created by dhaval shah on 21/05/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore
import MapKit


class PropertyListingController: UIViewController, NSURLConnectionDataDelegate, NSXMLParserDelegate,UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate,UIPopoverPresentationControllerDelegate ,MyProtocol  {
    
    
    @IBOutlet var uiPendingView: UIView!
    
    @IBOutlet var uiDraftView: UIView!
    
    @IBOutlet var uiCompletedView: UIView!
    var annotation = CustomPointAnnotation()
    var annotationArray : [CustomPointAnnotation] = [CustomPointAnnotation]()
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var xmlBuildingName = NSMutableString()
    var xmlAddress = NSMutableString()
    var xmlGeoArea = NSMutableString()
    var xmlLat = NSMutableString()
    var xmlLang = NSMutableString()
    var xmlStatus = NSMutableString()
    
    @IBOutlet var propertyListingTableView: UITableView!
    var properties:[Property] = [Property]()
    var property = Property()
    var allProperties:[Property] = [Property]()
    
    @IBOutlet var propertiesMap: MKMapView!
    @IBOutlet var btnSynch: UIButton!
    var constants = Constants()
    
    var pendingFilterTick = false
    var draftFilterTick = false
    var compeletdFilterTick = false
   
    var sortingImg   : UIImage = UIImage(named: "Sorting")!
    var menuImg : UIImage = UIImage(named: "Slider")!
    
    var sortingBtn : UIBarButtonItem = UIBarButtonItem()
    var menuBtn : UIBarButtonItem = UIBarButtonItem()
    var fromPopover = false
   
    @IBOutlet var lblPendingStatus: UILabel!
    
    @IBOutlet var lblDraftStatus: UILabel!
    
    @IBOutlet var lblCompleteStatus: UILabel!
    
    var utility = Utility()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Navigation Bar controller change start from here 
        //{ start here
    
      //  mDelegate = self
        if self.navigationController != nil {
            self.navigationController?.navigationBar.tintColor = uicolorFromHex(0x70B420)
            self.navigationController?.navigationBar.barTintColor = uicolorFromHex(0x70B420)
            self.navigationController?.navigationBarHidden = false
            self.navigationItem.hidesBackButton = true
        }
        
       
        
        sortingBtn = UIBarButtonItem(image: sortingImg,  style: UIBarButtonItemStyle.Done, target: self, action: Selector("sortingPressed:"))
        
        menuBtn = UIBarButtonItem(image: menuImg,  style: UIBarButtonItemStyle.Plain, target: self, action : nil)
        sortingBtn.tintColor = UIColor.whiteColor()
        menuBtn.tintColor = UIColor.whiteColor()
        var buttons : NSArray = [menuBtn,sortingBtn]
        
        self.navigationItem.rightBarButtonItems = buttons as [AnyObject]
        
        self.navigationItem.setRightBarButtonItems([menuBtn,sortingBtn], animated: true)
        
        
        //} End here
        
        propertyListingTableView.layer.masksToBounds = true
        propertyListingTableView.layer.borderColor = UIColor( red: 153/255, green: 153/255, blue:0/255, alpha: 1.0 ).CGColor
        propertyListingTableView.layer.borderWidth = 0.5
        
        
        //Side menu Start
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rightViewRevealWidth = 270
        }
        
        
        //Side menu End
        
        var currentVC = SortingPopoverController()
        currentVC.mDelegate = self
        
        
        //Code for Pendind View filter
        let pendingFilter = UITapGestureRecognizer(target: self, action: "pendingWork:")
        self.uiPendingView.addGestureRecognizer(pendingFilter)
       
        
        //Code for Draft View filter
        let draftFilter = UITapGestureRecognizer(target: self, action: "draftWork:")
        self.uiDraftView.addGestureRecognizer(draftFilter)
       
        
        //Code for Pendind View filter
        let completedFilter = UITapGestureRecognizer(target: self, action: "completedWork:")
        self.uiCompletedView.addGestureRecognizer(completedFilter)
        
        
        
        btnSynch.layer.cornerRadius = 5
        btnSynch.layer.borderWidth = 1
        btnSynch.layer.borderColor = UIColor.whiteColor().CGColor
       
        
        /*round border to status*/
        
        lblPendingStatus.layer.cornerRadius = 3.0;
        lblPendingStatus.layer.masksToBounds = true
        uiPendingView.addSubview(lblPendingStatus)

        lblDraftStatus.layer.cornerRadius = 3.0;
        lblDraftStatus.layer.masksToBounds = true
        uiDraftView.addSubview(lblDraftStatus)
        
        lblCompleteStatus.layer.cornerRadius = 3.0;
        lblCompleteStatus.layer.masksToBounds = true
        uiCompletedView.addSubview(lblCompleteStatus)

        self.beginParsing()
        
        
        loadPropertyMap()
        
    }
    
    func sortingPressed(sender: AnyObject){
        
        
      var sortingPopView = SortingPopoverController(nibName: "PopView",bundle: nil )
        
      sortingPopView.mDelegate = self
      sortingPopView.properties = properties
      sortingPopView.setValue(properties, forKey: "properties")
      var sortingPopoverController = UIPopoverController(contentViewController: sortingPopView)
      sortingPopoverController.popoverContentSize = CGSize(width: 250, height: 90)
      sortingPopoverController.presentPopoverFromBarButtonItem(sortingBtn, permittedArrowDirections: UIPopoverArrowDirection.Up
           , animated: true)
        
      }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sorting" { // your identifier here
            let controller = segue.destinationViewController as! SortingPopoverController
            controller.mDelegate = self
        }
    }

    
    func loadPropertyMap()
    {
        for annotationObj: CustomPointAnnotation in annotationArray
        {
             self.propertiesMap.removeAnnotation(annotationObj)
        }
      
        var gecoder = CLGeocoder()
        
        var latitude: CLLocationDegrees=0.0
        var longitude: CLLocationDegrees=0.0
        
        
        var latDelta: CLLocationDegrees=22
        var longDelta: CLLocationDegrees=22
        for Prop: Property in properties
        {
      //   self.propertiesMap.removeAnnotation(annotation)
            
            var latStr = Prop.lat as NSString
            var latDbl : Double  = Double(latStr.intValue)
            latitude = latDbl
            
            var langStr = Prop.lang as NSString
            var langDbl : Double = Double(langStr.intValue)
            longitude = langDbl
            
            let location = CLLocationCoordinate2D(
                latitude: latitude,
                longitude:longitude
            )
            // 2
            

            
            let span = MKCoordinateSpanMake(latDelta, longDelta)
            let region = MKCoordinateRegion(center: location, span: span)
            self.propertiesMap.setRegion(region, animated: true)
            
            //3
            annotation = CustomPointAnnotation()
            
            annotation.coordinate = location
            
            annotation.title = Prop.buildingName as String
            annotation.subtitle = Prop.address as String
            annotation.imageName = "map-marker-new"
            annotationArray.append(annotation)
            self.propertiesMap.addAnnotation(annotation)
        }
        
        
    
    
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
      
       println("mapView call")
            
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "PropertyMap"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.canShowCallout = true
        }
        else {
            anView.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView.image = UIImage(named:cpa.imageName)
        
        return anView
    }
//    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!){
//            
//            annotation.title = Prop.buildingName as String
//            annotation.subtitle = Prop.address as String
//            annotation.imageName = "map-marker-new"
//            annotationArray.append(annotation)
//            self.propertiesMap.addAnnotation(annotation)
//            
//            println("Selected annotation")
//    }
    
    
    class CustomPointAnnotation: MKPointAnnotation {
        var imageName: String!
    }
    
    func beginParsing()
    {
        posts = []
       
        parser = NSXMLParser(contentsOfURL:(NSURL(string:"\(constants.SERVER_URL)PLUSWebService/plus/companies/getAllPropertiesXML")))!
       
        parser.delegate = self
        parser.parse()
        
        propertyListingTableView!.reloadData()
        allProperties = properties
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject])
    {
        element = elementName
        if (elementName as NSString).isEqualToString("property")
        {

            elements = NSMutableDictionary.alloc()
            elements = [:]
            
            property.buildingName=NSMutableString.alloc()
            property.buildingName=""
            
            property.address = NSMutableString.alloc()
            property.address = ""
            
            
            property.areaMap = NSMutableString.alloc()
            property.areaMap = ""
          
            
            property.lat = NSMutableString.alloc()
            property.lat = ""

            
            property.lang = NSMutableString.alloc()
            property.lang = ""
            
            property.status = NSMutableString.alloc()
            property.status = ""
            
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString("property") {
            if !xmlBuildingName.isEqual(nil) {
                elements.setObject(property.buildingName, forKey: "buildingName")
             
            }
            if !xmlAddress.isEqual(nil) {
                elements.setObject(property.address, forKey: "address")
            }
            if !xmlGeoArea.isEqual(nil) {
                elements.setObject(property.areaMap, forKey: "geographicalArea")
           }
            
            if !xmlLat.isEqual(nil) {
                elements.setObject(property.lat, forKey: "latitude")
            }
            
            if !xmlLang.isEqual(nil) {
                elements.setObject(property.lang, forKey: "longitude")
            }
            if !xmlStatus.isEqual(nil) {
                elements.setObject(property.status, forKey: "status")
            }
            
            properties.append(property)
            property = Property()
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?)
    {
        
        if element.isEqualToString("buildingName") {
             xmlBuildingName.appendString(string!)
             property.buildingName.appendString(string!)
        } else if element.isEqualToString("address") {
             property.address.appendString(string!)
        }
        else if element.isEqualToString("geographicalArea") {
            property.areaMap.appendString(string!)
        }
        else if element.isEqualToString("latitude") {
            property.lat.appendString(string!)
        }
        else if element.isEqualToString("longitude") {
            property.lang.appendString(string!)
        }
        else if element.isEqualToString("status") {
            property.status.appendString(string!)
        }
        else if element.isEqualToString("dateOfConstruction") {
            property.dateOfConstruction.appendString(string!)
        }
        else if element.isEqualToString("administration") {
            property.administration.appendString(string!)
        }
        else if element.isEqualToString("contactName") {
            property.contactName.appendString(string!)
        }
        else if element.isEqualToString("contactNumber") {
            property.contactNumber.appendString(string!)
        }
        else if element.isEqualToString("propertyId") {
            property.proCode.appendString(string!)
        }
        // println("Element 3 \(elements) \(title1) ")
    }
    
  
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
      
        return  self.properties.count
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let propertyCell = tableView.dequeueReusableCellWithIdentifier("PropertyCell") as! PropertyCell
      
        
        let propertyResult=properties[indexPath.row]
        
        var status = propertyResult.status as String
        var imgStatus: UIImage = UIImage();
        if status != ""
        {
            if status == constants.status.STATUS_PENDING_XML
            {
                imgStatus = UIImage(named: "Status_Pending" as String!) as UIImage!
            }
            else if status == constants.status.STATUS_DRAFT_XML
            {
                imgStatus = UIImage(named: "Status_Draft" as String!) as UIImage!
            }
            else
            {
                imgStatus = UIImage(named: "Status_Completed" as String!) as UIImage!
            }
        }
        
        
        propertyCell.layer.masksToBounds = true
        propertyCell.layer.borderWidth = 0.5
        propertyCell.layer.borderColor = uicolorFromHex(0x959594).CGColor;
        
        
       
        
       // utility.addBorderToCell(propertyCell, color: uicolorFromHex(0x959594), border: "bottom")
        
        propertyCell.setPropertyCell(propertyResult.buildingName as String, lblAddress :propertyResult.address as String,
            lblAreaMap: propertyResult.areaMap as String,imgStatus :imgStatus )
    
        //propertyCell.selectionStyle = UITableViewCellSelectionStyle.None;
        propertyCell.backgroundColor = uicolorFromHex(0xE6E6E6);
       
            //UIColor.redColor()
       
        
        
        return propertyCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let property = properties[indexPath.row]
        println("PROCODE \(property.proCode)")
        
        var cell = tableView.cellForRowAtIndexPath(indexPath)

        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.whiteColor().CGColor
        selectionColor.backgroundColor = UIColor.whiteColor()
        cell!.selectedBackgroundView = selectionColor
        
        
        dispatch_async(dispatch_get_main_queue()) {
            
            
            let unitListingController = self.storyboard?.instantiateViewControllerWithIdentifier("UnitListing") as! UnitListingController
            
            unitListingController.property = property
            self.showViewController(unitListingController as UIViewController, sender: unitListingController )
            
            
        }

        
    }
     func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        cell!.contentView.backgroundColor =  uicolorFromHex(0xE6E6E6)
        cell!.backgroundColor =  uicolorFromHex(0xE6E6E6)
    }
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
//    {
//        
//    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        
        return nil
    }
    func uicolorFromHex(rgbValue:UInt32) -> UIColor
    {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    func resetViewColor(uiViewRef:UIView)
    {
        uiViewRef.backgroundColor = UIColor.darkGrayColor()
        uiViewRef.alpha = 0.97
    }
    func selectViewColor(uiViewRef:UIView)
    {
        uiViewRef.backgroundColor = uicolorFromHex(0x000000)
        uiViewRef.alpha = 1
    }
    
    func addFilter(status: String, uiViewRef: UIView)
    {
        for Prop: Property in properties
        {
           if Prop.status != status
            {
              properties.removeObject(Prop)
            }
        }
        selectViewColor(uiViewRef)
       
    
    }
    
    func removeFilter(status: String,uiViewRef: UIView)
    {
         properties = allProperties
        resetViewColor(uiViewRef)
    }
    
    //For Pending Filter remove/add fileration
    func pendingWorkFilter(uiViewRef: UIView)
    {
    if self.pendingFilterTick == false
        {
            self.pendingFilterTick = true
            self.draftFilterTick = false
            self.compeletdFilterTick = false
         
            selectViewColor(uiViewRef)
            resetViewColor(uiCompletedView)
            resetViewColor(uiDraftView)
          
            removeFilter(constants.status.STATUS_PENDING_XML,uiViewRef: uiPendingView)
            addFilter(constants.status.STATUS_PENDING_XML,uiViewRef: uiPendingView)
        }
        else
        {
            self.pendingFilterTick = false
            removeFilter(constants.status.STATUS_PENDING_XML,uiViewRef: uiPendingView)
        }
    }
    //For Draft Filter remove/add fileration
    func draftWorkFilter(uiViewRef: UIView)
    {
        if self.draftFilterTick == false
        {
            self.pendingFilterTick = false
            self.draftFilterTick = true
            self.compeletdFilterTick = false
           
            selectViewColor(uiViewRef)
            resetViewColor(uiCompletedView)
            resetViewColor(uiPendingView)
            
            removeFilter(constants.status.STATUS_DRAFT_XML,uiViewRef: uiViewRef)
            addFilter(constants.status.STATUS_DRAFT_XML,uiViewRef: uiViewRef)
        }
        else
        {
            self.draftFilterTick = false
            removeFilter(constants.status.STATUS_PENDING_XML,uiViewRef: uiViewRef)
        }
    }
    
    //For Completed Filter remove/add fileration
    func completedWorkFilter(uiViewRef: UIView)
    {
        if self.compeletdFilterTick == false
        {
            self.pendingFilterTick = false
            self.draftFilterTick = false
            self.compeletdFilterTick = true

            selectViewColor(uiViewRef)
            resetViewColor(uiDraftView)
            resetViewColor(uiPendingView)
            
            removeFilter(constants.status.STATUS_COMPLETED_XML,uiViewRef: uiViewRef)
            addFilter(constants.status.STATUS_COMPLETED_XML,uiViewRef: uiViewRef)
        }
        else
        {
            self.compeletdFilterTick = false
            removeFilter(constants.status.STATUS_COMPLETED_XML,uiViewRef: uiViewRef)
        }
    }
    
    
    
   func pendingWork(sender:UITapGestureRecognizer)
   {
       pendingWorkFilter(uiPendingView)
       propertyListingTableView.reloadData()
       self.propertiesMap.removeAnnotation(annotation)
       loadPropertyMap()
    
    }
   

    func draftWork(sender:UITapGestureRecognizer)
    {
        draftWorkFilter(uiDraftView)
        propertyListingTableView.reloadData()
        loadPropertyMap()
    }
    
    func completedWork(sender:UITapGestureRecognizer)
    {
        completedWorkFilter(uiCompletedView)
        propertyListingTableView.reloadData()
        loadPropertyMap()
    }
    
    func refreshPageController(sortedProperties:[Property]) {
        println("------------------")
        for Prop in sortedProperties
        {
            println(Prop.buildingName as String)
        }
        properties = sortedProperties
        propertyListingTableView!.reloadData()
        loadPropertyMap()
        println("------------------")
    }
    
 
    
     

  }