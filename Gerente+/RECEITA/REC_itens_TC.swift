//
//  REC_itens_TC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 17/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class REC_itens_TC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var unidade: UILabel!
    @IBOutlet weak var quantidade: UILabel!
    @IBOutlet weak var peso: UILabel!

}

