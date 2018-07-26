//
//  PolymorphicBaseClass.swift
//  PolyCodable
//
//  Created by Christopher Kornher on 7/22/18.
//

/// Base class containing a discriminator property

open class PolymorphicBaseClass<D:PolymorphicDiscriminator, K: PolyCompatibleCodingKey> : PolyCodable, Equatable {

    public static func polymorphicCodingScheme() -> PolymorphicCodingScheme {
        return StandardPolymorphicCodingScheme<PolymorphicBaseClass>()
    }

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

