//
//  Decoder+Typealiases.swift
//  URLComponentsCoder
//
//  Created by Dmitry Lobanov on 15.10.2020.
//

import Foundation

fileprivate typealias Namespace = TopLevel.AliasesMap.Decoder._Decoder

extension Namespace {
    typealias AnyCodingKey = TopLevel.URLComponents.AnyCodingKey
    typealias CodingPathConverter = TopLevel.URLComponents.CodingPathConverter
}
