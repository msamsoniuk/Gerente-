//
//  TC_MP.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 27/09/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class TC_MP: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var produto: UILabel!
    @IBOutlet weak var seq: UILabel!
    
    @IBOutlet weak var unidade: UILabel!
    @IBOutlet weak var validade: UILabel!
    @IBOutlet weak var val_tipo: UILabel!
    @IBOutlet weak var tempArmazenagem: UILabel!
    @IBOutlet weak var armazenagem: UILabel!
    @IBOutlet weak var pPropria: UILabel!
    @IBOutlet weak var pOrganico: UILabel!
    @IBOutlet weak var colaborador: UIImageView!
    @IBOutlet weak var data: UILabel!
    
    
}
