//
//  Decoder.swift
//  URLComponentsCoder
//
//  Created by Dmitry Lobanov on 14.10.2020.
//

import Foundation
import Combine

fileprivate typealias Namespace = TopLevel.URLComponents

public extension Namespace {
    class Decoder {
        public init() {}
        internal var codingPath: [CodingKey] = []
        public var userInfo: [CodingUserInfoKey : Any] = [:]
    }
}

extension Namespace.Decoder: TopLevelDecoder {
    public func decode<T>(_ type: T.Type, from: [URLQueryItem]) throws -> T where T : Decodable {
        let decoder = _Decoder(data: from)
        decoder.codingPath = self.codingPath
        return try T(from: decoder)
    }
}

extension Namespace.Decoder {
    final class _Decoder {
        var codingPath: [CodingKey] = []
        
        var userInfo: [CodingUserInfoKey : Any] = [:]
        
        var container: URLComponentsDecodingContainer?
        
        var data: [URLQueryItem] = []
        
        init(data: [URLQueryItem]) {
            self.data = data
        }
    }
}

extension Namespace.Decoder._Decoder {
    fileprivate func assertCanCreateContainer() {
        precondition(self.container == nil)
    }
}

extension Namespace.Decoder._Decoder: Decoder {
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        self.assertCanCreateContainer()
        
        let container = KeyedContainer<Key>(data: self.data, codingPath: self.codingPath, userInfo: self.userInfo)
        self.container = container

        return KeyedDecodingContainer(container)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        self.assertCanCreateContainer()
        
        let container = UnkeyedContainer(data: self.data, codingPath: self.codingPath, userInfo: self.userInfo)
        self.container = container

        return container
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        self.assertCanCreateContainer()
        
        let container = SingleValueContainer(data: self.data, codingPath: self.codingPath, userInfo: self.userInfo)
        self.container = container
        
        return container
    }
}
