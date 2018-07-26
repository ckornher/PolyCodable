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
//    public func decodePolymorphicIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : PolyCodable {
//
//
//
//        guard let descriminatorContainer = try decodeIfPresent( PolyCodableDescriminatorContainer<T>.self, forKey: key ) else {
//            return nil
//        }
//
//        return try descriminatorContainer.typeDescriminator.decode( from: self, forKey: key )
//    }

    public func decodePolymorphic<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T : PolyCodable {
        return try T.polymorphicCodingScheme().polymorphicDecode( from: self, forKey: key )
    }

    // TODO: decode Polymorphic Arrays

    // TODO: decode Polymorphic Dictionaries
}


