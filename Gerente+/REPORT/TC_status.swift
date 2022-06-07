//
//  TC_status.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 24/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class TC_status: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var producao: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var vetor: UILabel!
    @IBOutlet weak var transmitido: UILabel!
    
}
