//
//  ListadoReservaTableViewCell.swift
//  AppiReserva
//
//  Created by Johann Stig Gravenhorst R. on 12/28/15.
//  Copyright © 2015 Olonte Apps. All rights reserved.
//

import UIKit

class ListadoReservaTableViewCell: UITableViewCell {

    @IBOutlet weak var labelRecurso: UILabel!
    @IBOutlet weak var labelFechaReserva: UILabel!
    @IBOutlet weak var buttonEditar: UIButton!
    @IBOutlet weak var buttonEliminar: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
