//
//  REC_TC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 05/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class REC_TC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var quantidade: UILabel!
    @IBOutlet weak var unidade: UILabel!
    @IBOutlet weak var ingrediente: UILabel!
    
    
}
