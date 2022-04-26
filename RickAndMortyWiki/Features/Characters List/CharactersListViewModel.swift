//
//  CharactersListViewModel.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import UIKit

protocol CharactersListViewModelInterface: AnyObject {
    var onCharactersRetrieved: (([CharacterListInfoViewData]) -> Void)! { get set }
    var onCharactersError: ((String) -> Void)! { get set }
    var onLoadingStatusChanged: ((Bool) -> Void)!  { get set }
    var navigationTitle: String  { get }
    
    func getCharacters()
}

class CharactersListViewModel: CharactersListViewModelInterface {
    
    struct Dependencies {
        let characterDataFetcher: AllCharactersDataFetcherInterface
        let formatter: CharacterListFormatter
    }
    
    private let dependencies: Dependencies
    private var searchText: String? = nil
    private var nextPage: Int = 0
    private var totalPages: Int = 0
    
    var onCharactersRetrieved: (([CharacterListInfoViewData]) -> Void)!
    var onCharactersError: ((String) -> Void)!
    var onLoadingStatusChanged: ((Bool) -> Void)!
    
    let navigationTitle: String = L10n.CharactersListView.title
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func getCharacters() {
        guard self.nextPage <= self.totalPages else { return }
        self.onLoadingStatusChanged(true)
        
        self.dependencies.characterDataFetcher.getCharacters(page: self.nextPage) { [weak self] result in
            guard let self = self else { return }
            self.onLoadingStatusChanged(false)
            switch result {
            case .success(let response):
                self.totalPages = response.info.pages
                self.nextPage = response.info.next
                let charactersViewModel = self.dependencies.formatter.prepareCharactersViewModel(characters: response.results)
                self.onCharactersRetrieved(charactersViewModel)
            case .failure(let error):
                self.onCharactersError(error.localizedDescription)
            }
        }
    }
}

