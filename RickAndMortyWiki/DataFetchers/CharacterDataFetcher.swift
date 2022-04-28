//
//  CharacterDataFetcher.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 24/4/22.
//

import Foundation

protocol CharacterDataFetcherInterface: AnyObject {
    func getCharacterBy(id: Int, completion: @escaping ((Result<CharacterDetailResponse, Error>) -> ()))
}

class CharacterDataFetcher: CharacterDataFetcherInterface {
    
    struct Dependencies {
        let networkService: ApolloNetworkService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func getCharacterBy(id: Int, completion: @escaping ((Result<CharacterDetailResponse, Error>) -> ())) {
        
        self.dependencies.networkService.client.fetch(query: GetCharacterByIdQuery(id: String(id)), queue: .main, resultHandler: { result in
            switch result {
            case .success(let response):
                guard let character = response.data?.character,
                      let characterId = character.id,
                      let id = Int(characterId),
                      let name = character.name else {
                    let context = DecodingError.Context(codingPath: [], debugDescription: "Missing important data to parse")
                    completion(.failure(DecodingError.valueNotFound(CharacterDetailResponse.self, context)))
                    return
                }
                
                let characterResponse = CharacterDetailResponse(
                    id: id,
                    name: name,
                    status: CharacterStatus(rawValue: character.status ?? "") ?? .unknown,
                    species: character.species,
                    type: character.type,
                    gender: CharacterGender(rawValue: character.gender ?? "") ?? .unknown,
                    imageUrl: character.image,
                    origin: .init(
                        name: character.origin?.name ?? "",
                        dimension: character.origin?.dimension ?? ""
                    ),
                    location: .init(
                        name: character.location?.name ?? "",
                        dimension: character.location?.dimension ?? ""
                    )
                )
                
                completion(.success(characterResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
