//
//  AllCharactersDataFetcher.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 24/4/22.
//

import Foundation

protocol AllCharactersDataFetcherInterface: AnyObject {
    func getCharacters(page: Int, completion: @escaping ((Result<CharacterListResponse, Error>) -> ()))
}

class AllCharactersDataFetcher: AllCharactersDataFetcherInterface {
    
    struct Dependencies {
        let networkService: ApolloNetworkService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func getCharacters(page: Int, completion: @escaping ((Result<CharacterListResponse, Error>) -> ())) {
        
        self.dependencies.networkService.client.fetch(query: AllCharactersQuery(page: page), queue: .main, resultHandler: { result in
            switch result {
            case .success(let response):
                
                let characters: [CharacterInfoResponse] = response.data?.characters?.results?.compactMap { character in
                    guard let characterId = character?.id,
                          let id = Int(characterId),
                          let name = character?.name else { return nil }
                          
                    return CharacterInfoResponse(
                        id: id,
                        name: name,
                        imageUrl: character?.image
                    )
                } ?? []
                
                let result = CharacterListResponse(
                    info: .init(pages: response.data?.characters?.info?.pages ?? 0, next: response.data?.characters?.info?.next ?? 0),
                    results: characters
                )
                
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
