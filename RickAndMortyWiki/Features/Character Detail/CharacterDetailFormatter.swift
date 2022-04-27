//
//  CharacterDetailFormatter.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 24/4/22.
//

import Foundation

class CharacterDetailFormatter {
    func prepareCharacterDetailViewModel(character: CharacterDetailResponse) -> CharacterDetailViewData {
        
        var imageURL: URL? = nil
        if let url = character.imageUrl {
            imageURL = URL(string: url)
        }
        
        return CharacterDetailViewData(
            name: character.name,
            status: "\(L10n.CharacterDetailView.status) \(character.status.title)",
            species: "\(L10n.CharacterDetailView.species) \(self.unwrapContent(character.species))",
            gender: "\(L10n.CharacterDetailView.gender) \(character.gender.rawValue)",
            origin: "\(L10n.CharacterDetailView.origin) \(self.buildLocation(character.origin))",
            location: "\(L10n.CharacterDetailView.currentLocation) \(self.buildLocation(character.location))",
            imageURL: imageURL
        )
    }
    
    private func unwrapContent(_ content: String?) -> String {
        content ?? L10n.General.unknown
    }
    
    private func buildLocation(_ location: LocationResponse) -> String {
        String(format: L10n.CharacterDetailView.locationFormat, location.name, location.dimension)
    }
}


