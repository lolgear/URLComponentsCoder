//
//  TopLevel.swift
//  URLComponentsCoder
//
//  Created by Dmitry Lobanov on 14.10.2020.
//

import Foundation

public enum TopLevel {}

public extension TopLevel {
    enum URLComponents {}
}

public extension TopLevel {
    enum AliasesMap {
        public typealias Encoder = TopLevel.URLComponents.Encoder
        public typealias Decoder = TopLevel.URLComponents.Decoder
    }
}
