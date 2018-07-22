//
//  DefaultBaseCodingKey.swift
//  PolyCodable
//
//  Created by Christopher Kornher on 7/22/18.
//

public enum DefaultBaseCodingKey : BaseCodingKey {
    case typeDescriminator

    public static var discriminatorKey: DefaultBaseCodingKey = .typeDescriminator
}
               
typealias DefaultKeyedPolymorphicClass<D:PolymorphicDiscriminator> = PolymorphicBaseClass<D, DefaultBaseCodingKey>
