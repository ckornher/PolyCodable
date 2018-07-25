//
//  KeyedDecodingContainer+PolyCodable.swift
//  PolyCodable
//
//  Created by Christopher Kornher on 7/24/18.
//

import Foundation

extension KeyedDecodingContainer {
    public func decodePolymorphic<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T : PolyCodable {
        // TODO: handle classes that use "super" containers

        let descriminatorContainer = try decode( PolyCodableDescriminatorContainer<T>.self, forKey: key )
        return try descriminatorContainer.typeDescriminator.decode( from: self, forKey: key )
    }

    public func decodePolymorphicIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : PolyCodable {
        // TODO: handle classes that use "super" containers
        guard let descriminatorContainer = try decodeIfPresent( PolyCodableDescriminatorContainer<T>.self, forKey: key ) else {
            return nil
        }

        return try descriminatorContainer.typeDescriminator.decode( from: self, forKey: key )
    }

    // TODO: decode polymorphic arrays

    // TODO: decode polymorphic dictionaries
}


