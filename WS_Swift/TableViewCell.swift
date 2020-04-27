//
//  TableViewCell.swift
//  WS_Swift
//
//  Created by Labdesarrollo5 on 26/04/20.
//  Copyright © 2020 Labdesarrollo5. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var subTitulo: UILabel!
    @IBOutlet weak var Titulo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
