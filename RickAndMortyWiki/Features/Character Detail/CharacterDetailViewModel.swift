//
//  CharacterDetailViewModel.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 24/4/22.
//

import Foundation

protocol CharacterDetailViewModelInterface: AnyObject {
    var onCharacterRetrieved: ((CharacterDetailViewData) -> Void)! { get set }
    var onCharacterError: ((String) -> Void)! { get set }
    var onLoadingStatusChanged: ((Bool) -> Void)! { get set }
    var navigationTitle: String { get }
    
    func getCharacterInfo()
}

class CharacterDetailViewModel: CharacterDetailViewModelInterface {
    
    struct Dependencies {
        let characterDataFetcher: CharacterDataFetcherInterface
        let formatter: CharacterDetailFormatter
    }
    
    var onCharacterRetrieved: ((CharacterDetailViewData) -> Void)!
    var onCharacterError: ((String) -> Void)!
    var onLoadingStatusChanged: ((Bool) -> Void)!
    
    let navigationTitle: String = L10n.CharactersListView.title
    
    private let dependencies: Dependencies
    private let characterId: Int
    
    init(dependencies: Dependencies, characterId: Int) {
        self.dependencies = dependencies
        self.characterId = characterId
    }
    
    func getCharacterInfo() {
        self.onLoadingStatusChanged(true)
        self.dependencies.characterDataFetcher.getCharacterBy(id: self.characterId) { [weak self] response in
            guard let self = self else { return }
            self.onLoadingStatusChanged(false)
            switch response {
            case .success(let response):
                let characterViewModel = self.dependencies.formatter.prepareCharacterDetailViewModel(character: response)
                self.onCharacterRetrieved(characterViewModel)
            case .failure(let error):
                self.onCharacterError(error.localizedDescription)
            }
        }
    }
}
