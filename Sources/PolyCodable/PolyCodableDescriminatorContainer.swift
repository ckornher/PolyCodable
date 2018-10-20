//
//  PolyCodableDescriminatorContainer.swift
//  PolyCodable
//
//  Created by Christopher Kornher on 7/25/18.
//

/// Container for the type descriminator that can be decoded from a polymorphic/descriminated entity. 
struct PolyCodableDescriminatorContainer<PC> : Decodable where PC: PolyCodable {
    let typeDescriminator: PC.TypeDescriminator

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: PC.PolyCodingKey.self)
        typeDescriminator = try values.decode(PC.TypeDescriminator.self, forKey: PC.PolyCodingKey.discriminatorKey)
    }
}
