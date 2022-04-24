//
//  CharactersListViewModel.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import UIKit

protocol CharactersListViewModelInterface {
    var onCharactersRetrieved: (([CharacterListInfoViewData]) -> Void)! { get set }
    var onLoadingStatusChanged: ((Bool) -> Void)!  { get set }
    var navigationTitle: String  { get }
    
    func getCharacters()
}

class CharactersListViewModel: CharactersListViewModelInterface {
    
    struct Dependencies {
        let characterDataFetcher: AllCharactersDataFetcher
        let formatter: CharacterListFormatter
    }
    
    private let dependencies: Dependencies
    private var searchText: String? = nil
    
    var onCharactersRetrieved: (([CharacterListInfoViewData]) -> Void)!
    var onLoadingStatusChanged: ((Bool) -> Void)!
    
    let navigationTitle: String = L10n.CharactersListView.title
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func getCharacters() {
        
        self.onLoadingStatusChanged(true)
        
        self.dependencies.characterDataFetcher.getCharacters { [weak self] result in
            guard let self = self else { return }
            self.onLoadingStatusChanged(false)
            switch result {
            case .success(let response):
                let charactersViewModel = self.dependencies.formatter.prepareCharactersViewModel(characters: response)
                self.onCharactersRetrieved(charactersViewModel)
            case .failure:
                break
            }
        }
    }
}

