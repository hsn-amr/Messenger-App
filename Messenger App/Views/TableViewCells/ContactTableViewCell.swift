//
//  ContactTableViewCell.swift
//  Messenger App
//
//  Created by TURKI ALFAISAL on 30/05/1443 AH.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contactImage.makeCircle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
