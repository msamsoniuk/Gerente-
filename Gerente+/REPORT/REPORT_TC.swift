//
//  REPORT_TC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 25/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class REPORT_TC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var colaborador: UIImageView!
   // @IBOutlet weak var tarefa: UILabel!
    @IBOutlet weak var codigo: UILabel!
    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var escrito: UIImageView!
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var status: UIImageView!
    
    @IBOutlet weak var DiasVencer: UILabel!
    @IBOutlet weak var NCouC: UILabel!
}
