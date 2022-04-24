//
//  CharacterListFormatter.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 24/4/22.
//

import Foundation

class CharacterListFormatter {

    func prepareCharactersViewModel(characters: [CharacterInfoResponse]) -> [CharacterListInfoViewData] {
        return characters.compactMap({
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
    }
}
