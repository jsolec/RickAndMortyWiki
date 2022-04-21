//
//  KeychainService.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import Foundation
import Security

enum Keys {
    case token
}

extension Keys {
    func getRaw() -> String {
        guard let identifier = Bundle.main.bundleIdentifier else { preconditionFailure("Bundle identifier shouldn't be nil") }
        switch self {
        case .token:
            return identifier + ".token"
        }
    }
}

protocol CredentialsService {
    func remove(key: Keys) -> Bool
    func data(key: Keys) -> Data?
    func string(key: Keys) -> String?
    func set(key: Keys, value: String) -> Bool
    func set(key: Keys, value: Data) -> Bool
}

class KeychainService: CredentialsService {
    private func save(key: Keys, data: Data) -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key.getRaw(),
                                    kSecValueData as String: data,
                                    kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }

    private func load(key: Keys) -> Data? {
        let getquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: key.getRaw(),
                                       kSecMatchLimit as String: kSecMatchLimitOne,
                                       kSecReturnData as String: true]
        var item: CFTypeRef?

        SecItemCopyMatching(getquery as CFDictionary, &item)
        guard let data = item as? Data else { return nil }
        return data
    }
    
    @discardableResult
    func remove(key: Keys) -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key.getRaw(),
                                    kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked]

        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
    
    func data(key: Keys) -> Data? {
        load(key: key)
    }
    
    func string(key: Keys) -> String? {
        guard let data = load(key: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func set(key: Keys, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        return save(key: key, data: data)
    }
    
    func set(key: Keys, value: Data) -> Bool {
        return save(key: key, data: value)
    }
}
