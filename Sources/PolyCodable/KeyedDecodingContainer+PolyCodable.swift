//
//  KeyedDecodingContainer+PolyCodable.swift
//  PolyCodable
//
//  Created by Christopher Kornher on 7/24/18.
//

import Foundation

/// Extend KeyedDecodingContainer to decode polymorphic classes and descriminated value types when the descriminator is not in a
/// "superDecoder". The key enum in this container must contain the descrimintor key.

extension KeyedDecodingContainer {

    public func decodePolymorphic<T>(_ type: T.Type,
                                     forKey key: KeyedDecodingContainer<K>.Key,
                                     codingScheme: PolymorphicCodingScheme = defaultPolymorphicCodingScheme) throws -> T where T : PolyCodable {
        return try codingScheme.polymorphicDecode( from: self, forKey: key )
    }

    public func decodePolymorphicIfPresent<T>(_ type: T.Type,
                                              forKey key: K,
                                              codingScheme: PolymorphicCodingScheme = defaultPolymorphicCodingScheme) throws -> T? where T : PolyCodable {
        return try codingScheme.polymorphicDecodeIfPresent( from: self, forKey: key )
    }

    public func decodePolymorphic<T>(_ type: [T].Type,
                                     forKey key: KeyedDecodingContainer<K>.Key,
                                     codingScheme: PolymorphicCodingScheme = defaultPolymorphicCodingScheme) throws -> [T] where T : PolyCodable {
        return try codingScheme.polymorphicDecode( from: self, forKey: key )
    }
}


