//
//  CharactersListViewModel.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import UIKit

class CharactersListViewModel {
    
    struct Dependencies {
    }
    
    private let dependencies: Dependencies
    private var searchText: String? = nil
    
    var onCharactersRetrieved: (([CharacterListInfoViewData]) -> Void)!
    var onLoadingStatusChanged: ((Bool) -> Void)!
    
    let navigationTitle: String = L10n.CharactersListView.title
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

