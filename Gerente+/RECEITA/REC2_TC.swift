//
//  REC2_TC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 17/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class REC2_TC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var fotoColaborador: UIImageView!
    @IBOutlet weak var receita: UILabel!
    @IBOutlet weak var dataReceita: UILabel!
    @IBOutlet weak var rendimento: UILabel!
    @IBOutlet weak var TemFoto: UIImageView!
    @IBOutlet weak var TemRec: UIImageView!
    
}
