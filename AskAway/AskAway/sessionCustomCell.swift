//
//  sessionCustomCell.swift
//  AskAway
//
//  Created by Daniel Salib on 4/7/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit

class sessionCustomCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellView.backgroundColor = cellColor
        cellView.layer.cornerRadius = 4
//        cellView.layer.cornerRadius = 4
//        cellView.layer.shadowRadius = 1
//        cellView.layer.shadowColor = shadowColor.cgColor
//        cellView.layer.shadowOffset = CGSize.zero
//        cellView.layer.shadowOpacity = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
