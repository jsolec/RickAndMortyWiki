//
//  CharacterModel.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import Foundation

struct CharacterListRequest: Encodable {
    enum CodingKeys: String, CodingKey {
        case page
    }
    
    let page: Int
}

struct CharacterListResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case info
        case results
    }
    
    let info: CharacterPaginationInfoResponse
    let results: [CharacterInfoResponse]
}

struct CharacterPaginationInfoResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case pages
        case next
    }
    let pages: Int
    let next: Int
}

struct CharacterInfoResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image"
    }
    
    let id: Int
    let name: String
    let imageUrl: String?
}

struct CharacterDetailResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case type
        case gender
        case imageUrl = "image"
        case origin
        case location
    }
    
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String?
    let type: String?
    let gender: CharacterGender
    let imageUrl: String?
    let origin: LocationResponse
    let location: LocationResponse
}

enum CharacterStatus: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown
    
    var title: String {
        switch self {
        case .alive: return L10n.General.statusAlive
        case .dead: return L10n.General.statusDead
        case .unknown: return L10n.General.unknown
        }
    }
}

enum CharacterGender: String, Decodable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown
    
    var title: String {
        switch self {
        case .female: return L10n.General.genderFemale
        case .male: return L10n.General.genderMale
        case .genderless: return L10n.General.genderGenderless
        case .unknown: return L10n.General.unknown
        }
    }
}

struct LocationResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case dimension
    }
    
    let name: String
    let dimension: String
}
