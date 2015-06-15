//
//  Utility.swift
//  TabletPLUS
//
//  Created by Ruchi Salvi on 28/05/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import UIKit

class Utility {
    var constants = Constants()
    
    /* Get status description from status code */
    func getStatusFromXmlStatus(statusCode : String) ->  String {
        var statusDesc : String = ""
        
        if (!statusCode.isEmpty)
        {
            if ((statusCode as NSString).isEqualToString(constants.status.STATUS_PENDING_XML))  {
                statusDesc = "\(constants.status.STATUS_PENDING)"
            }
            else  if ((statusCode as NSString).isEqualToString(constants.status.STATUS_DRAFT_XML))  {
                statusDesc = "\(constants.status.STATUS_DRAFT)"
            }
            else  if ((statusCode as NSString).isEqualToString(constants.status.STATUS_COMPLETED_XML))  {
                statusDesc = "\(constants.status.STATUS_COMPLETED)"
            }
            else  if ((statusCode as NSString).isEqualToString(constants.status.STATUS_SYNCED_XML))  {
                statusDesc = "\(constants.status.STATUS_SYNCED)"
            }
        }
        
        return statusDesc
    }
    
    /* Get status code from status description */
    func  getXmlStatusFromStatus(statusDesc : String) ->  String {
        var statusCode : String = ""
        
        if (!statusDesc.isEmpty)
        {
            if ((statusDesc as NSString).isEqualToString(constants.status.STATUS_PENDING))  {
                statusCode = "\(constants.status.STATUS_PENDING_XML)"
            }
            else  if ((statusDesc as NSString).isEqualToString(constants.status.STATUS_DRAFT))  {
                statusCode = "\(constants.status.STATUS_DRAFT_XML)"
            }
            else  if ((statusDesc as NSString).isEqualToString(constants.status.STATUS_COMPLETED))  {
                statusCode = "\(constants.status.STATUS_COMPLETED_XML)"
            }
            else  if ((statusDesc as NSString).isEqualToString(constants.status.STATUS_SYNCED))  {
                statusCode = "\(constants.status.STATUS_SYNCED_XML)"
            }
        }
        
        return statusCode
    }
    
    /* Get uiColor rgb from hex value */
    func uicolorFromHex(rgbValue:UInt32) -> UIColor
    {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    /* Get gradient Layer for view background */
    func getGradientLayer() -> CAGradientLayer {
       
        var topColor = uicolorFromHex(0xF0F0F0)
        var bottomColor = uicolorFromHex(0xD4D4D4)
        
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
    
    func addBorderToView(viewObj : UIView! , color: UIColor!, border: String!){
        
        var borderLayer = CALayer()
        var width = CGFloat(0.5)
        borderLayer.borderColor = UIColor.lightGrayColor().CGColor
        if ((border as NSString).isEqualToString(constants.border.BORDER_RIGHT))  {
            borderLayer.frame = CGRect(x: viewObj.frame.size.width - width, y: 0, width:  viewObj.frame.size.width, height: viewObj.frame.size.height)
        }
        else if ((border as NSString).isEqualToString(constants.border.BORDER_BOTTOM))  {
            borderLayer.frame = CGRect(x: 0, y: viewObj.frame.size.height - width, width:  viewObj.frame.size.width, height: viewObj.frame.size.height)
        }
        else if ((border as NSString).isEqualToString(constants.border.BORDER_LEFT))  {
            borderLayer.frame = CGRect(x: 0 - width, y: 0, width:  width, height: viewObj.frame.size.height)
        }
        else if ((border as NSString).isEqualToString(constants.border.BORDER_TOP))  {
            borderLayer.frame = CGRect(x: 0, y: 0, width:  viewObj.frame.size.width, height: viewObj.frame.size.height)
        }
        
        borderLayer.borderWidth = width
        viewObj.layer.addSublayer(borderLayer)
        viewObj.layer.masksToBounds = true
    }
    
    
    func addBorderToLabel(labelObj : UILabel! , color: UIColor!, border: String!){
        
        var borderLayer = CALayer()
        var width = CGFloat(0.5)
        borderLayer.borderColor = UIColor.lightGrayColor().CGColor
        if ((border as NSString).isEqualToString(constants.border.BORDER_RIGHT))  {
            borderLayer.frame = CGRect(x: labelObj.frame.size.width - width, y: 0, width:  labelObj.frame.size.width, height: labelObj.frame.size.height)
        }
        else if ((border as NSString).isEqualToString(constants.border.BORDER_BOTTOM))  {
            borderLayer.frame = CGRect(x: 0, y: labelObj.frame.size.height - width, width:  labelObj.frame.size.width, height: labelObj.frame.size.height)
        }
        else if ((border as NSString).isEqualToString(constants.border.BORDER_LEFT))  {
            borderLayer.frame = CGRect(x: 0 - width, y: 0, width:  width, height: labelObj.frame.size.height)
        }
        else if ((border as NSString).isEqualToString(constants.border.BORDER_TOP))  {
            borderLayer.frame = CGRect(x: 0, y: 0, width:  labelObj.frame.size.width, height: labelObj.frame.size.height)
        }
        
        borderLayer.borderWidth = width
        labelObj.layer.addSublayer(borderLayer)
        labelObj.layer.masksToBounds = true
    }
    
    func addBorderToCell(cellObj : UITableViewCell! , color: UIColor!, border: String!){
        
        var borderLayer = CALayer()
        var width = CGFloat(0.5)
        borderLayer.borderColor = UIColor.lightGrayColor().CGColor
        if ((border as NSString).isEqualToString(constants.border.BORDER_RIGHT))  {
            borderLayer.frame = CGRect(x: cellObj.frame.size.width - width, y: 0, width:  cellObj.frame.size.width, height: cellObj.frame.size.height)
        }
        else if ((border as NSString).isEqualToString(constants.border.BORDER_BOTTOM))  {
            borderLayer.frame = CGRect(x: 0, y: cellObj.frame.size.height - width, width:  cellObj.frame.size.width, height: cellObj.frame.size.height)
        }
        else if ((border as NSString).isEqualToString(constants.border.BORDER_LEFT))  {
            borderLayer.frame = CGRect(x: 0 - width, y: 0, width:  width, height: cellObj.frame.size.height)
        }
        else if ((border as NSString).isEqualToString(constants.border.BORDER_TOP))  {
            borderLayer.frame = CGRect(x: 0, y: 0, width:  cellObj.frame.size.width, height: cellObj.frame.size.height)
        }
        
        borderLayer.borderWidth = width
        cellObj.layer.addSublayer(borderLayer)
        cellObj.layer.masksToBounds = true
    }
    

    func addGradientToView(viewObj : UIView!){
        var caGradientLayer = getGradientLayer()
        caGradientLayer.frame =  viewObj.bounds
        viewObj.layer.insertSublayer(caGradientLayer, atIndex: 0)
    }
    
    func addGradientToLabel(labelObj : UILabel!){
        var caGradientLayer = getGradientLayer()
        caGradientLayer.frame =  labelObj.bounds
        labelObj.layer.insertSublayer(caGradientLayer, atIndex: 0)
    }
    func textFieldDesign(textField : UITextField)
    {
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        let txtPadding = UIView(frame: CGRectMake(0, 0, 10, textField.frame.height))
        textField.leftView = txtPadding
        textField.leftViewMode = UITextFieldViewMode.Always
      //  textField.layer.borderColor = uicolorFromHex(0xF0F0F0).CGColor
       // textField.layer.cornerRadius = 5
        
    }
 
    
}
