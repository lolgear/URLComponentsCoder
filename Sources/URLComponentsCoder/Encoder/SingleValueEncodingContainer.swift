//
//  SingleValueEncodingContainer.swift
//  URLComponentsCoder
//
//  Created by Dmitry Lobanov on 14.10.2020.
//

import Foundation

fileprivate typealias Namespace = TopLevel.URLComponents.Encoder._Encoder

extension Namespace {
    final class SingleValueContainer {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        private var storage: [URLQueryItem] = []
        
        var currentCodingKeyString: String {
            self.codingPath.map(\.stringValue).joined(separator: ".")
        }
        
        init(codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
        }
    }
}

extension Namespace.SingleValueContainer: SingleValueEncodingContainer {
    func encodeNil() throws {
        self.storage.append(.init(name: "", value: "nil"))
    }
    
    func encode(_ value: Bool) throws {
        self.storage.append(.init(name: self.currentCodingKeyString, value: .init(value)))
    }
    
    func encode(_ value: String) throws {
        self.storage.append(.init(name: self.currentCodingKeyString, value: value))
    }
    
    func encode(_ value: Double) throws {
        self.storage.append(.init(name: self.currentCodingKeyString, value: .init(value)))
    }
    
    func encode(_ value: Float) throws {
        self.storage.append(.init(name: self.currentCodingKeyString, value: .init(value)))
    }
    
    func encode(_ value: Int) throws {
        self.storage.append(.init(name: self.currentCodingKeyString, value: .init(value)))
    }
    
    func encode(_ value: Int8) throws {
        self.storage.append(.init(name: self.currentCodingKeyString, value: .init(value)))
    }
    
    func encode(_ value: Int16) throws {
        self.storage.append(.init(name: self.currentCodingKeyString, value: .init(value)))
    }
    
    func encode(_ value: Int32) throws {
        self.storage.append(.init(name: self.currentCodingKeyString, value: .init(value)))
    }
    
    func encode(_ value: Int64) throws {
        self.storage.append(.init(name: self.currentCodingKeyString, value: .init(value)))
    }
    
    func encode(_ value: UInt) throws {
        self.storage.append(.init(name: self.currentCodingKeyString, value: .init(value)))
    }
    
    func encode(_ value: UInt8) throws {
        self.storage.append(.init(name: self.currentCodingKeyString, value: .init(value)))
    }
    
    func encode(_ value: UInt16) throws {
        self.storage.append(.init(name: self.currentCodingKeyString, value: .init(value)))
    }
    
    func encode(_ value: UInt32) throws {
        self.storage.append(.init(name: self.currentCodingKeyString, value: .init(value)))
    }
    
    func encode(_ value: UInt64) throws {
        self.storage.append(.init(name: self.currentCodingKeyString, value: .init(value)))
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        let encoder = Namespace.init()
        encoder.codingPath = self.codingPath
        encoder.userInfo = self.userInfo
        try value.encode(to: encoder)
        self.storage.append(contentsOf: encoder.data)
    }
}

extension Namespace.SingleValueContainer: URLComponentsEncodingContainer {
    var data: [URLQueryItem] {
        self.storage
    }
}
