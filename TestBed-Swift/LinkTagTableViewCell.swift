//
//  LinkTagTableViewCell.swift
//  TestBed-Swift
//
//  Created by David Westgate on 8/17/16.
//  Copyright © 2016 Branch Metrics. All rights reserved.
//

import UIKit

class LinkTagTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
