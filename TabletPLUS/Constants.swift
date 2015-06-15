//
//  Constants.swift
//  TabletPLUS
//
//  Created by dhaval shah on 22/05/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import UIKit

class Constants {
    let SERVER_URL: String = "http://portal.cbre.eu/"
    var status = Status()
    var border = Border()
}

struct Status {
    
    //Status description
    let STATUS_PENDING = "Pending"
    let STATUS_DRAFT = "Active";
    let STATUS_COMPLETED = "Completed"
    let STATUS_SYNCED = "Synched"
    
    
    //Status code
    let STATUS_PENDING_XML = "1"
    let STATUS_DRAFT_XML = "2";
    let STATUS_COMPLETED_XML = "3"
    let STATUS_SYNCED_XML = "4"
}

struct Border {
    
    //Status description
    let BORDER_RIGHT = "right"
    let BORDER_LEFT = "left";
    let BORDER_TOP = "top"
    let BORDER_BOTTOM = "bottom"
    let BORDER_ALL = "all"

    
   }
