//
//  CharacterListCell.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import UIKit

class CharacterListCell: UITableViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureStyle()
    }
    
    override func prepareForReuse() {
        self.thumbnailImageView.image = nil
        self.nameLabel.text = nil
    }
    
    func configure(viewData: CharacterListInfoViewData) {
        if let url = viewData.thumbnailUrl {
            self.thumbnailImageView.load(url: url)
        } else {
            self.thumbnailImageView.image = nil
        }
        self.nameLabel.text = viewData.name
    }
    
    func configureStyle() {
        self.thumbnailImageView.clipsToBounds = true
        self.thumbnailImageView.layer.cornerRadius = self.thumbnailImageView.frame.height / 2
    }
}
