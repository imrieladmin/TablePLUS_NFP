//
//  SortingPopoverController.swift
//  TabletPLUS
//
//  Created by dhaval shah on 01/06/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import Foundation
import UIKit
protocol MyProtocol
{
    func refreshPageController(sortedProperties:[Property])
}
class SortingPopoverController: UIViewController
{
    
    @IBOutlet var propertyNameView: UIView!
    
    @IBOutlet var addressNameView: UIView!
    @IBOutlet var imgSortingPropertyName: UIImageView!
    
    @IBOutlet var propNameSrtImage: UIImageView!
    @IBOutlet var addressSrtImage: UIImageView!
    
    @IBOutlet var imgTickPropertyName: UIImageView!
    
    @IBOutlet var imgTickAddress: UIImageView!
    
    var properties:[Property] = [Property]()
    
    var propertyNameSrt = false
    var addressSrt = false
    
    var ascSorting = false
    var utility = Utility()
    var srtProperties : [Property] = []
    var mDelegate: MyProtocol?
    
//    override init(contentViewController viewController: UIViewController)
//    {
//        super.init()
//        println(properties.count)
//        let propertyNameSorting = UITapGestureRecognizer(target: self, action: "propertyNameSorting:")
//        self.propertyNameView.addGestureRecognizer(propertyNameSorting)
//        
//        let addressSorting = UITapGestureRecognizer(target: self, action: "addressSorting:")
//        self.addressNameView.addGestureRecognizer(addressSorting)
//        imgTickPropertyName.hidden = true
//        imgTickAddress.hidden = true
//    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
          println(properties.count)
        let propertyNameSorting = UITapGestureRecognizer(target: self, action: "propertyNameSorting:")
        self.propertyNameView.addGestureRecognizer(propertyNameSorting)
        
        let addressSorting = UITapGestureRecognizer(target: self, action: "addressSorting:")
        self.addressNameView.addGestureRecognizer(addressSorting)
        imgTickPropertyName.hidden = true
        imgTickAddress.hidden = true
        utility.addBorderToView(propertyNameView,  color:UIColor.lightGrayColor(),border: "bottom")
    }
    
    func removeViewColorSelection(uiViewRef: UIView,tickImgShow: UIImageView)
    {
      //  uiViewRef.backgroundColor =  utility.uicolorFromHex(0xF0F0F0)
        uiViewRef.alpha = 0.97
        tickImgShow.hidden = true
    }
    func addSelectedColorView(uiViewRef: UIView,tickImgShow: UIImageView)
    {
        uiViewRef.backgroundColor = UIColor.whiteColor()
        uiViewRef.alpha = 0.97
        
        tickImgShow.hidden = false
    }
    
    func propertyNameSorting(sender:UITapGestureRecognizer)
    {
         addressSrtImage.image = UIImage(named: "sorting-grey-22pt")
        if propertyNameSrt == false
        {
           ascSorting == false
           addSelectedColorView(propertyNameView,tickImgShow: imgTickPropertyName)
           propertyNameSrt =  true
           removeViewColorSelection(addressNameView,tickImgShow: imgTickAddress)
           addressSrt =  false
            if ascSorting == false
            {
                ascSorting = true
                propNameSrtImage.image = UIImage(named: "sorting-ascending-22pt")
                properties.sort(sorterForbuildingAsc)
            }
            else
            {
                ascSorting = false
                propNameSrtImage.image = UIImage(named: "sorting-desending-22pt")
                properties.sort(sorterForbuildingDesc)
            }
            
        }
        else
        {
            if ascSorting == false
            {
                ascSorting = true
                propNameSrtImage.image = UIImage(named: "sorting-ascending-22pt")
                properties.sort(sorterForbuildingAsc)
            }
            else
            {
                ascSorting = false
                propNameSrtImage.image = UIImage(named: "sorting-desending-22pt")
                properties.sort(sorterForbuildingDesc)
            }

        }
        mDelegate?.refreshPageController(properties)

    }
    func addressSorting(sender:UITapGestureRecognizer)
    {
        println("addressSorting")
        propNameSrtImage.image = UIImage(named: "sorting-grey-22pt")
        if addressSrt == false
        {
            ascSorting = false
            addSelectedColorView(addressNameView,tickImgShow: imgTickAddress)
            propertyNameSrt =  false
            removeViewColorSelection(propertyNameView,tickImgShow: imgTickPropertyName)
            addressSrt =  true
            if ascSorting == false
            {
                ascSorting = true
                addressSrtImage.image = UIImage(named: "sorting-ascending-22pt")
                properties.sort(sorterForAddressAsc)
            }
            else
            {
                ascSorting = false
                addressSrtImage.image = UIImage(named: "sorting-desending-22pt")
                properties.sort(sorterForAddressDesc)
            }
        }
        else
        {
            if ascSorting == false
            {
                ascSorting = true
                addressSrtImage.image = UIImage(named: "sorting-ascending-22pt")
                properties.sort(sorterForAddressAsc)
            }
            else
            {
                ascSorting = false
                addressSrtImage.image = UIImage(named: "sorting-desending-22pt")
                properties.sort(sorterForAddressDesc)
            }

        }
        mDelegate?.refreshPageController(properties)
        
    }
    func sorterForbuildingAsc(first:Property, secong:Property) -> Bool
    {
        var building1 = secong.buildingName as String
        var building2 = first.buildingName as String
        
        return building1>building2
    }
    func sorterForbuildingDesc(first:Property, second:Property) -> Bool {
       
        var building1 = first.buildingName as String
        var building2 = second.buildingName as String
        
        return building1>building2
    }
    
    
    func sorterForAddressAsc(first:Property, secong:Property) -> Bool
    {
        var address1 = secong.address as String
        var address2 = first.address as String
        
        return address1>address2
    }
    func sorterForAddressDesc(first:Property, second:Property) -> Bool {
        
        var address1 = first.address as String
        var address2 = second.address as String
        
        return address1>address2
    }
    
}