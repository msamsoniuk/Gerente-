//
//  EXP_TC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 06/11/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class EXP_TC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var receita: UILabel!
    @IBOutlet weak var lote: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var validade: UILabel!
    @IBOutlet weak var quantidade: UILabel!
    @IBOutlet weak var valor: UILabel!
    @IBOutlet weak var colaborador: UIImageView!
    @IBOutlet weak var quebra: UILabel!
    

}
