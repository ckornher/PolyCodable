/// All errors thrown by this module
enum PolyCobableError: Error {
    case decriminatorNotFound
}

/// The coding keys to use for the base class or common struct root.
public protocol PolyCompatibleCodingKey : CodingKey /*, RawRepresentable where Self.RawValue == String*/ {
    static var discriminatorKey: Self { get }
}

public protocol PolymorphicDiscriminator : Codable, RawRepresentable where Self.RawValue == String {
    func decode<DC: PolyCodable, Key: CodingKey>( from container: KeyedDecodingContainer<Key>, forKey key: Key) throws -> DC
}

public protocol PolyCodable: AnyObject, Codable {
    associatedtype TypeDescriminator: PolymorphicDiscriminator
    associatedtype PolyCodingKey: PolyCompatibleCodingKey

    static func polymorphicCodingScheme() -> PolymorphicCodingScheme
}


public protocol PolymorphicCodingScheme : class {
    /// Decode polymorphically from a standard KeyedDecodingContainer using one of the standard methods.
    /// This method can be re-implemented for custom poymorphic coding schemes.  The key enum in this container must contain the descrimintor key.
    func polymorphicDecode<Key, PC>(from container: KeyedDecodingContainer<Key>, forKey key: Key) throws -> PC where PC : PolyCodable, Key : CodingKey
}

class StandardPolymorphicCodingScheme<CodedType> : PolymorphicCodingScheme where CodedType: PolyCodable{


    func polymorphicDecode<Key, PC>(from container: KeyedDecodingContainer<Key>,
                                    forKey key: Key) throws -> PC where PC : PolyCodable, Key : CodingKey {
        let descrimintor = try decodeDescrimintor(from: container, forKey: key) as! PC.TypeDescriminator
        return try descrimintor.decode(from: container, forKey: key)
    }

    func decodeDescrimintor<Key>( from container: KeyedDecodingContainer<Key>,
                                  forKey key: Key ) throws -> CodedType.TypeDescriminator {
        let descriminator = try decodeDescrimintorIfPresent( from: container, forKey: key)

        if let descriminator = descriminator {
            return descriminator
        }

        throw PolyCobableError.decriminatorNotFound
    }

    func decodeDescrimintorIfPresent<Key>( from container: KeyedDecodingContainer<Key>,
                                           forKey key: Key ) throws ->CodedType.TypeDescriminator? {
        return try container.decodeIfPresent( PolyCodableDescriminatorContainer<CodedType>.self, forKey: key )?.typeDescriminator
    }
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
