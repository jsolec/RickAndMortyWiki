//
//  CharacterDetailViewController.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 24/4/22.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    
    private var characterViewModel: CharacterDetailViewModelInterface
    private var loading = LoadingView()
    
    required init(characterViewModel: CharacterDetailViewModelInterface) {
        self.characterViewModel = characterViewModel
        super.init(nibName: "CharacterDetailViewController", bundle: .main)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Disallowed the usage of this init.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clear()
        self.characterViewModel.onCharacterRetrieved = self.updateUI
        self.characterViewModel.onLoadingStatusChanged = { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.loading.show(in: self.view)
            } else {
                self.loading.hide()
            }
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.characterViewModel.getCharacterInfo()
    }
    
    private func updateUI(character: CharacterDetailViewData) {
        if let url = character.imageURL {
            self.imageView.load(url: url)
        }
        
        self.nameLabel.text = character.name
        self.statusLabel.text = character.status
    }
    
    private func clear() {
        self.imageView.image = nil
        self.nameLabel.text = nil
        self.statusLabel.text = nil
    }
}
