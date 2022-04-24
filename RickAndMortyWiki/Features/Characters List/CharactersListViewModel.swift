//
//  CharactersListViewModel.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import UIKit

class CharactersListViewModel {
    
    struct Dependencies {
        let characterDataFetcher: AllCharactersDataFetcher
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
            self?.onLoadingStatusChanged(false)
            switch result {
            case .success(let response):
                self?.convertCharactersToViewModel(characters: response)
            case .failure:
                break
            }
        }
    }
    
    private func convertCharactersToViewModel(characters: [CharacterInfoResponse]) {
        let charactersViewModel: [CharacterListInfoViewData] = characters.compactMap({
            var url: URL? = nil
            
            if let image = $0.imageUrl {
                url = URL(string: image)
            }
            
            return CharacterListInfoViewData(
                id: $0.id,
                name: $0.name,
                thumbnailUrl: url
            )
        })
        
        self.onCharactersRetrieved(charactersViewModel)
    }
}

