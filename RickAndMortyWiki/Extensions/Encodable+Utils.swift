//
//  Encodable+Utils.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
    
    func asQueryItems() throws -> [URLQueryItem]? {
        try self.asDictionary()?.compactMap({ URLQueryItem(name: $0.key, value: String(describing: $0.value)) }).sorted { $0.name < $1.name }
    }
}
