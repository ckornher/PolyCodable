# PolyCodable
Easy to use, safe support for polymorphic Swift codables.

## A Natural Extension to the _Codable_ APIs.
**PolyCodable** is a package that extends the Swift `Codable` APIs. It is optimized to simplify the use of polymorphic classes, while minimizing the work required to define them.

**PolyCodable** minimally extends the high level `Codable` API, allowing developers to use common techniques, treating references to polymorphic objects almost exactly like any other `Codable` value. Developers have to only implement a single enum with 3 methods to support polymorphism, using the defaults.

### Type Safety
The `Codable` system introduced in Swift 4 is strongly typed -- it utilizes enums for coding keys, and generics, for example. The architecture of the **PolyCodable** package was chosen to fit with the `Codable` style, and add polymorphic support as seamlessly and safely as possible.


## Alternatives
A number of blog posts and other examples encode and/or decode polymorphic objects utilizing low-level features of the `Codable` APIs. Here is a good example: https://medium.com/tsengineering/swift-4-0-codable-decoding-subclasses-inherited-classes-heterogeneous-arrays-ee3e180eb556

This requires a few lines of code and is not very difficult, but it has a few disadvantages:

* Polymorphism is handled by containing types. The type of a Swift class is an intrinsic property of a class, not collections that contain them. This can lead to maintainability issues and duplicated code. In the example below the decoding logic is used three times, with different `Codable` APIs. Using this technique for class `C` would be significantly more complex.

* Embedding decoding logic in types where polymorphic types are referenced complicates the use of code generators like https://github.com/krzysztofzablocki/Sourcery.

* Decoding "naked" (an array at the root of a JSON document) arrays of polymorphic objects  would require custom code for each base class. **Note:** Polycodable does not support Naked arrays, but it is planned.

## How Are PolyCodable Classes Used?
At the call site, the code looks very similar to standard, non-polymorphic code. For Example, if class `A` and `B` descend from a common base class:
```
class A : MyBaseClass {...}
class B : MyBaseClass {...}
```
A class `C` containing a reference, an optional reference, and an array that can each refer to `A`s or a `B`s could look like:
```
class C : Codable {
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
		"typeDescriminator": "a",
		...
	},
	"v2": {
		"typeDescriminator": "b",
		...
	},
	"array": [
	  	{
		"typeDescriminator": "b",
		...
		}
	]
}
```

`"typeDescriminator"` is the default key for this value in PolyCodable, the name was chosen to avoid conflicts with with existing code, and to be descriptive. It can be easily changed.


> **Note**:
> PolyCodable does not support classes that use Codable's "super" encoders and decoders, i.e. lines like: `let superEncoder = container.superEncoder(); try super.encode(to: superEncoder)` will not work for `PolyCodable` classes. "Super" encoders and decoders are not required for class hierarchies of any depth.

The **PolyCodable** package works by decoding a struct containing just the `typeDescriminator` value, then decoding the class associated with the value that was decoded. Using a struct ensures that polymorphic classes will be decoded with the same type-safety guarantees as other `Codable`s.

## How Are PolyCodable Classes Defined?

### Using the Default Base Class
Base classes that can use the default key: `"typeDescriminator"` as shown above, can use the simple base class definition:

```
typealias MyBaseClass = DefaultKeyedPolymorphicClass<MyClassType> 
```
`MyClassType` is an enum that implements the `PolymorphicDiscriminator` protocol 

### The Discriminator Enum Protocol
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

The functions in this protocol call different generic decoding methods. The implementation of this protocol for the example could look like this:
```
enum MyClassType: String, PolymorphicDiscriminator {
  case a
  case b

  func from<PC: PolyCodable>( _ data: Data, jsonDecoder decoder: JSONDecoder ) throws -> PC {
    switch( self ) {
    case .a:
      return try decoder.decode( A.self, from: data ) as! PC
    case .b:
      return try decoder.decode( B.self, from: data ) as! PC
    }
  }


  func decode<PC, Key>(from container: KeyedDecodingContainer<Key>, forKey key: Key) throws -> PC
      where PC : PolyCodable, Key: CodingKey {
    switch( self ) {
    case .a:
      return try container.decode( A.self, forKey: key ) as! PC
    case .b:
      return try container.decode( B.self, forKey: key ) as! PC
    }
  }

  func decodeNext<PC: PolyCodable>( from container: inout UnkeyedDecodingContainer ) throws -> PC {
    switch( self ) {
    case .a:
      return try container.decode( A.self ) as! PC
    case .b:
      return try container.decode( B.self ) as! PC
    }
  }
}
``` 
This code looks redundant, but the three different funcs are required because the three different `decode()` methods are generic on the type being decoded and PolyCodable adheres to the standard API as much as possible. 

> **Note**:
> The `PC` types are different for each of the generic methods in this protocol. it is possible to create methods with different `PC` classes for each of these methods. Don't do that. All the PC classes should be the same. Defining `PC` as an associated type in this protocol significantly restricted the ways that this protocol could be used and it was decided that this potential inconsistency was an acceptable tradeoff.

### Polymorphic Classes
The standard generic base class contains a property of the class type. The minimal implementations of A is:
```
class A : MyBaseClass {
  init() {
    super.init( .a )
  }
  
  required init( from decoder: Decoder ) throws {
    try super.init( from: decoder )        // decode the superclass without using super.decoder
  }
}
```

The implementation of `B` is the same. This is all the code required to use the **PolyCodable** defaults

### Base Classes with Properties
This example has omitted base class properties for brevity. Rich class hierarchies are possible. If, for example, `A` and `B` have a common property 'x' and a common base class containing x is desired, it can be easily created:
```
typealias MyPolyCodableBaseClass = DefaultKeyedPolymorphicClass<MyClassType> 

class MyAbstractBaseClass : MyPolyCodableBaseClass{
  let x: Int
  
 init( x: Int, classType: MyClassType ) {
    super.init( classType )
  }
  
  required init( from decoder: Decoder ) throws {
    let container = try decoder.container( keyedBy: CodingKeys.self )
    x = try container.decode( Int.self, forKey: .x )
	try super.init( from: decoder )        // decode the superclass without using super.decoder
  }
}

class A : MyAbstractBaseClass {
  init( x: Int ) {
    super.init( .a )
  }
}
```

## Going Beyond the Defaults

### Using A Different Value for the "Type Discriminator"
Very few (any?) data formats or existing classes use the term "typeDiscriminator" for the class type. Using another term is straightforward. Polycodable requires that this value be specified in a coding key enum:

```
public enum MyClassTypeCodingKey : PolyCompatibleCodingKey {
  case classType

  public static var discriminatorKey: MyClassTypeCodingKey = .classType
}
```
The base class is defined with that enum:

```
typealias MyPolyCodableBaseClass = PolymorphicBaseClass<MyClassTypeCodingKey, MyClassType>
```
## Pluggable Architecture
If the default behavior does not meet your needs, **PolyCodable** defines protocols that can be implemented to customize various aspects of its behavior. It may be possible to extend the default implementations of these protocols to suite your purpose. 

