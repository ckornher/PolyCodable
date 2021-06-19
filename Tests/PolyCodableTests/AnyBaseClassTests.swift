import XCTest
@testable import PolyCodable
import Foundation


// TODO: Investigate this test

///// Use custom coding key. We could use the default.
//enum  NonPolyBase_CodingKey : String, PolyCompatibleCodingKey, Equatable {
//
//    case typeOfThing
//    // case someCommonValue
//
//    static var discriminatorKey: NonPolyBase_CodingKey = typeOfThing
//}
//
//enum NPB_TestDecriminator: String, PolymorphicDiscriminator, Equatable {
//    case npb_class1
//    case npb_class2
//
//    func decode<PC, Key>(from container: KeyedDecodingContainer<Key>, forKey key: Key) throws -> PC
//        where PC : PolyCodable, Key: CodingKey {
//            switch( self )
//            {
//            case .npb_class1:
//                return try container.decode( NPB_Class1.self, forKey: key ) as! PC
//
//            case .npb_class2:
//                return try container.decode( NPB_Class2.self, forKey: key ) as! PC
//            }
//    }
//
//    func decodeNext<PC: PolyCodable>( from container: inout UnkeyedDecodingContainer ) throws -> PC {
//            switch( self )
//            {
//            case .npb_class1:
//                return try container.decode( NPB_Class1.self ) as! PC
//
//            case .npb_class2:
//                return try container.decode( NPB_Class2.self ) as! PC
//            }
//    }
//}
//
//// Two unrelated baseClasses
//class NonPolyBaseClass {}
//
//class CommonBaseClass : NonPolyBaseClass, PolyCodable {
//    typealias TypeDescriminator = NPB_TestDecriminator
//    typealias PolyCodingKey = NonPolyBase_CodingKey
//
//
//}
//
//
//// A common protocol:
//protocol NonPolybaseTestProtocol: AnyObject, PolyCodable
//where TypeDescriminator == NPB_TestDecriminator, PolyCodingKey == NonPolyBase_CodingKey {}
//
////open class PolymorphicBaseClass<D:PolymorphicDiscriminator, K: PolyCompatibleCodingKey> : PolyCodable, Equatable {
////
////    public let typeDescriminator: TypeDescriminator
////
////    // MARK: -
////    public init( _ typeDescriminator: TypeDescriminator ) {
////        self.typeDescriminator = typeDescriminator
////    }
////
////    public required init( from decoder: Decoder ) throws {
////        let container = try decoder.container( keyedBy: PolyCodingKey.self )
////
////        typeDescriminator = try container.decode( D.self, forKey: K.discriminatorKey )
////    }
////
////    public func encode(to encoder: Encoder) throws {
////        var container = encoder.container( keyedBy: PolyCodingKey.self )
////
////        try container.encode( typeDescriminator, forKey:  K.discriminatorKey )
////    }
////
////    // MARK: Utility
////    public static func == (lhs: PolymorphicBaseClass, rhs: PolymorphicBaseClass) -> Bool {
////        guard lhs.equalTo(other: rhs) else {
////            return false
////        }
////
////        return true
////    }
////
////    /// Check equality in this base class
////    func equalTo(other: PolymorphicBaseClass) -> Bool {
////        return self.typeDescriminator == other.typeDescriminator
////    }
////
////
////
//
//class NPB_Class1 : NonPolyBaseClass1, NonPolybaseTestProtocol {
//
//    let typeOfThing: TypeDescriminator
//    let nonPolyClass1Name: String
//
//    private enum CodingKeys: CodingKey {
//        case typeOfThing
//        case nonPolyClass1Name
//    }
//
//    override init() {
//        typeOfThing = .npb_class1
//        nonPolyClass1Name = "an instance of NPB_Class1"
//        super.init()
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        typeOfThing =  try container.decode(TypeDescriminator.self, forKey: .typeOfThing)
//        nonPolyClass1Name = try container.decode(String.self, forKey: .nonPolyClass1Name)
//
//        super.init()
//    }
//
//    func encode(to encoder: Encoder) throws {
//
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode( typeOfThing, forKey: .typeOfThing)
//        try container.encode( nonPolyClass1Name, forKey: .nonPolyClass1Name)
//    }
//
//    // Mark: Equatable support
//    public static func == (lhs: NPB_Class1, rhs: NPB_Class1) -> Bool {
//        if lhs.typeOfThing != rhs.typeOfThing { return false }
//        if lhs.nonPolyClass1Name != rhs.nonPolyClass1Name { return false }
//    }
//}
//
//class NPB_Class2 : NonPolyBaseClass1, NonPolybaseTestProtocol {
//    typealias TypeDescriminator = NPB_TestDecriminator
//    typealias PolyCodingKey = NonPolyBase_CodingKey
//
//    let typeOfThing: TypeDescriminator
//    let nonPolyClass1Name: String
//
//    private enum CodingKeys: CodingKey {
//        case typeOfThing
//        case nonPolyClass1Name
//    }
//
//    override init() {
//        typeOfThing = .npb_class1
//        nonPolyClass1Name = "an instance of NPB_Class2"
//        super.init()
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        typeOfThing =  try container.decode(TypeDescriminator.self, forKey: .typeOfThing)
//        nonPolyClass1Name = try container.decode(String.self, forKey: .nonPolyClass1Name)
//
//        super.init()
//    }
//
//    func encode(to encoder: Encoder) throws {
//
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode( typeOfThing, forKey: .typeOfThing)
//        try container.encode( nonPolyClass1Name, forKey: .nonPolyClass1Name)
//    }
//
//    // Mark: Equatable support
//    public static func == (lhs: NPB_Class2, rhs: NPB_Class2) -> Bool {
//        if lhs.typeOfThing != rhs.typeOfThing { return false }
//        if lhs.nonPolyClass1Name != rhs.nonPolyClass1Name { return false }
//    }
//}
//
//
//
//
//
//
//class NPB_SimpleContainer: Codable, Equatable {
//
//    let a: NonPolybaseTestProtocol
//    let b: NonPolybaseTestProtocol
//
//    private enum CodingKeys: CodingKey
//    {
//        case a
//        case b
//    }
//
//    init( a: NonPolybaseTestProtocol, b: NonPolybaseTestProtocol) {
//        self.a = a
//        self.b = b
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        a = try container.decodePolymorphic( NonPolybaseTestProtocol.self, forKey: .a )
//        b = try container.decodePolymorphic( NonPolybaseTestProtocol.self, forKey: .b )
//    }
//
//    static func == (lhs: NPB_SimpleContainer, rhs: NPB_SimpleContainer) -> Bool {
//        return
//            lhs.a == rhs.a &&
//            lhs.b == rhs.b
//    }
//}
//
////class DBC_SimpleOptionalContainer: Codable, Equatable {
////    let a: DBC_BaseClass?
////    let b: DBC_BaseClass?
////
////    private enum CodingKeys: CodingKey
////    {
////        case a
////        case b
////    }
////
////    init( a: DBC_BaseClass?, b: DBC_BaseClass?) {
////        self.a = a
////        self.b = b
////    }
////
////    required init(from decoder: Decoder) throws {
////        let container = try decoder.container(keyedBy: CodingKeys.self)
////
////        a = try container.decodePolymorphicIfPresent( DBC_BaseClass.self, forKey: .a )
////        b = try container.decodePolymorphicIfPresent( DBC_BaseClass.self, forKey: .b )
////    }
////
////    static func == (lhs: DBC_SimpleOptionalContainer, rhs: DBC_SimpleOptionalContainer) -> Bool {
////        // This should not be necessary
////        if let la = lhs.a,
////            let ra = rhs.a  {
////            if la != ra { return false }
////        } else {
////            if lhs.a != nil || rhs.a != nil { return false }
////        }
////
////        if let lb = lhs.b,
////            let rb = rhs.b  {
////            if lb != rb { return false }
////        } else {
////            if lhs.b != nil || rhs.b != nil { return false }
////        }
////
////        return true
////    }
////}
//
//// MARK: - Tests
//
//final class NonPolyBaseClassTests: XCTestCase {
//
//    func testNonPolyBaseNonOptional() throws {
//
//        try assertRoundTrip(original: DBC_SimpleContainer(a: NPB_Class1(), b: NPB_Class2()),
//                            name: "DBC_SimpleContainer(a: NPB_Class1(), b: NPB_Class2())")
//
//        try assertRoundTrip(original: DBC_SimpleContainer(a: NPB_Class2(), b: NPB_Class1()),
//                            name: "DBC_SimpleContainer(a: NPB_Class2(), b: NPB_Class1())")
//
//        try assertRoundTrip(original: DBC_SimpleContainer(a: NPB_Class1(), b: NPB_Class1()),
//                            name: "DBC_SimpleContainer(a: NPB_Class1(), b: NPB_Class1())")
//
//        try assertRoundTrip(original: DBC_SimpleContainer(a: NPB_Class2(), b: NPB_Class2()),
//                            name: "DBC_SimpleContainer(a: NPB_Class2(), b: NPB_Class2())")
//    }
//
//    func testDefaultBaseCodingKeyedClassesOptional() throws {
//
////        try assertRoundTrip(original: DBC_SimpleOptionalContainer(a: NPB_Class1(), b: NPB_Class2()),
////                            name: "DBC_SimpleOptionalContainer(a: NPB_Class1(), b: NPB_Class2())")
////
////        try assertRoundTrip(original: DBC_SimpleOptionalContainer(a: NPB_Class2(), b: NPB_Class1()),
////                            name: "DBC_SimpleOptionalContainer(a: NPB_Class2(), b: NPB_Class1())")
////
////        try assertRoundTrip(original: DBC_SimpleOptionalContainer(a: NPB_Class1(), b: NPB_Class1()),
////                            name: "DBC_SimpleOptionalContainer(a: NPB_Class1(), b: NPB_Class1())")
////
////        try assertRoundTrip(original: DBC_SimpleOptionalContainer(a: NPB_Class2(), b: NPB_Class2()),
////                            name: "DBC_SimpleOptionalContainer(a: NPB_Class2(), b: NPB_Class2())")
////
////        // nil arguments
////        try assertRoundTrip(original: DBC_SimpleOptionalContainer(a: NPB_Class1(), b: nil),
////                            name: "DBC_SimpleOptionalContainer(a: NPB_Class1(), b: nil)")
////
////        try assertRoundTrip(original: DBC_SimpleOptionalContainer(a: nil, b: NPB_Class1()),
////                            name: "DBC_SimpleOptionalContainer(a: nil, b: NPB_Class1())")
////
////        try assertRoundTrip(original: DBC_SimpleOptionalContainer(a: nil, b: nil),
////                            name: "DBC_SimpleOptionalContainer(a: nil, b: nil)")
//    }
//
//    static var allTests = [
//        ("nonOptional", testDefaultBaseCodingKeyedClassesNonOptional),
//        ("optional", testDefaultBaseCodingKeyedClassesOptional),
//    ]
//}
