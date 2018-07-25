
public protocol PolymorphicDiscriminator : Codable, RawRepresentable where Self.RawValue == String {
    func decode<DC: PolyCodable, Key: CodingKey>( from container: KeyedDecodingContainer<Key>, forKey key: Key) throws -> DC
}

/// The coding keys to use for the base class or common struct root.
public protocol PolyCompatibleCodingKey : CodingKey /*, RawRepresentable where Self.RawValue == String*/ {
    static var discriminatorKey: Self { get }
}

public protocol PolyCodable: AnyObject, Codable {
    associatedtype TypeDescriminator: PolymorphicDiscriminator
    associatedtype PolyCodingKey: PolyCompatibleCodingKey
}
