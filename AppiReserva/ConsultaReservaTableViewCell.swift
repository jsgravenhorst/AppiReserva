//
//  ConsultaReservaTableViewCell.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 1/26/16.
//  Copyright © 2016 Olonte Apps. All rights reserved.
//

import UIKit

class ConsultaReservaTableViewCell: UITableViewCell {
    
  
    @IBOutlet weak var nombreRecursoLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var horaInicialReservaLabel: UILabel!
    @IBOutlet weak var horaFinalReservaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
