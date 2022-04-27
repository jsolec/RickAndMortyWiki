//
//  CharacterDetailViewController.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 24/4/22.
//

import UIKit

class CharacterDetailViewController: UIViewController, CanPresentAlerts {

    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let statusLabel = UILabel()
    private let genderLabel = UILabel()
    private let speciesLabel = UILabel()
    private let originLabel = UILabel()
    private let locationLabel = UILabel()
    
    private var characterViewModel: CharacterDetailViewModelInterface
    private var loading = LoadingView()
    
    required init(characterViewModel: CharacterDetailViewModelInterface) {
        self.characterViewModel = characterViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Disallowed the usage of this init.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.clear()
        
        self.characterViewModel.onCharacterRetrieved = self.updateUI
        
        self.characterViewModel.onCharacterError = { [weak self] error in
            self?.presentInfoAlert(title: L10n.General.errorTitle, message: error, dismissTitle: L10n.General.ok)
        }
        
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
    
    private func setupView() {
        self.view.subviews.forEach { $0.removeFromSuperview() }
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollView)
        self.nameLabel.font = .preferredFont(forTextStyle: .largeTitle, compatibleWith: nil)
        
        let contentStack = UIStackView(arrangedSubviews: [
            self.nameLabel,
            self.statusLabel,
            self.genderLabel,
            self.speciesLabel,
            self.originLabel,
            self.locationLabel
        ])
        
        contentStack.spacing = 3
        contentStack.axis = .vertical
        contentStack.alignment = .fill
        contentStack.distribution = .fill
        
        let vStack = UIStackView(arrangedSubviews: [self.imageView, contentStack])
        vStack.spacing = 10
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fill
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            vStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            vStack.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor)
        ])
    }
    
    private func updateUI(character: CharacterDetailViewData) {
        if let url = character.imageURL {
            self.imageView.load(url: url)
        }
        
        self.nameLabel.text = character.name
        self.statusLabel.text = character.status
        self.genderLabel.text = character.gender
        self.speciesLabel.text = character.species
        self.originLabel.text = character.origin
        self.locationLabel.text = character.location
    }
    
    private func clear() {
        self.imageView.image = nil
        self.nameLabel.text = nil
        self.statusLabel.text = nil
        self.genderLabel.text = nil
        self.speciesLabel.text = nil
        self.originLabel.text = nil
        self.locationLabel.text = nil
    }
}
