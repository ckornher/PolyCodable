import XCTest
@testable import PolyCodable
import Foundation

// The abscract base class works
typealias DBC_BaseClass = DefaultKeyedPolymorphicClass<DBC_TestDecriminator>


enum DBC_TestDecriminator: String, PolymorphicDiscriminator {

    case dbc_class1
    case dbc_class2

    func from<PC: PolyCodable>( _ data: Data, jsonDecoder decoder: JSONDecoder ) throws -> PC {
        switch( self )
        {
        case .dbc_class1:
            return try decoder.decode( DBC_Class1.self, from: data ) as! PC

        case .dbc_class2:
            return try decoder.decode( DBC_Class2.self, from: data ) as! PC
        }
    }


    func decode<PC, Key>(from container: KeyedDecodingContainer<Key>, forKey key: Key) throws -> PC
        where PC : PolyCodable, Key: CodingKey {
            switch( self )
            {
            case .dbc_class1:
                return try container.decode( DBC_Class1.self, forKey: key ) as! PC

            case .dbc_class2:
                return try container.decode( DBC_Class2.self, forKey: key ) as! PC
            }
    }

    func decodeNext<PC: PolyCodable>( from container: inout UnkeyedDecodingContainer ) throws -> PC {
        switch( self )
        {
        case .dbc_class1:
            return try container.decode( DBC_Class1.self ) as! PC

        case .dbc_class2:
            return try container.decode( DBC_Class2.self ) as! PC
        }
    }

// TODO:
//    func from<PC: PolyCodable>( jsonData: Data  ) throws -> PC {
//        switch( self )
//        {
//        case .dbc_class1:
//            return try container.decode( DBC_Class1.self ) as! PC
//
//        case .dbc_class2:
//            return try container.decode( DBC_Class2.self ) as! PC
//        }
//    }
}

class DBC_Class1 : DBC_BaseClass {
    let dbc_class1Name: String

    private enum CodingKeys: CodingKey {
        case dbc_class1Name
    }

    init() {
        dbc_class1Name = "an instance of DBC_Class1"
        super.init( .dbc_class1 )
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        dbc_class1Name = try container.decode(String.self, forKey: .dbc_class1Name)

        try super.init(from: decoder)        // decode the superclass without using super.decoder
    }

    override func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode( dbc_class1Name, forKey: .dbc_class1Name)

        try super.encode(to: encoder)
    }


    // Mark: Equatable support

    override func equalTo(other: DBC_BaseClass) -> Bool {
        guard super.equalTo(other: other),
        let other = other as? DBC_Class1 else { return false }

        if other.dbc_class1Name != dbc_class1Name { return false }

        return true
    }
}

class DBC_Class2 : DBC_BaseClass
{
    let dbc_class2Name: String

    private enum CodingKeys: CodingKey {
        case dbc_class2Name
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // dump( container, name: "Class2 container" )

        dbc_class2Name = try container.decode(String.self, forKey: .dbc_class2Name)

        try super.init(from: decoder)       // decode the superclass without using super.decoder
    }

    init() {
        dbc_class2Name = "an instance of DBC_Class2"
        super.init( .dbc_class2 )
    }

    override func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode( dbc_class2Name, forKey: .dbc_class2Name)

        try super.encode(to: encoder)
    }

    // Mark: Equatable support
    override func equalTo(other: DBC_BaseClass) -> Bool {
        guard super.equalTo(other: other),
            let other = other as? DBC_Class2 else { return false }

        if other.dbc_class2Name != dbc_class2Name { return false }

        return true
    }
}

class DBC_SimpleContainer: Codable, Equatable {

    let a: DBC_BaseClass
    let b: DBC_BaseClass

    private enum CodingKeys: CodingKey
    {
        case a
        case b
    }

    init( a: DBC_BaseClass, b: DBC_BaseClass) {
        self.a = a
        self.b = b
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        a = try container.decodePolymorphic( DBC_BaseClass.self, forKey: .a )
        b = try container.decodePolymorphic( DBC_BaseClass.self, forKey: .b )
    }

