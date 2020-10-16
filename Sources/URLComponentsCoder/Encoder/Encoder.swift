//
//  Encoder.swift
//  URLComponentsCoder
//
//  Created by Dmitry Lobanov on 14.10.2020.
//

import Foundation
import Combine

fileprivate typealias Namespace = TopLevel.URLComponents

public extension Namespace {
    class Encoder {
        public init() {}
        
        public var userInfo: [CodingUserInfoKey : Any] = [:]
    }
}

extension Namespace.Encoder: TopLevelEncoder {
    public func encode<T>(_ value: T) throws -> [URLQueryItem] where T : Encodable {
        let encoder = _Encoder()
        encoder.userInfo = self.userInfo
        try value.encode(to: encoder)
        return encoder.data
    }
}

extension Namespace.Encoder {
    final class _Encoder {
        var codingPath: [CodingKey] = []
        
        var userInfo: [CodingUserInfoKey : Any] = [:]
        
        fileprivate var container: URLComponentsEncodingContainer?
    }
}

extension Namespace.Encoder._Encoder: Encoder {
    fileprivate func assertCanCreateContainer() {
        precondition(self.container == nil)
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        assertCanCreateContainer()
        
        let container = KeyedContainer<Key>(codingPath: self.codingPath, userInfo: self.userInfo)
        self.container = container
        
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        assertCanCreateContainer()
        
        let container = UnkeyedContainer(codingPath: self.codingPath, userInfo: self.userInfo)
        self.container = container
        
        return container
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        assertCanCreateContainer()
        
        let container = SingleValueContainer(codingPath: self.codingPath, userInfo: self.userInfo)
        self.container = container
        
        return container
    }
}

extension Namespace.Encoder._Encoder {
    typealias AnyCodingKey = TopLevel.URLComponents.AnyCodingKey
}

protocol URLComponentsEncodingContainer: class {
    // We are encoding, so, our result is URLComponents or, specifically, [URRQueryItem]
    var data: [URLQueryItem] { get }
}

extension Namespace.Encoder._Encoder: URLComponentsEncodingContainer {
    var data: [URLQueryItem] {
        self.container?.data ?? []
    }
}
