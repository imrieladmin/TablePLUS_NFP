//
//  PropertyCell.swift
//  TabletPLUS
//
//  Created by dhaval shah on 22/05/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import UIKit

class PropertyCell: UITableViewCell {

    @IBOutlet var imgStatus: UIImageView!
    
    @IBOutlet var lblBuildingName: UILabel!
    
    @IBOutlet var imgMapMarker: UIImageView!
    
    @IBOutlet var lblAddress: UILabel!
    
    @IBOutlet var lblAreaMap: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPropertyCell(lblBuildingName: String,lblAddress: String,lblAreaMap: String,imgStatus : UIImage) {
        
       
        self.lblBuildingName.text = lblBuildingName
        self.lblAddress.text = lblAddress
        self.lblAreaMap.text = lblAreaMap
        self.imgStatus.image = imgStatus
    }

}
