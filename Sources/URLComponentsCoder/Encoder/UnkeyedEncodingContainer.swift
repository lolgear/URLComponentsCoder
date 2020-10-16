//
//  UnkeyedEncodingContainer.swift
//  URLComponentsCoder
//
//  Created by Dmitry Lobanov on 14.10.2020.
//

import Foundation

fileprivate typealias Namespace = TopLevel.URLComponents.Encoder._Encoder

extension Namespace {
    final class UnkeyedContainer {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        private var storage: [URLComponentsEncodingContainer] = []
        
        var nestedCodingPath: [CodingKey] {
            self.codingPath + [AnyCodingKey(intValue: self.count)!]
        }
        
        init(codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
        }
    }
}

private extension Namespace.UnkeyedContainer {
    private func nestedSingleValueContainer() -> SingleValueEncodingContainer {
        let container = Namespace.SingleValueContainer(codingPath: self.nestedCodingPath, userInfo: self.userInfo)
        return container
    }
}

extension Namespace.UnkeyedContainer: UnkeyedEncodingContainer {
    var count: Int {
        self.storage.count
    }
    
    func encodeNil() throws {
        var container = self.nestedSingleValueContainer()
        try container.encodeNil()
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        var container = self.nestedSingleValueContainer()
        try container.encode(value)
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        let container = Namespace.KeyedContainer<NestedKey>(codingPath: self.nestedCodingPath, userInfo: self.userInfo)
        self.storage.append(container)
        
        return KeyedEncodingContainer(container)
    }
    
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let container = Namespace.UnkeyedContainer(codingPath: self.nestedCodingPath, userInfo: self.userInfo)
        self.storage.append(container)
        
        return container
    }
    
    func superEncoder() -> Encoder {
        // TODO: Add implementation
        fatalError("Unimplemented")
    }
}

extension Namespace.UnkeyedContainer: URLComponentsEncodingContainer {
    var data: [URLQueryItem] {
        var result: [URLQueryItem] = .init()
        for (_, value) in self.storage.enumerated() {
            result.append(contentsOf: value.data)
        }
        return result
    }
}
