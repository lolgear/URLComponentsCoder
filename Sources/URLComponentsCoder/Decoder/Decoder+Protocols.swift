//
//  Decoder+Protocols.swift
//  URLComponentsCoder
//
//  Created by Dmitry Lobanov on 15.10.2020.
//

import Foundation

protocol URLComponentsDecodingContainer: class {
    var data: [URLQueryItem] { get set }
}
