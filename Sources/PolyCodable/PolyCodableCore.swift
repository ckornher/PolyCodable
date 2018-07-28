/// All errors thrown by this module
enum PolyCobableError: Error {
    case decriminatorNotFound
}

/// The coding keys to use for the base class or common struct root.
public protocol PolyCompatibleCodingKey : CodingKey /*, RawRepresentable where Self.RawValue == String*/ {
    static var discriminatorKey: Self { get }
}

public struct PolymorphicDictionaryEntry<DictionaryKey, PC> where DictionaryKey: Hashable & Codable, PC: PolyCodable {
    let key: DictionaryKey
    let value: PC
}

public protocol PolymorphicDiscriminator : Codable, RawRepresentable where Self.RawValue == String {
    func decode<PC: PolyCodable, Key: CodingKey>( from container: KeyedDecodingContainer<Key>, forKey key: Key) throws -> PC

    func decodeNext<PC: PolyCodable>( from container: inout UnkeyedDecodingContainer ) throws -> PC
}

public protocol PolyCodable: Codable {
    associatedtype TypeDescriminator: PolymorphicDiscriminator
    associatedtype PolyCodingKey: PolyCompatibleCodingKey
}



















































//KeyedDecodingContainer<K> : KeyedDecodingContainerProtocol where K : CodingKey

/*
public func decodePolymorphicIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : PolyCodable {
    guard let descriminatorContainer = try decodeIfPresent( PolyCodableDescriminatorContainer<T>.self, forKey: key ) else {
        return nil
    }

    return try descriminatorContainer.typeDescriminator.decode( from: self, forKey: key )
}

public func decodePolymorphic<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T : PolyCodable {

    let descriminatorContainer = try decode( PolyCodableDescriminatorContainer<T>.self, forKey: key )
    return try descriminatorContainer.typeDescriminator.decode( from: self, forKey: key )
}

// TODO: decode Polymorphic Arrays

// TODO: decode Polymorphic Dictionaries



func decodeDescrimintorContainer<T>(forKey key: K) throws -> PolyCodableDescriminatorContainer<T> where T : PolyCodable {
    var descriminatorContainer: PolyCodableDescriminatorContainer<T>?

    do {
        descriminatorContainer = try decodeIfPresent( PolyCodableDescriminatorContainer<T>.self, forKey: key )

        var possibleSuperDecoder = try superDecoder()

        while possibleSuperDecoder == nil {
            do {
                descriminatorContainer = try PolyCodableDescriminatorContainer<T>(from: possibleSuperDecoder)

                if let descriminatorContainer = descriminatorContainer



                descriminatorContainer = try     init(from decoder: Decoder) throws {
                    let values = try decoder.container(keyedBy: PC.PolyCodingKey.self)
                    typeDescriminator = try values.decode(PC.TypeDescriminator.self, forKey: PC.PolyCodingKey.discriminatorKey)
                }



            }


        } catch {


        }
    }


    return try descriminatorContainer.typeDescriminator.decode( from: self, forKey: key )
}


}
*/
