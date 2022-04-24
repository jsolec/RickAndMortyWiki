//
//  CharacterDataFetcher.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 24/4/22.
//

import Foundation

class CharacterDataFetcher {
    
    struct Dependencies {
        let networkService: ApolloNetworkService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func getCharacterBy(id: Int, completion: @escaping ((Result<CharacterDetailResponse?, Error>) -> ())) {
        
        self.dependencies.networkService.client.fetch(query: GetCharacterByIdQuery(id: String(id)), queue: .main, resultHandler: { result in
            switch result {
            case .success(let response):
                guard let character = response.data?.character,
                      let characterId = character.id,
                      let id = Int(characterId),
                      let name = character.name else {
                    completion(.success(nil))
                    return
                }
                
                let characterResponse = CharacterDetailResponse(
                    id: id,
                    name: name,
                    status: character.status,
                    imageUrl: character.image
                )
                
                completion(.success(characterResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
