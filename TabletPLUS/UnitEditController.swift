//
//  UnitEditController.swift
//  TabletPLUS
//
//  Created by dhaval shah on 04/06/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

class UnitEditController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, NSURLConnectionDataDelegate, NSXMLParserDelegate, UIScrollViewDelegate
{
    
    var constants = Constants()
    var utility = Utility()
    
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet var lblPropAddress: UILabel!
    
    @IBOutlet var lblUnitName: UILabel!
    
    @IBOutlet var lblOccupier: UILabel!
    
    @IBOutlet var lblLineOfBussOccupier: UILabel!
    
    @IBOutlet var lblLandlord: UILabel!
    
    @IBOutlet var lblLineOfLandlord: UILabel!
    
    @IBOutlet var lblBusinessType: UILabel!
    
    @IBOutlet var lblEffectiveDate: UILabel!
    
    @IBOutlet var lblExclusionDate: UILabel!
    
    @IBOutlet var lblVecantDate: UILabel!
    
    @IBOutlet var lblObservation: UILabel!
    
    @IBOutlet var txtUnitName: UITextField!
    
    @IBOutlet var txtLineOfBussOccupier: UITextField!
    
    @IBOutlet var txtLandlord: UITextField!
   
    @IBOutlet var txtEffectiveDate: UITextField!
    
    @IBOutlet var txtExclusionDate: UITextField!
    
    @IBOutlet var txtVecantDate: UITextField!
    
    @IBOutlet var backGroundVIew: UIView!
    
    @IBOutlet var txtOccupier: UITextField!
    
    @IBOutlet var autocompleteTableView: UITableView!
    
    
    @IBOutlet var txtlineOfLandlord: UITextField!
    
    @IBOutlet var txtBusinessType: UITextField!
    
    @IBOutlet var lblStatus: UILabel!
    
    @IBOutlet var txtObservation: UITextView!
    
    @IBOutlet var sgcUnit: UISegmentedControl!
    
    //Images Embeding
    
    
    @IBOutlet var imgResetUnitName: UIView!
    @IBOutlet var imgResetOccupier: UIView!
    @IBOutlet var imgResetLineOfOccupier: UIView!
    
    @IBOutlet var imgResetLandlord: UIView!
    
    @IBOutlet var imgResetLineOfLandlord: UIImageView!
    
    @IBOutlet var imgResetTypeOfOccupier: UIImageView!
    
    
    @IBOutlet var imgResetEffectiveDate: UIImageView!
    
    @IBOutlet var imgResetExclusionDate: UIImageView!
    
    @IBOutlet var imgResetVecantDate: UIImageView!
    
    @IBOutlet var imgResetObeservation: UIImageView!
    
     @IBOutlet var contentScrollView: UIScrollView!
    
    //var activeTextField: UITextField = UITextField()
  //  let autocompleteTableView = UITableView(frame: CGRectMake(0,80,320,120), style: UITableViewStyle.Plain)
    
    var pastUrls = ["Poppins Restaurants","The Outdoor Group Limited","Leslie Perkins","HCW Consultancy","Carey Jones Architects Ltd","Whitfield","Card Crazy (2000) Ltd","Shelworks","Parfitt","Thameside Metropolitan Boro","Cecil Gee","HSBC Bank Plc","Barcalays Bank","Adria Airways","CBRE Limited","CBRE Investments","Al Baraka Bank",
        "JLL","Savills","RBS","Jong Liang Plc","A bars","BD Pvt. Ltd","DataRocks Ltd","Ab Ltd","Barclays Bank"]
    
  //  var pastURL: String = String()
    var autocompleteUrls = [String]()
    
    
    var menuBtn : UIBarButtonItem = UIBarButtonItem()
    var sortingImg   : UIImage = UIImage(named: "Sorting")!
    var menuImg : UIImage = UIImage(named: "Slider")!
    
    var txtLandlordChangeFlag = false
    var txtOccupierChangeFlag = false
    
    //XML parsing logic
    
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var xmlCompanyName = NSMutableString()
    
    var comapnyNameStr: NSMutableString = ""
    
    var unit = Unit()
    var property = Property()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.tintColor = utility.uicolorFromHex(0x70B420)
        self.navigationController?.navigationBar.barTintColor = utility.uicolorFromHex(0x70B420)
        
        var attr = NSDictionary(object: UIFont(name: "Helvetica", size: 16.0)!, forKey: NSFontAttributeName)
        sgcUnit.setTitleTextAttributes(attr as [NSObject : AnyObject], forState: .Normal)
        

