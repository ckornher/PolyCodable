import XCTest
@testable import PolyCodable
import Foundation

typealias BaseClass = DefaultKeyedPolymorphicClass<MySubclassesDiscriminator>

enum MySubclassesDiscriminator: String, PolymorphicDiscriminator {
    case class1
    case class2

    func decode<DC, Key>(from container: KeyedDecodingContainer<Key>, forKey key: Key) throws -> DC
        where DC : DescriminatedCodable, Key : CodingKey {
            switch( self )
            {
            case .class1:
                return try container.decode( Class1.self, forKey: key ) as! DC

            case .class2:
                return try container.decode( Class2.self, forKey: key ) as! DC
            }
    }
}

class Class1 : BaseClass {
    let name: String

    private enum CodingKeys: CodingKey {
        case name
    }

    // MARK: -

    init() {
        name = "an instance of Class1"
        super.init( .class1 )
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)

        try super.init(from: decoder)        // decode the superclass without using super.decoder
    }

    override func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode( name, forKey: .name)

        try super.encode(to: encoder)
    }
}

class Class2 : BaseClass
{
    let otherName: String

    private enum CodingKeys: CodingKey {
        case otherName
    }

    // MARK: -


    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // dump( container, name: "Class2 container" )

        otherName = try container.decode(String.self, forKey: .otherName)

        try super.init(from: decoder)       // decode the superclass without using super.decoder
    }

    init() {
        otherName = "an instance of Class2"
        super.init( .class2 )
    }

    override func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode( otherName, forKey: .otherName)

        try super.encode(to: encoder)
    }
}

class ACodable: Codable {

    let a: BaseClass
    let b: BaseClass

    private enum CodingKeys: CodingKey
    {
        case a
        case b
    }

    init( a: BaseClass, b: BaseClass) {
        self.a = a
        self.b = b
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        a = try BaseClass.decode( from: container, forKey: .a )
        b = try BaseClass.decode( from: container, forKey: .b )
    }
}

// ---- TestCase1 ----

final class PolyCodableTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        let original = ACodable(a: Class1(), b: Class2())

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
