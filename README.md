# Chary

LazySequence is

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

Chary is available through [CocoaPods](https://cocoapods.org). To install
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

Pharos is available under the MIT license. See the LICENSE file for more info.

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

The code above will do all the task one by one sequentially and create intermediate array in between operation:

- map each element using transformElement function
- create array and put all the mapped element there
- filter each element using includeElement function
- create array and put all the filtered element there
- iterate the array

This operation atleast will have time complexity of O(2n + m) where n is the length of the original array and m is the length of filtered array.

Using LazySequence will look somewhat similiar but with better time complexity. All you have to do is to access `lazy` from any array or sequence, it will then create a new LazySequence object where you can access any lazy operation from that object:

```swift
myArray.lazy.mapped(transformElement)
    .filtered(includeElement)
    .forEach {
        print("$0")
    }
```

This will do map and filter for each element in one iteration without creating an intermediate array:

- iterate array
  - map the element
  - filter the element
  - run task in foreach block if element is included

This operation will have time complexity of O(n) where n is the length of the original array.

## Basic Operation

There's some basic iteration operation that supported by LazySequence:

- `combined(with:)` equivalent of `append(contentsOf:)`. Iterating it will have time complexity of O(n + m) where m is the iterating time complexity of the given sequence
- `mapped(_:)` equivalent of `map(_:)`. Iterating it will have time complexity of O(n)
- `compactMapped(_:)` equivalent of `compactMap(_:)`. Iterating it will have time complexity of O(n)
- `filtered(_:)` equivalent of `filter(_:)`. Iterating it will have time complexity of O(n)
- `sortedSequence(_:)` equivalent of `sorted(_:)`. Iterating it will have time complexity of O(n log n)

## Time Complexity

Since this is a LazySequence, creating LazyOperation and modify this sequence will have time complexity **O(1)**.
Calculating total combination operation time complexity is not additive, but by nesting the time complexity one to another. Example:

- `array.lazy.mapped(transform).filtered(filter)` iterating mapped sequence will have time complexity of O(n) and filtered will have time complexity O(n), since the n is time complexity of the previous operation, n in mapped will be n too, so the total iterating time complexity will be O(n)
- `array.lazy.sortedSequence().mapped(transform)` iterating sorted sequence will have time complexity of O(n log n) and mapped will have time complexity O(n), since the n is time complexity of the previous operation, n in mapped will be n log n, so the total iterating time complexity will be O(n log n)
- `array.lazy.combined(with: otherArray).filtered(filter).sortedSequence()` iterating combined sequence will have time complexity of O(n + m) and filtered will have time complexity O(n), since the n is time complexity of the previous operation, n in filtered will be n + m, so the time complexity for iterating filtered will be O(n + m). Iterating filtered sequence will have time complexity of O(n log n), so the total iterating time complexity will be O((n + m) log (n + m))

## Unique

You can filter out repeating element in the sequence lazily. But Iterating it will have different time complexity based on the type of the element:

- `uniqued(byProjection:)` will need projection closure to generate `Hashable` projection for differentiating the elements. Iterating it will have time complexity of O(n) on average
- `uniqued(where:)` will need comparison closure that will be use for differentiating the elements. Iterating it will have time complexity of O(n^2)
- `uniqued` property is available on `Equatable` sequence. Iterating it will have time complexity of O(n*2)
- `uniqued` property is available on `Hashable` sequence. Iterating it will have time complexity of O(n) on average
- `uniquedObjects` property is available on sequence with class type element. Iterating it will have time complexity of O(n) on average

## Logical Relationship Between Sequence

You can do logical relationship operation using lazy sequence:

- `substracted(by:)` will substract the sequence with another sequence. available on sequnce of `Hashable` and `Equatable`. Iterating it will have time complexity O(n m) for `Equatable` and O(n + m) on average for `Hashable`, where m is the iterating time complexity of the given sequence.
- `objectsSubstracted(by:)` will substract the sequence with another sequence based on the instance. available on sequence of class type element. Iterating it will have time complexity O(n + m) on average, where m is the iterating time complexity of the given sequence.
- `substracted(by:usingProjection:)` will need projection closure to generate `Hashable` projection for differentiating the elements. Iterating it will have time complexity of O(n + m) on average, where m is the iterating time complexity of the given sequence.
- `substracted(by:where:)` will need comparison closure that will be use for differentiating the elements Iterating it will have time complexity of O(n m) on average, where m is the iterating time complexity of the given sequence.
- `symetricDifferenced(from:)` will iterate symetric difference between two sequence. available on sequnce of `Hashable` and `Equatable`. Iterating it will have time complexity O(2 n m) for `Equatable` and O(2n + 2m) on average for `Hashable`, where m is the iterating time complexity of the given sequence.
- `objectsSymetricDifferenced(from:)` will iterate symetric difference between two sequence based on the instance. available on sequence of class type element. Iterating it will have time complexity O(n + m) on average, where m is the iterating time complexity of the given sequence.
- `symetricDifferenced(from:_:)` will need projection closure to generate `Hashable` projection for differentiating the elements. Iterating it will have time complexity of O(2n + 2m) on average, where m is the iterating time complexity of the given sequence.
- `symetricDifferenced(from:where:)` will need comparison closure that will be use for differentiating the elements Iterating it will have time complexity of O(2 n m) on average, where m is the iterating time complexity of the given sequence.

***

## Contribute

You know-how. Just clone and do a pull request
