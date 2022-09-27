# Chary

LazySequence is a sequence helper to minimize time complexity for most of the sequence operations.

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/10c13aa9eea84ed5bf73ee7ac394aca6)](https://www.codacy.com/gh/hainayanda/LazySequence/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=hainayanda/LazySequence&amp;utm_campaign=Badge_Grade)
![build](https://github.com/hainayanda/LazySequence/workflows/build/badge.svg)
![test](https://github.com/hainayanda/LazySequence/workflows/test/badge.svg)
[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen)](https://swift.org/package-manager/)
[![Version](https://img.shields.io/cocoapods/v/LazySequence.svg?style=flat)](https://cocoapods.org/pods/LazySequence)
[![License](https://img.shields.io/cocoapods/l/LazySequence.svg?style=flat)](https://cocoapods.org/pods/LazySequence)
[![Platform](https://img.shields.io/cocoapods/p/LazySequence.svg?style=flat)](https://cocoapods.org/pods/LazySequence)

## Requirements

- Swift 5.0 or higher (or 5.3 when using Swift Package Manager)
- iOS 10.0 or higher

### Only Swift Package Manager

- macOS 10.0 or higher
- tvOS 10.10 or higher

## Installation

### Cocoapods

LazySequence is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LazySequence'
```

### Swift Package Manager from XCode

- Add it using XCode menu **File > Swift Package > Add Package Dependency**
- Add **<https://github.com/hainayanda/LazySequence.git>** as Swift Package URL
- Set rules at **version**, with **Up to Next Major** option and put **1.0.0** as its version
- Click next and wait

### Swift Package Manager from Package.swift

Add as your target dependency in **Package.swift**

```swift
dependencies: [
  .package(url: "https://github.com/hainayanda/LazySequence.git", .upToNextMajor(from: "1.0.0"))
]
```

Use it in your target as `LazySequence`

```swift
 .target(
    name: "MyModule",
    dependencies: ["LazySequence"]
)
```

## Author

Nayanda Haberty, hainayanda@outlook.com

## License

LazySequence is available under the MIT license. See the LICENSE file for more info.

***

## Basic Usage

LazySequence is a sequence helper to minimize time complexity for most of the sequence operations.
What it did do is by creating a new sequence that will combine any other operation to be run later in linear time complexity if possible. example:

```swift
myArray.map(transformElement)
    .filter(includeElement)
    .forEach {
        print("$0")
    }
```

The code above will do all the task one by one sequentially and create an intermediate array in between operations:

- map each element using transformElement function
- create an array and put all the mapped elements there
- filter each element using `includeElement` function
- create an array and put all the filtered elements there
- iterate the array

This operation at least will have a time complexity of **O(2n + m)** where *n* is the length of the original array and *m* is the length of the filtered array.

Using `LazySequence` will look somewhat similar but with better time complexity. All you have to do is to access `lazy` from any array or sequence, it will then create a new `LazySequence` object where you can access any lazy operation from that object:

```swift
myArray.lazy.mapped(transformElement)
    .filtered(includeElement)
    .forEach {
        print("$0")
    }
```

This will map and filter for each element in one iteration without creating an intermediate array:

- iterate array
  - map the element
  - filter the element
  - run task in the `foreach` block if the element is included

This operation will have a time complexity of **O(n)** where *n* is the length of the original array.

Creating an array from LazySequence is as easy as calling `asArray`:

```swift
let newArray = myArray.lazy.mapped(transformElement)
    .filtered(includeElement)
    .asArray
```

## Basic Operation

Some basic iteration operations are supported by `LazySequence`:

- `combined(with:)` equivalent of `append(contentsOf:)`. Iterating it will have a time complexity of *O(n + m)* where *m* is the iterating time complexity of the given sequence
- `mapped(_:)` equivalent of `map(_:)`. Iterating it will have a time complexity of *O(n)*
- `compactMapped(_:)` equivalent of `compactMap(_:)`. Iterating it will have a time complexity of *O(n)*
- `filtered(_:)` equivalent of `filter(_:)`. Iterating it will have a time complexity of *O(n)*
- `sortedSequence(_:)` equivalent of `sorted(_:)`. Iterating it will have a time complexity of *O(n log n)*

## Time Complexity

Since this is a LazySequence, creating LazyOperation and combining operations for the sequence will have time complexity **O(1)**.
Calculating total combination operation time complexity is not additive, but by nesting the time complexity one to another. Example:

- `array.lazy.mapped(transform).filtered(filter)` iterating mapped sequence will have time complexity of *O(n)* and filtered will have time complexity *O(n)*, since the *n* is the time complexity of the previous operation, *n* in mapped will be *n* too, so the total iterating time complexity will be *O(n)*
- `array.lazy.sortedSequence().mapped(transform)` iterating sorted sequence will have time complexity of *O(n log n)* and mapped will have time complexity *O(n)*, since the *n* is the time complexity of the previous operation, *n* in mapped will be *n* log n, so the total iterating time complexity will be *O(n log n)*
- `array.lazy.combined(with: otherArray).filtered(filter).sortedSequence()` iterating combined sequence will have a time complexity of *O(n + m)* and filtered will have time complexity *O(n)*, since the *n* is the time complexity of the previous operation, *n* in filtered will be *n* + m, so the time complexity for iterating filtered will be *O(n + m)*. Iterating filtered sequence will have a time complexity of *O(n log n)*, so the total iterating time complexity will be *O((n + m)* log (n + m))

## Unique

You can filter out repeating elements in the sequence lazily. But Iterating it will have different time complexity based on the type of the element:

- `uniqued(byProjection:)` will need projection closure to generate a `Hashable` projection for differentiating the elements. Iterating it will have a time complexity of *O(n)* on average
- `uniqued(where:)` will need comparison closure that will be used for differentiating the elements. Iterating it will have a time complexity of *O(n^2)*
- `uniqued` property is available on `Equatable` sequence. Iterating it will have a time complexity of *O(n*2)*
- `uniqued` property is available on the `Hashable` sequence. Iterating it will have a time complexity of *O(n)* on average
- `uniquedObjects` property is available on sequence with class type element. Iterating it will have a time complexity of *O(n)* on average

## Logical Relationship Between Sequence

You can do a logical relationship operation using a lazy sequence:

### Substract

- `substracted(by:)` will subtract the sequence with another sequence. available on sequences of `Hashable` and `Equatable`. Iterating it will have time complexity *O(n m)* for `Equatable` and *O(n + m)* on average for `Hashable`, where *m* is the iterating time complexity of the given sequence.
- `objectsSubstracted(by:)` will subtract the sequence with another sequence based on the instance. available on the sequence of class-type elements. Iterating it will have time complexity *O(n + m)* on average, where *m* is the iterating time complexity of the given sequence.
- `substracted(by:usingProjection:)` will need projection closure to generate a `Hashable` projection for differentiating the elements. Iterating it will have a time complexity of *O(n + m)* on average, where *m* is the iterating time complexity of the given sequence.
- `substracted(by:where:)` will need a comparison closure that will be used for differentiating the elements Iterating it will have a time complexity of *O(n m)* on average, where *m* is the iterating time complexity of the given sequence.

### Intersection

- `intersectioned(with:)` will intersect the sequence with another sequence. available on sequences of `Hashable` and `Equatable`. Iterating it will have time complexity *O(n m)* for `Equatable` and *O(n + m)* on average for `Hashable`, where *m* is the iterating time complexity of the given sequence.
- `objectsIntersectioned(with:)` will intersect the sequence with another sequence based on the instance. available on the sequence of a class-type element. Iterating it will have time complexity *O(n + m)* on average, where *m* is the iterating time complexity of the given sequence.
- `intersectioned(with:usingProjection:)` will need projection closure to generate a `Hashable` projection for differentiating the elements. Iterating it will have a time complexity of *O(n + m)* on average, where *m* is the iterating time complexity of the given sequence.
- `intersectioned(with:where:)` will need a comparison closure that will be used for differentiating the elements Iterating it will have a time complexity of *O(n m)* on average, where *m* is the iterating time complexity of the given sequence.

### Symetric Difference

- `symmetricDifferenced(from:)` will iterate the symmetric difference between two sequences. available on sequences of `Hashable` and `Equatable`. Iterating it will have time complexity *O(2 n m)* for `Equatable` and *O(2n + 2m)* on average for `Hashable`, where *m* is the iterating time complexity of the given sequence.
- `objectsSymmetricDifferenced(from:)` will iterate symmetric difference between two sequences based on the instance. available on the sequence of class-type elements. Iterating it will have time complexity *O(n + m)* on average, where *m* is the iterating time complexity of the given sequence.
- `symmetricDifferenced(from:_:)` will need projection closure to generate a `Hashable` projection for differentiating the elements. Iterating it will have a time complexity of *O(2n + 2m)* on average, where *m* is the iterating time complexity of the given sequence.
- `symmetricDifferenced(from:where:)` will need a comparison closure that will be used for differentiating the elements Iterating it will have a time complexity of *O(2 n m)* on average, where *m* is the iterating time complexity of the given sequence.

## Dropping

You can skip certain elements for iteration by using:

- `droppedFirst(_:)` which will skip the first *n* element
- `droppedUntil(found:)` which will skip all elements until the element is found
- `droppedUntil(objectFound:)` which will skip all elements until the object is found
- `droppedUntilEnumerated(found:)` same like droppedUntil but enumerated

All will have time complexity *O(n)* when iterated

## Prefix

You can prefix the LazySequennce by using:

- `capped(atMaxIteration:)` which will make sure the iteration will be capped at the given iteration count
- `prefixedUntil(found:)` which will iterate all elements until the element is found
- `prefixedUntil(objectFound:)` which will iterate all elements until the object is found
- `prefixedUntilEnumerated(found:)` same like prefixedUntil but enumerated

All will have time complexity *O(n)* when iterated

## Interpolate

You can insert elements for each iteration interval by using:

- `inserted(forEach:element:)` which will insert the element for each iteration intervals
- `inserted(forEach:elements:)` which will insert the elements for each iteration intervals

Example:

```swift
let myArray = [1, 2, 3, 4]

// the output will be "1", "0", "2", "0", "3", "0", "4", "0"
myArray.lazy.inserted(forEach: 1, element: 0).forEach { 
    print($0)
}
```

## Extra

The sorting algorithm used in this LazySequence is using a `DoublyLinkedList` to improve the performance. This class is public so anyone can use it while importing `LazySequence`. This DoublyLinkedList is designed to be thread-safe.

***

## Contribute

You know-how. Just clone and do a pull request
