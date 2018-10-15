# PolyCodable
Easy to use, safe support for polymorphic Swift codables. One of the primary goals has been minimize changes to standard Codable coding style and APIs.

## A Natural Extension to the _Codable_ APIs.
`PolyCodable` is a package that extends the Swift `Codable` APIs. It is optimized to simplify the use of polymorphic classes, while minimizing the work required to define them.

A number of blog posts and other examples encode and/or decode polymorphic objects utilizing low-level features of the `Codable` APIs. `PolyCodable` minimally extends the high level `Codable` API, allowing developers to use common techniques, treating references to polymorphic objects almost exactly like any other `codable` value.

### Type Safety

The `Codable` system introduced in Swift 4 is strongly typed -- it utilizes enums for coding keys, and generics, for example. The architecture of the `PolyCodable` package was chosen to fit with the `Codable` style, and add polymorphic support as seamlessly and safely as possible.

## How Are PolyCodable Classes Used?
At the call site, the code looks very similar to standard, non-polymorphic code. If class `A` and `B` descend from a common polymorphic base class:
```
class A : MyBaseClass {...}
class B : MyBaseClass {...}
```
A class `C` containing a reference, an optional reference, and an array that can each refer to `A`s or a `B`s could look like:
```
class C {
  let v1: MyBaseClass
  let v2: MyBaseClass?
  let array: [MyBaseClass]

  private enum CodingKeys: CodingKey {
    case v1
    case v2
    case array
  }
...
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    v1 = try container.decodePolymorphic( MyBaseClass.self, forKey: .v1 )
    v2 = try container.decodePolymorphicIfPresent( MyBaseClass.self, forKey: .v2 )
    array = try container.decodePolymorphic( [MyBaseClass].self, forKey: .array )
  }

  // No special polymorphic encoding code required (!) 
}
```
Of course, there is a bit more work required to define the `PolyCodable` classes, but this is all the coding required to use `Polycodable` classes that already exist. 

Variables that are not polymorphic, e.g. variables typed to one of the child classes above:
```
	...
	let v: A
	...
``` 
can be encoded and decoded just like any other `codable` value.


## How Are PolyCodable Objects Encoded?:
Polycodable supports a common technique for marshaling and unmarshaling polymorphic values: "type discriminator" values that indicate the class of the object that is being marshaled. For example, JSON for an instance of `C` could look like :
```
{
	"v1": {
		"typeDescriminator": "A",
		...
	},
	"v2": {
		"typeDescriminator": "B",
		...
	},
	"array": [
	  	{
		"typeDescriminator": "B",
		...
		}
	]
}
```

`"typeDescriminator"` is the default key for this value in PolyCodable, but it can be easily changed.


> **Note**:
> PolyCodable does not support classes that use Codable's "super" encoders and decoders, i.e. lines like: `let superEncoder = container.superEncoder(); try super.encode(to: superEncoder)` will not work for `PolyCodable` classes. "Super" encoders and decoders are not required for class hierarchies of any depth. 

## How Are PolyCodable Classes Defined?

Using enums for string values that can have  that seems
```

```


### Using the Defaults
For classes that can use `"typeDescriminator"` as shown above, we can use the simple base class:













#### The discriminator enum protocol
The `PolymorphicDiscriminator` enum protocol defines the possible type discriminator values and the methods required to construct instances of the classes associated with them:
```
public protocol PolymorphicDiscriminator : Codable, RawRepresentable where Self.RawValue == String {
  func from<PC: PolyCodable>(_ data: Data,
                             jsonDecoder decoder: JSONDecoder) throws -> PC

  func decode<PC: PolyCodable, Key: CodingKey>(from container: KeyedDecodingContainer<Key>,
                                               forKey key: Key) throws -> PC

  func decodeNext<PC: PolyCodable>(from container: inout UnkeyedDecodingContainer) throws -> PC
}
```

Unfortunately, Swift's strongly typed generic encode and decode methods 


> **Note**:
> The `PC` types are different for each of the generic methods in this protocol. it is possible to create methods with different `PC` classes for each of these methods. Don't do that. All the PC classes should be the same. Earlier versions of this package had `PC` as an associated type in this protocol. This restricted the ways that this protocol could be used and it was decided that this potential inconsistency was an acceptable tradeoff.


#### The base class
It is often the case that a polymorphic class tree is self-contained and can, therefore, share an arbitrary base class. The PolyCodable package supplies a generic base class can be used to simplify the implementation of these systems. If the base class is "empty", a typealias can be used to define the parent class:

```
typealias MyBaseClass = PolymorphicBaseClass<MyClassType, MyClassTypeCodingKey> 
```

***More Coming Soon***

## Some Details

### Classes Only
Polymorphism is normally associated with classes. It is possible to create other related entities with characteristics similar to polymorphic classes, but this package only supports polymorphic classes. Pure Swift classes and NSObject-based classes are supported.

### Simple Support for Common Use Cases  
