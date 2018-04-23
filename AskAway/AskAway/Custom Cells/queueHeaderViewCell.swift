//
//  queueHeaderViewCell.swift
//  AskAway
//
//  Created by Daniel Salib on 4/23/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit

class queueHeaderViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var waitingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
