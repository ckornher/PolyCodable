//
//  PolymorphicCodingScheme.swift
//  PolyCodable
//
//  Created by Christopher Kornher on 7/26/18.
//

import Foundation


public protocol PolymorphicCodingScheme : class {
    /// Decode polymorphically from a standard KeyedDecodingContainer using one of the standard methods.
    /// This method can be re-implemented for custom poymorphic coding schemes.  The key enum in this container must contain the descrimintor key.
    func polymorphicDecode<Key, PC>(from container: KeyedDecodingContainer<Key>,
                                    forKey key: Key) throws -> PC where PC : PolyCodable, Key : CodingKey


    /// Decode polymorphically from a standard KeyedDecodingContainer using one of the standard methods, if the key is present in the container.
    /// This method can be re-implemented for custom poymorphic coding schemes.  The key enum in this container must contain the descrimintor key.
    func polymorphicDecodeIfPresent<Key, PC>(from container: KeyedDecodingContainer<Key>,
                                             forKey key: Key) throws -> PC? where PC : PolyCodable, Key : CodingKey

    /// Decode polymorphically from data. This method can be re-implemented for custom poymorphic coding schemes.
    /// The descrimintor key must exist in the root container
    func decodeFromData<PC: PolyCodable>( _ data: Data, jsonDecoder decoder: JSONDecoder ) throws -> PC

    // MARK: Collections

    /// Decode polymorphically from a standard KeyedDecodingContainer using one of the standard methods.
    /// This method can be re-implemented for custom poymorphic coding schemes.  The key enum in this container must contain the descrimintor key.
    func polymorphicDecode<Key, PC>(from container: KeyedDecodingContainer<Key>,
                                    forKey key: Key) throws -> [PC] where PC : PolyCodable, Key : CodingKey
}

open class StandardPolymorphicCodingScheme : PolymorphicCodingScheme {

    open func polymorphicDecode<Key, PC>(from container: KeyedDecodingContainer<Key>,
                                         forKey key: Key) throws -> PC where PC : PolyCodable, Key : CodingKey {
        let descrimintor = try decodeDescrimintor(from: container, forKey: key, type:PC.self)
        return try descrimintor.decode(from: container, forKey: key)
    }

    open func polymorphicDecodeIfPresent<Key, PC>(from container: KeyedDecodingContainer<Key>,
                                                  forKey key: Key) throws -> PC? where PC : PolyCodable, Key : CodingKey {
        let descrimintor = try decodeDescrimintorIfPresent(from: container, forKey: key, type:PC.self)
        if let descrimintor = descrimintor {
            return try descrimintor.decode(from: container, forKey: key)
        }

        return nil
    }

    open func decodeFromData<PC: PolyCodable>( _ jsonData: Data, jsonDecoder decoder: JSONDecoder ) throws -> PC {
        let baseObject = try decoder.decode( PolyCodableDescriminatorContainer<PC>.self, from: jsonData )
        return try baseObject.typeDescriminator.from(jsonData, jsonDecoder: decoder)
    }


    // MARK: Collections

    /// Decode an array polymorphically from a standard KeyedDecodingContainer.
    /// This method can be re-implemented for custom poymorphic coding schemes.  The key enum in this container must contain the descrimintor key.
    open func polymorphicDecode<Key, PC>(from container: KeyedDecodingContainer<Key>,
                                         forKey key: Key) throws -> [PC] where PC : PolyCodable, Key : CodingKey {

        let descrimintorArray = try container.decode( [PolyCodableDescriminatorContainer<PC>].self, forKey: key )
        var desciminatorIterator = descrimintorArray.makeIterator()

        var decoded = [PC]()
        var arrayContainer = try container.nestedUnkeyedContainer(forKey: key)

        while !arrayContainer.isAtEnd {
            guard let descriminator = desciminatorIterator.next()?.typeDescriminator else {
                preconditionFailure("internal logic failure")
            }
            decoded.append( try descriminator.decodeNext( from: &arrayContainer ))
        }

        return decoded
    }

    // MARK: - Utility
    open func decodeDescrimintor<Key, PC>( from container: KeyedDecodingContainer<Key>,
                                           forKey key: Key,
                                           type: PC.Type) throws -> PC.TypeDescriminator where PC: PolyCodable {
        let descriminator = try decodeDescrimintorIfPresent( from: container, forKey: key, type: type)

        if let descriminator = descriminator {
            return descriminator
        }

        throw PolyCobableError.decriminatorNotFound
    }

    open func decodeDescrimintorIfPresent<Key,PC>( from container: KeyedDecodingContainer<Key>,
                                                forKey key: Key,
                                                type: PC.Type) throws ->PC.TypeDescriminator? where PC: PolyCodable {

        return try container.decodeIfPresent( PolyCodableDescriminatorContainer<PC>.self, forKey: key )?.typeDescriminator
    }
}

