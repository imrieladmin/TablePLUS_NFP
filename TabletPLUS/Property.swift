//
//  Property.swift
//  TabletPLUS
//
//  Created by dhaval shah on 21/05/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import Foundation


class Property
{
    
    var buildingName: NSMutableString = ""
    var proCode: NSMutableString = ""
    var areaMap: NSMutableString = ""
    var coordinates: String = ""
    var address: NSMutableString = ""
    var status: NSMutableString = ""
    var lat: NSMutableString = ""
    var lang: NSMutableString = ""
    
    var dateOfConstruction: NSMutableString = ""
    var administration: NSMutableString = ""
    var contactName: NSMutableString = ""
    var contactNumber: NSMutableString = ""
    
    var units:[Unit] = [Unit]()
}