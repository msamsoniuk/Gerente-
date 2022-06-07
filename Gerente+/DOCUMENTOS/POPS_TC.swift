//
//  POPS_TC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 19/11/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class POPS_TC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var pop: UILabel!
    @IBOutlet weak var revisao: UILabel!
    @IBOutlet weak var sequencia: UILabel!
    
    
}
