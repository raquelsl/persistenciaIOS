//
//  GameTableViewCell.swift
//  MyGames
//
//  Created by aluno on 16/05/21.
//  Copyright © 2021 raquel. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbConsole: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func prepare(with game: Game) {
    lbTitle.text = game.title ?? ""
    lbConsole.text = game.console?.name ?? ""
    if let image = game.cover as? UIImage {
    ivCover.image = image
    } else {
    ivCover.image = UIImage(named: "noCover")
    }
    }

}
