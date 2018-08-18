//
//  PolymorphicBaseClass.swift
//  PolyCodable
//
//  Created by Christopher Kornher on 7/22/18.
//

/// A generic base class provided for convenience

import Foundation

open class PolymorphicBaseClass<D:PolymorphicDiscriminator, K: PolyCompatibleCodingKey> : PolyCodable, Equatable {
    public typealias TypeDescriminator = D
    public typealias PolyCodingKey = K

    public let typeDescriminator: TypeDescriminator

    // MARK: -
    public init( _ typeDescriminator: TypeDescriminator ) {
        self.typeDescriminator = typeDescriminator
    }

    public required init( from decoder: Decoder ) throws {
        let container = try decoder.container( keyedBy: PolyCodingKey.self )

        typeDescriminator = try container.decode( D.self, forKey: K.discriminatorKey )
    }

    open func encode(to encoder: Encoder) throws {
        var container = encoder.container( keyedBy: PolyCodingKey.self )

        try container.encode( typeDescriminator, forKey:  K.discriminatorKey )
    }

    // TODO: Move this to an extension
    public static func from( _ data: Data,
                             jsonDecoder decoder: JSONDecoder,
                             codingScheme: PolymorphicCodingScheme = defaultPolymorphicCodingScheme ) throws -> Self {
        return try codingScheme.decodeFromData(data, jsonDecoder: decoder)
    }

    // MARK: Utility
    public static func == (lhs: PolymorphicBaseClass, rhs: PolymorphicBaseClass) -> Bool {
        guard lhs.equalTo(other: rhs) else {
            return false
        }

        return true
    }

    /// Check equality in this base class
    func equalTo(other: PolymorphicBaseClass) -> Bool {
        return self.typeDescriminator == other.typeDescriminator
    }
}
