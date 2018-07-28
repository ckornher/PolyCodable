//
//  Defaults.swift
//  PolyCodable
//
//  Created by Christopher Kornher on 7/22/18.
//

// MARK: Classes

// MARK: - Simplified Helper Types

/// A standardized "base coding key" that uses "typeDescriminator" as the JSON key to differentiate variant types
public enum DefaultBaseCodingKey : PolyCompatibleCodingKey {
    case typeDescriminator

    public static var discriminatorKey: DefaultBaseCodingKey = .typeDescriminator
}

typealias DefaultKeyedPolymorphicClass<D:PolymorphicDiscriminator> = PolymorphicBaseClass<D, DefaultBaseCodingKey>

// MARK: - Static Variables

/// The standard coding scheme. This can be "overridden" at the point of use with optional function parameters
public let defaultPolymorphicCodingScheme = StandardPolymorphicCodingScheme()


