//
//  MessageCell.swift
//  AskAway
//
//  Created by Daniel Salib on 4/23/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
