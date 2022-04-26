//
//  CharacterListCell.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import UIKit

class CharacterListCell: UITableViewCell {
    private var thumbnailImageView = UIImageView()
    private var nameLabel = UILabel()
    
    private let imageHeight: CGFloat = 60
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.thumbnailImageView.clipsToBounds = true
        self.thumbnailImageView.layer.cornerRadius = self.imageHeight / 2
        
        let stackView = UIStackView(arrangedSubviews: [self.thumbnailImageView, self.nameLabel])
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        stackView.isUserInteractionEnabled = false
        stackView.spacing = 10
        contentView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.thumbnailImageView.widthAnchor.constraint(equalToConstant: self.imageHeight),
            self.thumbnailImageView.heightAnchor.constraint(equalTo: self.thumbnailImageView.widthAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
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
}
