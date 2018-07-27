//
//  DefaultDiscriminatedStructTests.swift
//  PolyCodableTests
//
//  Created by Christopher Kornher on 7/22/18.
//

import XCTest

import XCTest
@testable import PolyCodable
import Foundation

/// These types are abbreviated as "DTS"
/*

enum DefaultedTestStructDiscriminator: String, PolymorphicDiscriminator {
    case struct1
    case struct2

    func decode<DC, Key>(from container: KeyedDecodingContainer<Key>, forKey key: Key) throws -> DC
        where DC : DescriminatedCodable, Key : CodingKey {
            switch( self )
            {
            case .struct1:
                return try container.decode( DTS_Struct1.self, forKey: key ) as! DC

            case .struct2:
                return try container.decode( DTS_Struct2.self, forKey: key ) as! DC
            }
    }
}

//enum DTS_PolymorphicCodingKey: PolyCompatibleCodingKey {
//    case typeDescriminator
//    static let discriminatorKey: DTS_PolymorphicCodingKey = .typeDescriminator
//}

protocol DTS_PolyStructConformance : DefaultDiscriminatedStruct
    where TypeDescriminator == DefaultedTestStructDiscriminator {}

protocol DTSPolyStruct {}


struct DTS_Struct1 : DTSPolyStruct, DTS_PolyStructConformance {

    enum Struct1CodingKey: PolyCompatibleCodingKey {
        case typeDescriminator
        case dts1Name

        static let discriminatorKey: Struct1CodingKey = .typeDescriminator
    }

    let dts1Name: String
    let typeDescriminator: TypeDescriminator


    // MARK: -

    init() {
        self.dts1Name = "an instance of Class1"
        self.typeDescriminator = .struct1
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Struct1CodingKey.self)

        typeDescriminator = try container.decode(DefaultedTestStructDiscriminator.self, forKey: .typeDescriminator)
        dts1Name = try container.decode(String.self, forKey: .dts1Name)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: Struct1CodingKey.self)
        try container.encode( typeDescriminator, forKey: .typeDescriminator)
        try container.encode( dts1Name, forKey: .dts1Name)
    }
}

struct DTS_Struct2 : DTSPolyStruct, DTS_PolyStructConformance {

    enum Struct2CodingKey: CodingKey {
        case typeDescriminator
        case dts2name

        static let discriminatorKey: Struct2CodingKey = .typeDescriminator
    }

    let dts2name: String
    let typeDescriminator: TypeDescriminator


    // MARK: -

    init() {
        self.dts2name = "an instance of Class1"
        self.typeDescriminator = .struct1
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Struct2CodingKey.self)

        typeDescriminator = try container.decode(DefaultedTestStructDiscriminator.self, forKey: .typeDescriminator)
        dts2name = try container.decode(String.self, forKey: .dts2name)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: Struct2CodingKey.self)
        try container.encode( typeDescriminator, forKey: .typeDescriminator)
        try container.encode( dts2name, forKey: .dts2name)
    }
}


class ACodableStruct: Codable {

    let a: DTSPolyStruct
    let b: DTSPolyStruct

    private enum CodingKeys: CodingKey
    {
        case a
        case b
    }

    init( a: DTS_Struct1(), b: DTS_Struct2) {
        self.a = a
        self.b = b
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        a = try BaseClass.decode( from: container, forKey: .a )
        b = try BaseClass.decode( from: container, forKey: .b )
    }
}
*/







/*
// ---- TestCase1 ----

class DefaultedStructTests: XCTestCase {
    func StructToStruct() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        let original = ACodable(a: Struct1(), b: Struct2())

        dumpEncodedJSON( original, instance: "ACodable(a: Class1(), b: Class2())" )

        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(original)

        let jsonDecoder = JSONDecoder()
        let decoded = try jsonDecoder.decode(ACodable.self, from: jsonData)

        assert( original.a.typeDescriminator == decoded.a.typeDescriminator )
        assert( original.b.typeDescriminator == decoded.b.typeDescriminator )

        print("\n")
        dump( original, name:"Original" )

        print("\n")
        dump( decoded, name:"Decoded" )



        // XCTAssertEqual(PolyCodable().text, "Hello, World!")
    }

    static var allTests = [
            ("testExample", testExample),
    ]
}
*/
