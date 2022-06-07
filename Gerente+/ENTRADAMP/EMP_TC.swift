//
//  EMP_TC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 03/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class EMP_TC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var user: UIImageView!
    @IBOutlet weak var produto: UILabel!
    @IBOutlet weak var quantidade: UILabel!
    @IBOutlet weak var seq: UILabel!
    @IBOutlet weak var dEntrada: UILabel!
    @IBOutlet weak var dValidade: UILabel!
    @IBOutlet weak var lote: UILabel!
    @IBOutlet weak var Barcode: UILabel!
    @IBOutlet weak var armazenagem: UILabel!
    @IBOutlet weak var prodProp: UILabel!
    @IBOutlet weak var prodOrg: UILabel!
    @IBOutlet weak var statusProdProp: UIImageView!
    @IBOutlet weak var statusNfe: UIImageView!
    
    

}
