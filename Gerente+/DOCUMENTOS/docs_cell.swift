//
//  docs_cell.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 24/09/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class docs_cell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var documento: UILabel!
    @IBOutlet weak var data_insercao: UILabel!
    @IBOutlet weak var dias_a_vencer: UILabel!
    @IBOutlet weak var status: UIImageView!
    
}
