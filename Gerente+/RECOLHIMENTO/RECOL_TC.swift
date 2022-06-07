//
//  RECOL_TC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 21/11/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class RECOL_TC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var imgColaborador: UIImageView!
    @IBOutlet weak var imgContaminado: UIImageView!
    @IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var imgTexto: UIImageView!
    @IBOutlet weak var produto: UILabel!
    @IBOutlet weak var reclamante: UILabel!
    @IBOutlet weak var emailReclamante: UILabel!
    @IBOutlet weak var dataFab: UILabel!
    @IBOutlet weak var dataReclam: UILabel!
    @IBOutlet weak var dataAmostra: UILabel!
    @IBOutlet weak var contaminado: UILabel!
    
}
