//
//  UnitCell.swift
//  TabletPLUS
//
//  Created by Ruchi Salvi on 28/05/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

import UIKit

class UnitCell: UITableViewCell {
    
    
    @IBOutlet var lblUnitName: UILabel!
    
    @IBOutlet var lblOccupier: UILabel!
    
    @IBOutlet var lblPropritor: UILabel!
   
    @IBOutlet var lblArea: UILabel!
    
    @IBOutlet var imgStatusPending: UIImageView!
    
    @IBOutlet var imgStatusCompleted: UIImageView!
    
    @IBOutlet var imgStatusNA: UIImageView!
    
    @IBOutlet var btnCompleted: UIButton!
    
    @IBOutlet var btnNotCompleted: UIButton!
    
    @IBOutlet var btnPending: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUnitCell(lblUnitName: String , lblOccupier: String, lblPropritor: String,lblArea: String) {
        
        
        self.lblUnitName.text = lblUnitName
        self.lblOccupier.text = lblOccupier
        self.lblPropritor.text = lblPropritor
        self.lblArea.text = lblArea
         
    }
    
   
    @IBAction func btnCompletedAction(sender: AnyObject) {
        println("completed..")
    }
    
    @IBAction func btnNotCompletedAction(sender: AnyObject) {
        println("not completed..")
    }
    
}

