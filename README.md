# PolyCodable
Easy to use, safe support for polymorphic Swift codables.

## A Natural Extension to the _Codable_ API.
`PolyCodable` is optimized to simplify the use of polymorphic classes, while minimizing the work required to define them.

A number of blog posts and other examples encode and/or decode polymorphic objects utilizing low-level features of the `Codable` APIs. `PolyCodable` minimally extends the high level `Codable` API, allowing developers to use common techniques, treating references to polymorphic objects almost exactly like any other `codable` value.

### Type Safety

The `Codable` system introduced in Swift 4 is strongly typed -- it utilizes enums for coding keys, and generics, for example. These and other choices probably reduce the chance for typos or injected logic to corrupt or interfere with encoding and decoding. The architecture of the `PolyCodable` package was chosen to fit with the `Codable` style, and add polymorphic support as seamlessly and safely as possible.

### How Are PolyCodable Classes Used?
At the call site, the code looks very similar to standard, non-polymorphic code. If class `A` and `B` descend from a common polymorphic base class:
```
class A : TheBaseClass {...}

class B : TheBaseClass {...}

```
A class `C` contains an optional and non-optional instance that can each be an `A` or a `B` could look like:
```
class C {
  let v1: TheBaseClass
  let v2: TheBaseClass?

  private enum CodingKeys: CodingKey {
    case v1
    case v2
  }
...
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    v1 = try container.decodePolymorphic( TheBaseClass.self, forKey: .v1 )
    v2 = try container.decodePolymorphicIfPresent( TheBaseClass.self, forKey: .v2 )
  }

  // No special polymorphic encoding code required (!) 
...
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

### Defining Polymorphic Classses
It is often the case that a polymorphic class tree is self-contained and can, therefore, share an arbitrary base class. The PolyCodable package supplies a generic base class can be used to simplify the implementation of these systems. If the base class is "empty", a typealias can be used to define the parent class:
```
typealias PolymorphicBaseClass<MRPMessageType, AbstractMessageCodingKey>
```

***More Coming Soon***

## Some Details

### Classes Only
Polymorphism is normally associated with classes. It is possible to create other related entities with characteristics similar to polymorphic classes, but this package only supports polymorphic classes. Pure Swift classes and NSObject-based classes are supported.

### Simple Support for Common Use Cases  