    static func == (lhs: DBC_SimpleContainer, rhs: DBC_SimpleContainer) -> Bool {
        return
            lhs.a == rhs.a &&
            lhs.b == rhs.b
    }
}

class DBC_SimpleOptionalContainer: Codable, Equatable {
    let a: DBC_BaseClass?
    let b: DBC_BaseClass?

    private enum CodingKeys: CodingKey
    {
        case a
        case b
    }

    init( a: DBC_BaseClass?, b: DBC_BaseClass?) {
        self.a = a
        self.b = b
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        a = try container.decodePolymorphicIfPresent( DBC_BaseClass.self, forKey: .a )
        b = try container.decodePolymorphicIfPresent( DBC_BaseClass.self, forKey: .b )
    }

    static func == (lhs: DBC_SimpleOptionalContainer, rhs: DBC_SimpleOptionalContainer) -> Bool {
        // This should not be necessary
        if let la = lhs.a,
            let ra = rhs.a  {
            if la != ra { return false }
        } else {
            if lhs.a != nil || rhs.a != nil { return false }
        }

        if let lb = lhs.b,
            let rb = rhs.b  {
            if lb != rb { return false }
        } else {
            if lhs.b != nil || rhs.b != nil { return false }
        }

        return true
    }
}

// MARK: - Tests

final class DefaultBaseClassTests: XCTestCase {

    func testDefaultBaseCodingKeyedClassesNonOptional() throws {

        try assertRoundTrip(original: DBC_SimpleContainer(a: DBC_Class1(), b: DBC_Class2()),
                            name: "DBC_SimpleContainer(a: DBC_Class1(), b: DBC_Class2())")

        try assertRoundTrip(original: DBC_SimpleContainer(a: DBC_Class2(), b: DBC_Class1()),
                            name: "DBC_SimpleContainer(a: DBC_Class2(), b: DBC_Class1())")

        try assertRoundTrip(original: DBC_SimpleContainer(a: DBC_Class1(), b: DBC_Class1()),
                            name: "DBC_SimpleContainer(a: DBC_Class1(), b: DBC_Class1())")

        try assertRoundTrip(original: DBC_SimpleContainer(a: DBC_Class2(), b: DBC_Class2()),
                            name: "DBC_SimpleContainer(a: DBC_Class2(), b: DBC_Class2())")
    }

    func testDefaultBaseCodingKeyedClassesOptional() throws {

        try assertRoundTrip(original: DBC_SimpleOptionalContainer(a: DBC_Class1(), b: DBC_Class2()),
                            name: "DBC_SimpleOptionalContainer(a: DBC_Class1(), b: DBC_Class2())")

        try assertRoundTrip(original: DBC_SimpleOptionalContainer(a: DBC_Class2(), b: DBC_Class1()),
                            name: "DBC_SimpleOptionalContainer(a: DBC_Class2(), b: DBC_Class1())")

        try assertRoundTrip(original: DBC_SimpleOptionalContainer(a: DBC_Class1(), b: DBC_Class1()),
                            name: "DBC_SimpleOptionalContainer(a: DBC_Class1(), b: DBC_Class1())")

        try assertRoundTrip(original: DBC_SimpleOptionalContainer(a: DBC_Class2(), b: DBC_Class2()),
                            name: "DBC_SimpleOptionalContainer(a: DBC_Class2(), b: DBC_Class2())")

        // nil arguments
        try assertRoundTrip(original: DBC_SimpleOptionalContainer(a: DBC_Class1(), b: nil),
                            name: "DBC_SimpleOptionalContainer(a: DBC_Class1(), b: nil)")

        try assertRoundTrip(original: DBC_SimpleOptionalContainer(a: nil, b: DBC_Class1()),
                            name: "DBC_SimpleOptionalContainer(a: nil, b: DBC_Class1())")

        try assertRoundTrip(original: DBC_SimpleOptionalContainer(a: nil, b: nil),
                            name: "DBC_SimpleOptionalContainer(a: nil, b: nil)")
    }

    static var allTests = [
        ("nonOptional", testDefaultBaseCodingKeyedClassesNonOptional),
        ("optional", testDefaultBaseCodingKeyedClassesOptional),
    ]
}
