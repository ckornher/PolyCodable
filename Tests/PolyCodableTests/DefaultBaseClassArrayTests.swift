//
//  DefaultBaseClassArrayTests.swift
//  PolyCodableTests
//
//  Created by Christopher Kornher on 7/26/18.
//

import XCTest

class DBC_ArrayContainer: Codable, Equatable {
    let aPolymorphicArray: [DBC_BaseClass]

    private enum CodingKeys: CodingKey
    {
        case aPolymorphicArray
    }

    init( array: [DBC_BaseClass] ) {
        self.aPolymorphicArray = array
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        aPolymorphicArray = try container.decodePolymorphic( [DBC_BaseClass].self, forKey: .aPolymorphicArray )
    }

    static func == (lhs: DBC_ArrayContainer, rhs: DBC_ArrayContainer) -> Bool {
        return lhs.aPolymorphicArray == rhs.aPolymorphicArray
    }
}

// MARK: - Tests

class DefaultBaseClassArrayTests: XCTestCase {
    func testSimpleArray() throws {

        try assertRoundTrip(original: DBC_ArrayContainer( array:[ DBC_Class1(), DBC_Class2()] ),
                            name: "DBC_ArrayContainer( array:[ DBC_Class1(), DBC_Class2()]")
    }

    static var allTests = [
        ("array", testSimpleArray),
    ]
}
