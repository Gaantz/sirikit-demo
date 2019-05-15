//
//  DemoKeyChain.swift
//  Demo
//
//  Created by Cristian on 4/18/19.
//  Copyright © 2019 Cristian Palomino. All rights reserved.
//

import Security

public protocol CredentialsProtocol {
    
    var credentials: Credentials? { get }
    func save(_ credentials: Credentials)
    func delete()
    
}

extension Session: CredentialsProtocol {
    
    public var credentials: Credentials? {
        return try? DemoKeychain.readCredentials()
    }
    
    public func save(_ credentials: Credentials) {
        try? DemoKeychain.save(credentials)
    }
    
    
    public func delete() {
        try? DemoKeychain.delete()
    }
}

public struct Credentials {
    
    public let doi: String
    public let password: String

    public init(doi: String, password: String) {
        self.doi = doi
        self.password = password
    }

}

public struct DemoKeychain {

    static let server: String = "www.demo.com"
    
    enum KeychainError: Error {
        
        case noPassword
        case unexpectedPasswordData
        case unhandledError(_ status: OSStatus)
        
    }
    
    public static func readCredentials() throws -> Credentials {
        let query: [String: Any?] = [kSecClass as String: kSecClassInternetPassword,
                                     kSecAttrServer as String: DemoKeychain.server,
                                     kSecMatchLimit as String: kSecMatchLimitOne,
                                     kSecReturnAttributes as String: true,
                                     kSecReturnData as String: true]
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status) }
        guard
            let dic = result as? [String: Any?],
            let doi = dic[kSecAttrAccount as String] as? String,
            let passwordData = dic[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
        else { throw KeychainError.unexpectedPasswordData }
        return Credentials(doi: doi, password: password)
    }
    
    public static func save(_ credentials: Credentials) throws {
        do {
            try _ = DemoKeychain.readCredentials()
            let query: [String: Any?] = [kSecClass as String: kSecClassInternetPassword,
                                         kSecAttrServer as String: DemoKeychain.server]
            let dic: [String: Any?] = [kSecAttrAccount as String: credentials.doi,
                                       kSecValueData as String: credentials.password.data(using: .utf8)!]
            let status = SecItemUpdate(query as CFDictionary, dic as CFDictionary)
            guard status == noErr else { throw KeychainError.unhandledError(status) }
        }
        catch KeychainError.noPassword {
            let query: [String: Any?] = [kSecClass as String: kSecClassInternetPassword,
                                         kSecAttrServer as String: DemoKeychain.server,
                                         kSecAttrAccount as String: credentials.doi,
                                         kSecValueData as String: credentials.password.data(using: .utf8)!]
            var result: CFTypeRef?
            let status = SecItemAdd(query as CFDictionary, &result)
            guard status == noErr else { throw KeychainError.unhandledError(status) }
        }
    }
    
    public static func delete() throws {
        let query: [String: Any?] = [kSecClass as String: kSecClassInternetPassword,
                                     kSecAttrServer as String: DemoKeychain.server]
        let status = SecItemDelete(query as CFDictionary)
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status) }
    }
    
}
