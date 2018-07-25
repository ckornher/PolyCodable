//
//  PolymorphicBaseClass.swift
//  PolyCodable
//
//  Created by Christopher Kornher on 7/22/18.
//

/// Base class containing a discriminator property
open class PolymorphicBaseClass<D:PolymorphicDiscriminator, K: PolyCompatibleCodingKey> : PolyCodable {

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

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container( keyedBy: PolyCodingKey.self )

        try container.encode( typeDescriminator, forKey:  K.discriminatorKey )
    }
//
//    static func decode<Key>( from container: KeyedDecodingContainer<Key>, forKey key: Key ) throws -> Self {
//        let baseClassObject = try container.decode( self, forKey: key )
//        return try baseClassObject.typeDescriminator.decode( from: container, forKey: key )
//    }

    // MARK: Utility
    static func == (lhs: PolymorphicBaseClass, rhs: PolymorphicBaseClass) -> Bool {
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