        //Navigation Buttons - start
       
        menuBtn = UIBarButtonItem(image: menuImg,  style: UIBarButtonItemStyle.Plain, target: self, action: Selector ("menuPressed:"))
  
        //beginParsing()
        autocompleteTableView.reloadData()
        
        
        menuBtn.tintColor = UIColor.whiteColor()
        var buttons : NSArray = [menuBtn]
    
        self.navigationItem.rightBarButtonItems = buttons as [AnyObject]
        self.navigationItem.setRightBarButtonItems([menuBtn], animated: true)
    
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
     
        //Navigation Buttons - End
        
        //Side menu Start
        if self.revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rightViewRevealWidth = 270
        }
        
        
        //Side menu End
     
        txtOccupier.delegate = self
        txtLandlord.delegate = self
        txtUnitName.delegate = self
        
        txtObservation.delegate = self
        
        var comma = ", "
        lblPropAddress.text = "\(property.buildingName as String) \(comma) \(property.address as String)"
        lblPropAddress.sizeToFit()
        lblPropAddress.numberOfLines = 0
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        autocompleteTableView.scrollEnabled = true
        autocompleteTableView.hidden = true
       
        //Fileds Logic starts here
        txtUnitName.text = unit.unitName as String
        
        txtOccupier.text = unit.unitOccupierName as String
        txtLandlord.text = unit.unitLandlord as String
        
        
        
        
        txtObservation.text = ""
 		txtObservation.text = ""
        txtLineOfBussOccupier.text = unit.unitLineOfBusinessOccupier as String
        txtlineOfLandlord.text = unit.unitLineOfBusinessProprietor as String
        txtBusinessType.text = unit.unitTypeOfOccupier as String
        txtEffectiveDate.text = unit.unitEffectiveDate as String
        txtExclusionDate.text = unit.unitExclusionDate as String
        txtVecantDate.text = unit.unitVacantDate as String
        
        txtObservation.layer.borderWidth = 0.5
        txtObservation.layer.borderColor = UIColor.lightGrayColor().CGColor
       
        
        utility.textFieldDesign(txtUnitName)
        txtUnitName.layer.borderColor =  UIColor.lightGrayColor().CGColor
        utility.textFieldDesign(txtOccupier)
        utility.textFieldDesign(txtLineOfBussOccupier)
        utility.textFieldDesign(txtLandlord)
        utility.textFieldDesign(txtlineOfLandlord)
        utility.textFieldDesign(txtBusinessType)
        utility.textFieldDesign(txtEffectiveDate)
        
        utility.textFieldDesign(txtExclusionDate)
        utility.textFieldDesign(txtVecantDate)
        
        
      
        
        
        //txtUnitName.layer.cornerRadius = -1
        
        //Labels text to be display
        
        lblUnitName.text = "Unidade"
        lblOccupier.text = "Ocupante"
        lblLineOfBussOccupier.text = "Ramo de Antividade do Ocupante"
        lblLandlord.text = "Proprietario"
        lblLineOfLandlord.text = "Ramo de Antividade do Proprietaro"
        lblBusinessType.text =  "Tipo de Occupacao"
        lblEffectiveDate.text = "Cadestro"
        lblExclusionDate.text = "Exclusao"
        lblVecantDate.text = "Ira vagar em"
        lblObservation.text = "Observaco"
        
        
        
        lblStatus.text =  utility.getStatusFromXmlStatus(unit.unitStatus as String)
        if(unit.unitStatus == constants.status.STATUS_DRAFT_XML){
            lblStatus.backgroundColor = UIColor.yellowColor()
        }
        else if(unit.unitStatus == constants.status.STATUS_PENDING_XML){
            lblStatus.backgroundColor = UIColor.redColor()
        }
        else if(unit.unitStatus == constants.status.STATUS_COMPLETED_XML){
            lblStatus.backgroundColor = UIColor.greenColor()
        }
        lblStatus.textColor = UIColor.blackColor()
        lblStatus.layer.cornerRadius = 4.0;
        lblStatus.layer.masksToBounds = true
       // labelView.addSubview(lblPropStatus)
        
    }
    func tableViewdesignFunc(textField: UITextField)
    {
        //var countRow = autocompleteUrls.count
        var height: Float = Float(autocompleteUrls.count) * 42.0 + 0; // 4*25.00 + 10
        var HeightCGFloat: CGFloat = CGFloat(height)
        autocompleteTableView.hidden = false
        
        if txtOccupierChangeFlag == true
        {
            autocompleteTableView.frame = CGRectMake(293,93,textField.frame.width,HeightCGFloat)
        }
        else
        {
            autocompleteTableView.frame = CGRectMake(293,175,textField.frame.width,HeightCGFloat)
        }
        
        
        autocompleteTableView.layer.borderWidth = 1
        autocompleteTableView.layer.cornerRadius = 10
        autocompleteTableView.layer.borderColor = UIColor.whiteColor().CGColor
        autocompleteTableView.separatorColor = UIColor.whiteColor()
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
       
    //    println(self.txtOccupier)
        var substring = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
       
        searchAutocompleteEntriesWithSubstring(substring)
        if substring != ""
        {
            tableViewdesignFunc(textField)
        }
        else
        {
            autocompleteTableView.hidden = true
        }
        return true     // not sure about this - could be false
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        autocompleteUrls.removeAll(keepCapacity: false)
        
        for curString in pastUrls
        {
             //println(curString)
            var myString:NSString! = (curString as NSString).lowercaseString
            
            var substringRange :NSRange! = myString.rangeOfString(substring.lowercaseString)
            
            if (substringRange.location  == 0)
            {
                autocompleteUrls.append(curString as String)
            }
            
        }
       // println("before reload")
        autocompleteTableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  println("AUTOCOMPLETE \(autocompleteUrls.count)")
        return autocompleteUrls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  
        //  println("In the table view Cell")
        let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(autoCompleteRowIdentifier) as? UITableViewCell
        cell?.backgroundColor = UIColor.darkGrayColor()
        cell?.alpha = 1
        cell?.textLabel?.textColor = UIColor.whiteColor()
        cell?.textLabel?.font 
        
        if let tempo1 = cell
        {
            let index = indexPath.row as Int
            cell!.textLabel!.text = autocompleteUrls[index]
        } else
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: autoCompleteRowIdentifier)
        }
        return cell!
    
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if txtOccupierChangeFlag == true
        {
            txtOccupier.text = selectedCell.textLabel!.text
        }
        else
        {
            txtLandlord.text = selectedCell.textLabel!.text
        }
        autocompleteTableView.hidden = true
    }
    
        
    func datePickerViewMethod(pickerViewRef: UIDatePicker)
    {
        pickerViewRef.backgroundColor = UIColor.whiteColor()
        pickerViewRef.datePickerMode = UIDatePickerMode.Date
        
        
    }
    
    @IBAction func effectiveDateEditingBegin(sender: UITextField) {
         var datePickerView: UIDatePicker =   UIDatePicker()
        
        
        datePickerViewMethod(datePickerView) //common function to be
         sender.inputView = datePickerView
         datePickerView.addTarget(self, action: Selector("effectiveDateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    func effectiveDateChanged(sender: UIDatePicker)
    {
        var dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        txtEffectiveDate.text = dateformatter.stringFromDate(sender.date)
    }
    
    
    
    @IBAction func exclusionDateEditingBegin(sender: UITextField) {
        var datePickerView: UIDatePicker =   UIDatePicker()
        datePickerViewMethod(datePickerView) //common function to be
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("exclusionDateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func exclusionDateChanged(sender: UIDatePicker)
    {
        var dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle
        txtExclusionDate.text = dateformatter.stringFromDate(sender.date)
    }
    
    @IBAction func vacantDateEditingBegin(sender: UITextField) {
        var datePickerView: UIDatePicker =   UIDatePicker()
        datePickerViewMethod(datePickerView) //common function to be
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("vacantDateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    func vacantDateChanged(sender: UIDatePicker)
    {
        var dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle
        txtVecantDate.text = dateformatter.stringFromDate(sender.date)
    }
    
    
    
    
    
    func beginParsing()
    {
        pastUrls = []
        
        parser = NSXMLParser(contentsOfURL:(NSURL(string:"\(constants.SERVER_URL)PLUSWebService/plus/companies/getAllCompaniesXML")))!
        
        parser.delegate = self
        parser.parse()
        println("COUNT  \(pastUrls.count)")
        
        
    }
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject])
    {
        element = elementName
        if (elementName as NSString).isEqualToString("company")
        {
            
            elements = NSMutableDictionary.alloc()
            elements = [:]
            
            xmlCompanyName = NSMutableString.alloc()
            xmlCompanyName = ""
            
            
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString("company") {
            if !xmlCompanyName.isEqual(nil) {
                elements.setObject(comapnyNameStr, forKey: "orgName")
                
            }
            
            pastUrls.append(comapnyNameStr as String)
            comapnyNameStr = ""
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?)
    {
        
        if element.isEqualToString("orgName") {
            xmlCompanyName.appendString(string!)
          // comapnyNameStr.appendString(string!)
        }
        // println("Element 3 \(elements) \(title1) ")
    }
    
    @IBAction func txtOccupierChangeBegin(sender: AnyObject) {
        txtLandlordChangeFlag = false
        txtOccupierChangeFlag = true
    }
    
    @IBAction func txtOccupierChangeEnd(sender: AnyObject) {
         txtOccupierChangeFlag = false
        
    }
    @IBAction func txtLandLordChangeBegin(sender: AnyObject) {
        txtLandlordChangeFlag = true
    }
    @IBAction func txtEditChangedEnd(sender: AnyObject) {
         txtLandlordChangeFlag = false
    }
    
    
    
    @IBAction func unitSegmentControl(sender: AnyObject) {
        
        if sender.selectedSegmentIndex == 2
        {
            
            dispatch_async(dispatch_get_main_queue()) {
                
                
                let unitListingController = self.storyboard?.instantiateViewControllerWithIdentifier("UnitListing") as! UnitListingController
                
                unitListingController.property = self.property
                self.showViewController(unitListingController as UIViewController, sender: unitListingController )
                
                
            }

            
        }
    }
    
    
    @IBAction func unitValChangeSgc(sender: AnyObject) {
        if sender.selectedSegmentIndex == 0
        {
          
            // JSSAlertView().info(self, title: "SUCCESS", text: "Unit status updated to draft", buttonText: "OK")
            var alert = UIAlertController(title: "Success", message: "Unit status updated to Salvar", preferredStyle: UIAlertControllerStyle.Alert)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            let otherAction = UIAlertAction(title: "OK", style: .Default){action in
                // I know I need to put something in here.
                
            }
            
            
            alert.addAction(otherAction)
            
        }
        else if sender.selectedSegmentIndex == 1
        {
            
            var alert = UIAlertController(title: "Success", message: "Unit status mark as Savar e Concluir", preferredStyle: UIAlertControllerStyle.Alert)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            let otherAction = UIAlertAction(title: "OK", style: .Default){action in
                // I know I need to put something in here.
               
            }
            
            
            alert.addAction(otherAction)
            
            
        }
        else if sender.selectedSegmentIndex == 2
        {
            
            dispatch_async(dispatch_get_main_queue()) {
                
                
                let unitListingController = self.storyboard?.instantiateViewControllerWithIdentifier("UnitListing") as! UnitListingController
                
                unitListingController.property = self.property
                self.showViewController(unitListingController as UIViewController, sender: unitListingController )
                
                
            }
            
            
        }
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.txtUnitName {
            self.txtOccupier.becomeFirstResponder()
        }
        else if textField == self.txtOccupier {
            self.txtLineOfBussOccupier.becomeFirstResponder()
        }
        else if textField == self.txtLineOfBussOccupier {
            self.txtLandlord.becomeFirstResponder()
        }
        else if textField == self.txtLandlord {
            self.txtlineOfLandlord.becomeFirstResponder()
        }
       
        else if textField == self.txtlineOfLandlord {
            self.txtBusinessType.becomeFirstResponder()
        }
        else if textField == self.txtBusinessType {
            self.txtObservation.becomeFirstResponder()
        }
        
        
        return true
    }
   
  
    
    func textViewDidBeginEditing(textView: UITextView) {
         var scrollPoint : CGPoint = CGPointMake(0.0, txtObservation!.frame.origin.y - 200)
        self.contentScrollView.setContentOffset(scrollPoint, animated: true)
      
       
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.contentScrollView.setContentOffset(CGPointZero, animated: true)
       
    }
    
   

    
    /* keyboard event */
    
//    var activeTextField: UITextField?
//    
//        override func viewWillAppear(animated: Bool) {
//            super.viewWillAppear(animated)
//            self.registerForKeyboardNotifications()
//        }
//    
//        override func viewDidDisappear(animated: Bool) {
//            super.viewWillDisappear(animated)
//            NSNotificationCenter.defaultCenter().removeObserver(self)
//        }
//    func textFieldDidBeginEditing(textField: UITextField) {
//        activeTextField = textField
//        contentScrollView.scrollEnabled = true
//    }
//    
//    func textFieldDidEndEditing(textField: UITextField) {
//        activeTextField = nil
//        contentScrollView.scrollEnabled = false
//    }
//    
//    func registerForKeyboardNotifications() {
//        let notificationCenter = NSNotificationCenter.defaultCenter()
//        notificationCenter.addObserver(self,
//            selector: "keyboardWillBeShown:",
//            name: UIKeyboardWillShowNotification,
//            object: nil)
//        notificationCenter.addObserver(self,
//            selector: "keyboardWillBeHidden:",
//            name: UIKeyboardWillHideNotification,
//            object: nil)
//    }
//    
//    // Called when the UIKeyboardDidShowNotification is sent.
//    func keyboardWillBeShown(sender: NSNotification) {
//        let info: NSDictionary = sender.userInfo!
//        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
//        let keyboardSize: CGSize = value.CGRectValue().size
//        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
//        contentScrollView.contentInset = contentInsets
//        contentScrollView.scrollIndicatorInsets = contentInsets
//        
//        // If active text field is hidden by keyboard, scroll it so it's visible
//        // Your app might not need or want this behavior.
//        var aRect: CGRect = self.view.frame
//        aRect.size.height -= keyboardSize.height
//        let activeTextFieldRect: CGRect? = activeTextField?.frame
//        let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
//        if (!CGRectContainsPoint(aRect, activeTextFieldOrigin!)) {
//            contentScrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
//        }
//    }
//    
//    // Called when the UIKeyboardWillHideNotification is sent
//    func keyboardWillBeHidden(sender: NSNotification) {
//        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
//        contentScrollView.contentInset = contentInsets
//        contentScrollView.scrollIndicatorInsets = contentInsets
//    }
    
    
    //example 2
//    func hideKeyboard() {
//        txtLineOfBussOccupier.resignFirstResponder()
//        txtLandlord.resignFirstResponder()
//        txtEffectiveDate.resignFirstResponder()
//        txtExclusionDate.resignFirstResponder()
//        txtVecantDate.resignFirstResponder()
//        txtOccupier.resignFirstResponder()
//        txtlineOfLandlord.resignFirstResponder()
//        txtBusinessType.resignFirstResponder()
//        txtObservation.resignFirstResponder()
//
//    }
//    
//    var activeField: UITextField?
//    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        activeField = textField
//    }
//    
//    func textFieldDidEndEditing(textField: UITextField) {
//        activeField = nil
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        let center = NSNotificationCenter.defaultCenter()
//        center.addObserver(self, selector: "keyboardOnScreen:", name: UIKeyboardDidShowNotification, object: nil)
//        center.addObserver(self, selector: "keyboardOffScreen:", name: UIKeyboardDidHideNotification, object: nil)
//    }
//    
//    func keyboardOnScreen(notification: NSNotification){
//        // Retrieve the size and top margin (inset is the fancy word used by Apple)
//        // of the keyboard displayed.
//        let info: NSDictionary  = notification.userInfo!
//        let kbSize = info.valueForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue().size
//        let contentInsets: UIEdgeInsets  = UIEdgeInsetsMake(0.0, 0.0, kbSize!.height, 0.0)
//        
//        contentScrollView.contentInset = contentInsets
//        contentScrollView.scrollIndicatorInsets = contentInsets
//        
//        var aRect: CGRect = self.view.frame
//        aRect.size.height -= kbSize!.height
//        //you may not need to scroll, see if the active field is already visible
//        if (CGRectContainsPoint(aRect, activeField!.frame.origin) == false) {
//            let scrollPoint:CGPoint = CGPointMake(0.0, activeField!.frame.origin.y - kbSize!.height)
//            contentScrollView.setContentOffset(scrollPoint, animated: true)
//        }
//    }
//    
//    func keyboardOffScreen(notification: NSNotification){
//        let contentInsets:UIEdgeInsets = UIEdgeInsetsZero
//        
//        contentScrollView.contentInset = contentInsets
//        contentScrollView.scrollIndicatorInsets = contentInsets
//        
//        self.contentScrollView.setContentOffset(CGPointMake(0, -self.view.frame.origin.y/2), animated: true)
//    }

    // Example 3
//    override func viewWillAppear(animated: Bool) {
//       
//        contentScrollView.contentSize = CGSizeMake(320, 500);
//         super.viewWillAppear(animated)
//    }
//    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        self.contentScrollView.setContentOffset(CGPointMake(0,textField.center.y-140), animated: true)
//        
//
//    }
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//         self.contentScrollView.setContentOffset(CGPointMake(0,0), animated: true)
//       return true
//    }
    
    
}
