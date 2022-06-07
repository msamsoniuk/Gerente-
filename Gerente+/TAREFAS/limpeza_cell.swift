//
//  limpeza_cell.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 11/09/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit


class limpeza_cell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var tarefa: UILabel!
    
    @IBOutlet weak var SeqTarefa: UILabel!
    @IBOutlet weak var data: UILabel!
    
    @IBOutlet weak var status8: UIImageView!
    @IBOutlet weak var status7: UIImageView!
    
    @IBOutlet weak var status6: UIImageView!
    @IBOutlet weak var status5: UIImageView!
    @IBOutlet weak var status4: UIImageView!
    @IBOutlet weak var status3: UIImageView!
    @IBOutlet weak var status2: UIImageView!
    @IBOutlet weak var status1: UIImageView!
    
    // itens
    @IBOutlet weak var itemStatus: UIImageView!
    @IBOutlet weak var itemPerson: UIImageView!
    
    
}

