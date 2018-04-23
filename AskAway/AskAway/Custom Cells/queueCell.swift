//
//  queueCell.swift
//  AskAway
//
//  Created by Daniel Salib on 4/23/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit

class queueCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.backgroundColor = cellColor
        cellView.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
