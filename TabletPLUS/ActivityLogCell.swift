//
//  ActivityLogCell.swift
//  TabletPLUS
//
//  Created by Ruchi Salvi on 10/06/15.
//  Copyright (c) 2015 dhaval shah. All rights reserved.
//

class ActivityLogCell: UITableViewCell {
    
    @IBOutlet var lblActivityLog: UILabel!
    @IBOutlet var lblActivityDateTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setActivityCell(strActivityLog: String,strActivityDateTime: String) {
        
        
        self.lblActivityLog.text = strActivityLog
        self.lblActivityDateTime.text = strActivityDateTime
        
        
    }
    
}
