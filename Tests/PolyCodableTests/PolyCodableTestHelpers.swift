//
//  PolyCodableTestHelpers.swift
//  PolyCodable
//
//  Created by Christopher Kornher on 7/22/18.
//

import Foundation

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

