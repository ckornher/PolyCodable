//
//  DefaultBaseClassArrayTests.swift
//  PolyCodableTests
//
//  Created by Christopher Kornher on 7/26/18.
//

import XCTest

class DBC_ArrayContainer: Codable, Equatable {
    let array: [DBC_BaseClass]

    private enum CodingKeys: CodingKey
    {
        case array
    }

    init( array: [DBC_BaseClass] ) {
        self.array = array
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        array = try container.decodePolymorphic( [DBC_BaseClass].self, forKey: .array )
    }

    static func == (lhs: DBC_ArrayContainer, rhs: DBC_ArrayContainer) -> Bool {
        return lhs.array == rhs.array
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
