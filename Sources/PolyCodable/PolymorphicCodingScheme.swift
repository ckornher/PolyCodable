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


    /// Decode polymorphically from a standard KeyedDecodingContainer using one of the standard methods, if the key is present in the container
    /// This method can be re-implemented for custom poymorphic coding schemes.  The key enum in this container must contain the descrimintor key.
    func polymorphicDecodeIfPresent<Key, PC>(from container: KeyedDecodingContainer<Key>,
                                             forKey key: Key) throws -> PC? where PC : PolyCodable, Key : CodingKey

    // MARK: Collections

    /// Decode polymorphically from a standard KeyedDecodingContainer using one of the standard methods.
    /// This method can be re-implemented for custom poymorphic coding schemes.  The key enum in this container must contain the descrimintor key.
    func polymorphicDecode<Key, PC>(from container: KeyedDecodingContainer<Key>,
                                    forKey key: Key) throws -> [PC] where PC : PolyCodable, Key : CodingKey
}

open class StandardPolymorphicCodingScheme<CodedType> : PolymorphicCodingScheme where CodedType: PolyCodable{


    open func polymorphicDecode<Key, PC>(from container: KeyedDecodingContainer<Key>,
                                         forKey key: Key) throws -> PC where PC : PolyCodable, Key : CodingKey {
        let descrimintor = try decodeDescrimintor(from: container, forKey: key) as! PC.TypeDescriminator
        return try descrimintor.decode(from: container, forKey: key)
    }

    open func polymorphicDecodeIfPresent<Key, PC>(from container: KeyedDecodingContainer<Key>,
                                                  forKey key: Key) throws -> PC? where PC : PolyCodable, Key : CodingKey {
        let descrimintor = try decodeDescrimintorIfPresent(from: container, forKey: key) as! PC.TypeDescriminator?
        if let descrimintor = descrimintor {
            return try descrimintor.decode(from: container, forKey: key)
        }

        return nil
    }

    // MARK: Collections

    /// Decode an array polymorphically from a standard KeyedDecodingContainer.
    /// This method can be re-implemented for custom poymorphic coding schemes.  The key enum in this container must contain the descrimintor key.
    open func polymorphicDecode<Key, PC>(from container: KeyedDecodingContainer<Key>,
                                         forKey key: Key) throws -> [PC] where PC : PolyCodable, Key : CodingKey {

        let descrimintorArray = try container.decode( [PolyCodableDescriminatorContainer<CodedType>].self, forKey: key )
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
    open func decodeDescrimintor<Key>( from container: KeyedDecodingContainer<Key>,
                                       forKey key: Key ) throws -> CodedType.TypeDescriminator {
        let descriminator = try decodeDescrimintorIfPresent( from: container, forKey: key)

        if let descriminator = descriminator {
            return descriminator
        }

        throw PolyCobableError.decriminatorNotFound
    }

    open func decodeDescrimintorIfPresent<Key>( from container: KeyedDecodingContainer<Key>,
                                                forKey key: Key ) throws ->CodedType.TypeDescriminator? {
        return try container.decodeIfPresent( PolyCodableDescriminatorContainer<CodedType>.self, forKey: key )?.typeDescriminator
    }
}

