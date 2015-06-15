//
//  SortingUnitPopoverController.swift
//  TabletPLUS
//
//  Created by Ruchi Salvi on 04/06/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import Foundation
import UIKit
protocol UnitProtocol
{
    func refreshPageController(sortedUnits:[Unit])
}
class SortingUnitPopoverController: UIViewController
{
    
    @IBOutlet var occupierNameView: UIView!
    
    @IBOutlet var landlordNameView: UIView!
    
    @IBOutlet var occupierNameSrtImage: UIImageView!
    
    @IBOutlet var landlordNameSrtImage: UIImageView!
    
    @IBOutlet var imgTickOccupierName: UIImageView!
    
    @IBOutlet var imgTickLandlordName: UIImageView!
    
    var units:[Unit] = [Unit]()
    
    var occupierNameSrt = false
    var landlordNameSrt = false
    
    var ascSorting = false
    var utility = Utility()
    var srtUnits : [Unit] = []
    var mDelegate: UnitProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(units.count)
        let occupierNameSorting = UITapGestureRecognizer(target: self, action: "occupierNameSorting:")
        self.occupierNameView.addGestureRecognizer(occupierNameSorting)
        
        let lanlordSorting = UITapGestureRecognizer(target: self, action: "landlordNameSorting:")
        self.landlordNameView.addGestureRecognizer(lanlordSorting)
        imgTickOccupierName.hidden = true
        imgTickLandlordName.hidden = true
        
        utility.addBorderToView(occupierNameView,  color:UIColor.lightGrayColor(),border: "bottom")


    }
    
    func removeViewColorSelection(uiViewRef: UIView,tickImgShow: UIImageView)
    {
       
        tickImgShow.hidden = true
    }
    
    func addSelectedColorView(uiViewRef: UIView,tickImgShow: UIImageView)
    {
      
        tickImgShow.hidden = false
    }
    
    func occupierNameSorting(sender:UITapGestureRecognizer)
    {
        landlordNameSrtImage.image = UIImage(named: "sorting-grey-22pt")
        if occupierNameSrt == false
        {
            ascSorting == false
            addSelectedColorView(occupierNameView,tickImgShow: imgTickOccupierName)
            occupierNameSrt =  true
            removeViewColorSelection(occupierNameView,tickImgShow: imgTickLandlordName)
            landlordNameSrt =  false
            if ascSorting == false
            {
                ascSorting = true
                occupierNameSrtImage.image = UIImage(named: "sorting-ascending-22pt")
                units.sort(sorterForOccupierAsc)
            }
            else
            {
                ascSorting = false
                occupierNameSrtImage.image = UIImage(named: "sorting-desending-22pt")
                units.sort(sorterForOccupierDesc)
            }
            
        }
        else
        {
            if ascSorting == false
            {
                ascSorting = true
                occupierNameSrtImage.image = UIImage(named: "sorting-ascending-22pt")
                units.sort(sorterForOccupierAsc)
            }
            else
            {
                ascSorting = false
                occupierNameSrtImage.image = UIImage(named: "sorting-desending-22pt")
                units.sort(sorterForOccupierDesc)
            }
            
        }
        println("reload")

        mDelegate?.refreshPageController(units)
        
    }
    func landlordNameSorting(sender:UITapGestureRecognizer)
    {
        println("landlordNameSorting")
        occupierNameSrtImage.image = UIImage(named: "sorting-grey-22pt")
        if landlordNameSrt == false
        {
            ascSorting = false
            addSelectedColorView(landlordNameView,tickImgShow: imgTickLandlordName)
            occupierNameSrt =  false
            removeViewColorSelection(occupierNameView,tickImgShow: imgTickOccupierName)
            landlordNameSrt =  true
            if ascSorting == false
            {
                ascSorting = true
                landlordNameSrtImage.image = UIImage(named: "sorting-ascending-22pt")
                units.sort(sorterForLanlordAsc)
            }
            else
            {
                ascSorting = false
                landlordNameSrtImage.image = UIImage(named: "sorting-desending-22pt")
                units.sort(sorterForLandlordDesc)
            }
        }
        else
        {
            if ascSorting == false
            {
                ascSorting = true
                landlordNameSrtImage.image = UIImage(named: "sorting-ascending-22pt")
                units.sort(sorterForLanlordAsc)
            }
            else
            {
                ascSorting = false
                landlordNameSrtImage.image = UIImage(named: "sorting-desending-22pt")
                units.sort(sorterForLandlordDesc)
            }
            
        }
        println("reload")
        mDelegate?.refreshPageController(units)
        
    }
    func sorterForOccupierAsc(first:Unit, second:Unit) -> Bool
    {
        var occupier1 = second.unitOccupierName as String
        var occupier2 = first.unitOccupierName as String
        
        return occupier1>occupier2
    }
    func sorterForOccupierDesc(first:Unit, second:Unit) -> Bool {
        
        var occupier1 = first.unitOccupierName as String
        var occupier2 = second.unitOccupierName as String
        
        return occupier1>occupier2
    }
    
    
    func sorterForLanlordAsc(first:Unit, second:Unit) -> Bool
    {
        var landlord1 = second.unitLandlord as String
        var landlord2 = first.unitLandlord as String
        
        return landlord1>landlord2
    }
    func sorterForLandlordDesc(first:Unit, second:Unit) -> Bool {
        
        var landlord1 = first.unitLandlord as String
        var landlord2 = second.unitLandlord as String
        
        return landlord1>landlord2

    }
    
    
}