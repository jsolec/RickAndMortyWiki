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
        case imageUrl = "image"
    }
    
    let id: Int
    let name: String
    let status: String?
    let imageUrl: String?
}
