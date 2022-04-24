//
//  CharacterDetailViewController.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 24/4/22.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    @IBOutlet private weak var imageViewController: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
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

        // Do any additional setup after loading the view.
    }
}
