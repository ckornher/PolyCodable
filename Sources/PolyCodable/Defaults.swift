//
//  Defaults.swift
//  PolyCodable
//
//  Created by Christopher Kornher on 7/22/18.
//

// MARK: Classes

public enum DefaultBaseCodingKey : PolyCompatibleCodingKey {
    case typeDescriminator

    public static var discriminatorKey: DefaultBaseCodingKey = .typeDescriminator
}
               
typealias DefaultKeyedPolymorphicClass<D:PolymorphicDiscriminator> = PolymorphicBaseClass<D, DefaultBaseCodingKey>

