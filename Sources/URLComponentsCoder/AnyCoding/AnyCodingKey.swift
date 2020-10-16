//
//  AnyCodingKey.swift
//  URLComponentsCoder
//
//  Created by Dmitry Lobanov on 14.10.2020.
//

import Foundation

fileprivate typealias Namespace = TopLevel.URLComponents

extension Namespace {
    struct AnyCodingKey: CodingKey, Equatable {
        let stringValue: String
        let intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
        
        init<Key>(_ base: Key) where Key : CodingKey {
            if let intValue = base.intValue {
                self.init(intValue: intValue)!
            } else {
                self.init(stringValue: base.stringValue)!
            }
        }
    }
}

extension Namespace.AnyCodingKey: Hashable {
    func hash(into hasher: inout Hasher) {
        if let intValue = self.intValue {
            hasher.combine(intValue)
        }
        else {
            hasher.combine(self.stringValue)
        }
    }
}

// MARK: CodingPathConverter
extension Namespace {
    struct CodingPathConverter {
        let codingKey: CodingKey
        init(_ codingKey: CodingKey) {
            self.codingKey = codingKey
        }
        var stringValue: String {
            self.codingKey.intValue.flatMap({$0.description}) ?? self.codingKey.stringValue
        }
    }
}

