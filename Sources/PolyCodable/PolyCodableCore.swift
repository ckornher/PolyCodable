
public protocol PolymorphicDiscriminator : Codable, RawRepresentable where Self.RawValue == String {
    func decode<DC: DescriminatedCodable, Key: CodingKey>( from container: KeyedDecodingContainer<Key>, forKey key: Key) throws -> DC
}

/// The coding keys to use for the base class or common struct root.
public protocol BaseCodingKey : CodingKey /*, RawRepresentable where Self.RawValue == String*/ {
    static var discriminatorKey: Self { get }
}

public protocol DescriminatedCodable: Codable {
    associatedtype TypeDescriminator: PolymorphicDiscriminator
    associatedtype Codingkeys: BaseCodingKey
}
