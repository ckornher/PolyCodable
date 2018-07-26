//
//  PolyCodableTestHelpers.swift
//  PolyCodable
//
//  Created by Christopher Kornher on 7/22/18.
//

import Foundation
import XCTest

func assertRoundTrip<T: Codable & Equatable>(original: T, name: String) throws {

    dumpEncodedJSON(original, instance: name)

    let jsonEncoder = JSONEncoder()
    let jsonData = try jsonEncoder.encode(original)

    let jsonDecoder = JSONDecoder()
    let decoded = try jsonDecoder.decode(T.self, from: jsonData)

    XCTAssert( original == decoded )

    print("\n")
    dump( original, name:"Original" )

    print("\n")
    dump( decoded, name:"Decoded" )
}


extension String {
    /*
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     - Parameter length: Desired maximum lengths of a string
     - Parameter trailing: A 'String' that will be appended after the truncation.

     - Returns: 'String' object.
     */
    func trunc(length: Int, trailing: String = "") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}

let rule = "-------------------------------------------------------------------------------"

func dumpJSON<T: Encodable>( _ encodable: T, name: String?=nil ) {

    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    let jsonData = try! jsonEncoder.encode(encodable)

    print( rule )
    if let name = name {
        print( "| \(name) |" )
        print( "\(rule.trunc(length: name.count+4))\n" )
    }
    print(String(data: jsonData, encoding: .utf8)!)
    print( rule )
}

func dumpEncodedJSON<T: Encodable>( _ encodable: T, instance: String ) {
    dumpJSON( encodable, name: instance + " encoded as" )
}

//public func ==<Element : Equatable>(lhs: Element?, rhs: Element?) -> Bool {
//    switch (lhs, rhs) {
//    case (.some(let l), .some(let r)):
//        return l == r
//    case (nil, nil):
//        return true
//    default:
//        return false
//    }
//}
