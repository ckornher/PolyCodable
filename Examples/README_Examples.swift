//
//  README_Examples.swift
//  PolyCodableTests
//
//  Created by Christopher Kornher on 10/20/18.
//

import Foundation
import PolyCodable
import XCTest

typealias MyBaseClass = DefaultKeyedPolymorphicClass<MyClassType>

enum MyClassType: String, PolymorphicDiscriminator {
    case a
    case b

    func from<PC: PolyCodable>( _ data: Data, jsonDecoder decoder: JSONDecoder ) throws -> PC {
        switch( self ) {
        case .a:
            return try decoder.decode( A.self, from: data ) as! PC
        case .b:
            return try decoder.decode( B.self, from: data ) as! PC
        }
    }


    func decode<PC, Key>(from container: KeyedDecodingContainer<Key>, forKey key: Key) throws -> PC
        where PC : PolyCodable, Key: CodingKey {
            switch( self ) {
            case .a:
                return try container.decode( A.self, forKey: key ) as! PC
            case .b:
                return try container.decode( B.self, forKey: key ) as! PC
            }
    }

    func decodeNext<PC: PolyCodable>( from container: inout UnkeyedDecodingContainer ) throws -> PC {
        switch( self ) {
        case .a:
            return try container.decode( A.self ) as! PC
        case .b:
            return try container.decode( B.self ) as! PC
        }
    }
}

class A : MyBaseClass {
    init() {
        super.init( .a )
    }

    required init( from decoder: Decoder ) throws {
        try super.init( from: decoder )        // decode the superclass without using super.decoder
    }
}

class B : MyBaseClass {
    init() {
        super.init( .b )
    }

    required init( from decoder: Decoder ) throws {
        try super.init( from: decoder )        // decode the superclass without using super.decoder
    }
}

class C : Codable {
    let v1: MyBaseClass
    let v2: MyBaseClass?
    let array: [MyBaseClass]

    private enum CodingKeys: CodingKey {
        case v1
        case v2
        case array
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        v1 = try container.decodePolymorphic( MyBaseClass.self, forKey: .v1 )
        v2 = try container.decodePolymorphicIfPresent( MyBaseClass.self, forKey: .v2 )
        array = try container.decodePolymorphic( [MyBaseClass].self, forKey: .array )
    }

    // No special polymorphic encoding code required (!)
}

let cJSON =
"""
{
    "v1": {
        "typeDescriminator": "a",
    },
    "v2": {
        "typeDescriminator": "b",
    },
    "array": [
        {
            "typeDescriminator": "b",
        }
    ]
}
"""

final class REDMEExample1Tests: XCTestCase {

    // Ensure that the README classes compile and run as expected.
    func testEx1() throws {
        let data = cJSON.data(using: .utf8)
        let decoder = JSONDecoder()

        let c = try decoder.decode(C.self, from: data!)
        dump( c )       // √ Inspected the dump
        // TODO: Make these classes equatable
        // try assertRoundTrip(original: c, name: "README Example 1")
    }
}
