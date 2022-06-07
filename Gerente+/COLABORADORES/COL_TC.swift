//
//  COL_TC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 02/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class COL_TC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var colaborador: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var codigo: UILabel!
    @IBOutlet weak var celular: UILabel!
    @IBOutlet weak var fixo: UILabel!
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var seq: UILabel!
    
}
