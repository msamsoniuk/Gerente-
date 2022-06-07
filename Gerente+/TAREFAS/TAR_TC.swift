//
//  TAR_TC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 18/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class TAR_TC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        barra.transform = CGAffineTransform(scaleX: 1, y: 3)
    }
    @IBOutlet weak var DoListSub: UILabel!
    @IBOutlet weak var SeqTarefa: UILabel!
    @IBOutlet weak var Colaborador: UIImageView!
    @IBOutlet weak var Data: UILabel!
    @IBOutlet weak var Status: UIImageView!
    @IBOutlet weak var view_tarefas: UIView!
    @IBOutlet weak var barra: UIProgressView!
    
}
