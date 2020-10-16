//
//  UnkeyedDecodingContainer.swift
//  URLComponentsCoder
//
//  Created by Dmitry Lobanov on 15.10.2020.
//

import Foundation

fileprivate typealias Namespace = TopLevel.URLComponents.Decoder._Decoder

extension Namespace {
    final class UnkeyedContainer {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        var data: [URLQueryItem] = []
        
        var currentIndex: Int = 0
        var nestedContainers: [URLComponentsDecodingContainer] = []
        var count: Int? { self.nestedContainers.count }
        var isAtEnd: Bool {
            guard let count = self.count else {
                return true
            }
            return self.currentIndex >= count
        }
        
        init(data: [URLQueryItem], codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.data = data
            self.codingPath = codingPath
            self.userInfo = userInfo
        }
    }
}

// MARK: Append
extension Namespace.UnkeyedContainer {
    private func append(_ item: URLQueryItem) {
        let index = self.currentIndex
        let nestedCodingPath: [CodingKey] = self.codingPath + [Namespace.AnyCodingKey(intValue: index)!]
        self.nestedContainers.append(Namespace.SingleValueContainer(data: self.data, codingPath: nestedCodingPath, userInfo: self.userInfo))
        self.currentIndex += 1
    }
    func process() {
        if (self.codingPath.isEmpty) {
            /// Match all keys
            self.data.forEach(self.append(_:))
        }
        else {
            let prefix = self.codingPath.map(Namespace.CodingPathConverter.init).map(\.stringValue).joined(separator: ".")
            self.data.filter({$0.name.hasPrefix(prefix)}).forEach(self.append(_:))
        }
    }
}


// MARK: Check
extension Namespace.UnkeyedContainer {
    func checkCanDecodeValue() throws {
        guard !self.isAtEnd else {
            throw DecodingError.dataCorruptedError(in: self, debugDescription: "Unexpected end of data")
        }
    }
}

// MARK: UnkeyedDecodingContainer
extension Namespace.UnkeyedContainer: UnkeyedDecodingContainer {
    func decodeNil() throws -> Bool {
        try checkCanDecodeValue()
        defer { self.currentIndex += 1 }
        
        let nestedContainer = self.nestedContainers[self.currentIndex]
        
        switch nestedContainer {
        case let singleValueContainer as Namespace.SingleValueContainer:
            return singleValueContainer.decodeNil()
        case is Namespace.UnkeyedContainer,
             is Namespace.KeyedContainer<Namespace.AnyCodingKey>:
            return false
        default:
            let context = DecodingError.Context(codingPath: self.codingPath, debugDescription: "Cannot decode nil for index: \(self.currentIndex)")
            throw DecodingError.typeMismatch(Any?.self, context)
        }
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        try checkCanDecodeValue()
        defer { self.currentIndex += 1 }
        
        let container = self.nestedContainers[self.currentIndex]
        let decoder = TopLevel.AliasesMap.Decoder()
        let value = try decoder.decode(T.self, from: container.data)

        return value
    }
    
    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        try checkCanDecodeValue()
        defer { self.currentIndex += 1 }
        
        let container = self.nestedContainers[self.currentIndex] as! Namespace.UnkeyedContainer
        
        return container
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        try self.checkCanDecodeValue()
        defer { self.currentIndex += 1 }

        let container = self.nestedContainers[self.currentIndex] as! Namespace.KeyedContainer<NestedKey>
        
        return KeyedDecodingContainer(container)

    }

    func superDecoder() throws -> Decoder {
        Namespace.init(data: self.data)
    }
}

extension Namespace.UnkeyedContainer: URLComponentsDecodingContainer {}
