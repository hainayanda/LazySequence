//
//  Sequence+Extensions.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 23/9/22.
//
// swiftlint:disable file_length

import Foundation

// MARK: Sequence + Extensions

public extension Sequence {
    /// Create new LazySequence from this instance if needed.
    /// If this instance is already LazySequence, it will just return itself
    @inlinable var lazy: LazySequence<Element> {
        self as? LazySequence<Element> ?? LazySequence(sequence: self)
    }
    
    // MARK: Unique
    
    /// Simply just shortcut to `lazy.uniqued(projection).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `uniqued` instead
    /// ```
    /// // this will have time complexity O(2n)
    /// // O(n) when in uniqueArray and another O(n) when do forEach operation
    /// myArray.unique { projecting($0) }.forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(n) since the filtering will be executed while iterating forEach
    /// myArray.lazy.uniqued { projecting($0) }.forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O(*n*) on average, where *n* is the original sequence iterator iteration count
    /// - Parameter projection: A closure that accepts an element of this sequence as its argument and returns an hashable value.
    /// - Returns: New Array with unique element coming from the original sequence with its order
    @inlinable func unique<Projection: Hashable>(byProjection projection: @escaping (Element) -> Projection) -> [Element] {
        lazy.uniqued(byProjection: projection).asArray
    }
    
    /// Simply just shortcut to `lazy.uniquedWhere(consideredSame).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `uniqued` instead
    /// ```
    /// // this will have time complexity O(n^2 + n)
    /// // O(n^2) when in uniqueArray and another O(n) when do forEach operation
    /// myArray.unique { $0.id == $0.id }.forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(n^2) since the filtering will be executed while iterating forEach
    /// myArray.lazy.uniquedWhere { $0.id == $0.id }.forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O(*n*^2) on average, where *n* is the original sequence iterator iteration count
    /// - Parameter consideredSame: A Closure that takes two elements as arguments and Bool as return value. If its return `True`, then the element will be considered the same, otherwise its not.
    /// - Returns: LazySequence that will filtering out repeating elements during its iterator iteration
    @inlinable func unique(where consideredSame: @escaping (Element, Element) -> Bool) -> [Element] {
        lazy.uniqued(where: consideredSame).asArray
    }
    
    // MARK: Symetric Difference
    
    /// Simply just shortcut to `lazy.symetricDifferenced(from: otherSequence, projection).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `symetricDifferenced` instead
    /// ```
    /// // this will have time complexity O(2k + 2l + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.symetricDifferenced(by: otherArray) { projecting($0) }.forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(2k + 2l) since the intersection check will be executed while iterating forEach
    /// myArray.lazy.symetricDifferenced(by: otherArray) { projecting($0) }.forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O( 2 (*n* + *m*) ) on average where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameters:
    ///   - otherSequence: A sequence to have a symetric difference with this sequence
    ///   - projection: A closure that accepts an element of this sequence as its argument and returns an hashable value.
    /// - Returns: Array of symetric difference element from this sequence and the given sequence
    @inlinable func symetricDifference<S: Sequence, Projection: Hashable>(
        from otherSequence: S,
        _ projection: @escaping (Element) -> Projection) -> [Element]
    where S.Element == Element {
        lazy.symetricDifferenced(from: otherSequence, projection).asArray
    }
    
    // MARK: Intersection
    
    /// Simply just shortcut to `lazy.intersectioned(with: otherSequence, projection).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `intersectioned` instead
    /// ```
    /// // this will have time complexity O(k + l + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.intersection(with: otherArray) { projecting($0) }.forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(k + l) since the intersection check will be executed while iterating forEach
    /// myArray.lazy.intersectioned(with: otherArray) { projecting($0) }.forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O(*n* + *m*) on average, where *n* is the original sequence iterator iteration count, and *m* is the intersecting sequence iterator iteration count
    /// - Parameters:
    ///   - otherSequence: A sequence to intersect with this sequence
    ///   - projection: A closure that accepts an element of this sequence as its argument and returns an hashable value.
    /// - Returns: Array of element intersecting with this sequence and given sequence
    @inlinable func intersection<S: Sequence, Projection: Hashable>(
        with otherSequence: S,
        usingProjection projection: @escaping (Element) -> Projection) -> [Element]
    where S.Element == Element {
        lazy.intersectioned(with: otherSequence, usingProjection: projection).asArray
    }
    
    /// Simply just shortcut to `lazy.intersectioned(with: otherSequence, where: consideredSame).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `intersectioned` instead
    /// ```
    /// // this will have time complexity O((k * l) + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.intersection(with: otherArray).forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(k * l) since the intersection check will be executed while iterating forEach
    /// myArray.lazy.intersectioned(with: otherArray).forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O(*n* *m*) on average, where *n* is the original sequence iterator iteration count, and *m* is the intersecting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to intersect with this sequence
    /// - Parameter consideredSame: A Closure that takes two elements as arguments and Bool as return value. If its return `True`, then the element will be considered the same, otherwise its not.
    /// - Returns: Array of element intersecting with this sequence and given sequence
    @inlinable func intersection<S: Sequence>(with otherSequence: S, where consideredSame: @escaping (Element, Element) -> Bool) -> [Element]
    where S.Element == Element {
        lazy.intersectioned(with: otherSequence, where: consideredSame).asArray
    }
    
    // MARK: Substract
    
    /// Simply just shortcut to `lazy.substracted(by: otherSequence, projection).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `substracted` instead
    /// ```
    /// // this will have time complexity O(k + l + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.lazy.substractToArray(by: otherArray) { projecting($0) }.forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(k + l) since the intersection check will be executed while iterating forEach
    /// myArray.lazy.substracted(by: otherArray) { projecting($0) }.forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O(*n* + *m*) on average, where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameters:
    ///   - otherSequence: A sequence to substract this sequence
    ///   - projection: A closure that accepts an element of this sequence as its argument and returns an hashable value.
    /// - Returns: Array of element from this sequence substracted by given sequence
    @inlinable func substract<S: Sequence, Projection: Hashable>(
        by otherSequence: S,
        usingProjection projection: @escaping (Element) -> Projection) -> [Element]
    where S.Element == Element {
        lazy.substracted(by: otherSequence, usingProjection: projection).asArray
    }
    
    /// Simply just shortcut to `lazy.substracted(by: otherSequence).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `substracted` instead
    /// ```
    /// // this will have time complexity O(k + l + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.lazy.substractToArray(by: otherArray).forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(k + l) since the intersection check will be executed while iterating forEach
    /// myArray.lazy.substracted(by: otherArray).forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O(*n* *m*) on average, where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to substract this sequence
    /// - Parameter consideredSame: A Closure that takes two elements as arguments and Bool as return value. If its return `True`, then the element will be considered the same, otherwise its not.
    /// - Returns: Array of element from this sequence substracted by given sequence
    @inlinable func substract<S: Sequence>(by otherSequence: S, where consideredSame: @escaping (Element, Element) -> Bool) -> [Element]
    where S.Element == Element {
        lazy.substracted(by: otherSequence, where: consideredSame).asArray
    }
}

// MARK: Equatable Sequence + Extensions

public extension Sequence where Element: Equatable {
    
    // MARK: Unique
    
    /// Simply just shortcut to `lazy.uniqued.asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `uniqued` instead
    /// ```
    /// // this will have time complexity O(n^2 + n)
    /// // O(n^2) when in uniquedArray and another O(n) when do forEach operation
    /// myArray.unique.forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(n^2) since the filtering will be executed while iterating forEach
    /// myArray.lazy.uniqued.forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O(*n*^2) on average, where *n* is the original sequence iterator iteration count
    @inlinable var unique: [Element] {
        lazy.uniqued.asArray
    }
    
    // MARK: Symetric Difference
    
    /// Simply just shortcut to `lazy.symetricDifferenced(from: otherSequence).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `symetricDifferenced` instead
    /// ```
    /// // this will have time complexity O((2 * k * l) + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.symetricDifferenced(by: otherArray).forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(2 * k * l) since the intersection check will be executed while iterating forEach
    /// myArray.lazy.symetricDifferenced(by: otherArray).forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O( 2 *n* *m* ) on average where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to have a symetric difference with this sequence
    /// - Returns: Array of symetric difference element from this sequence and the given sequence
    @inlinable func symetricDifference<S: Sequence>(from otherSequence: S) -> [Element]
    where S.Element == Element {
        lazy.symetricDifferenced(from: otherSequence).asArray
    }
    
    // MARK: Intersection
    
    /// Simply just shortcut to `lazy.intersectioned(with: otherSequence).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `intersectioned` instead
    /// ```
    /// // this will have time complexity O((k * l) + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.lazy.intersection(with: otherArray).forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(k * l) since the intersection check will be executed while iterating forEach
    /// myArray.lazy.intersectioned(with: otherArray).forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O(*n* *m*) on average, where *n* is the original sequence iterator iteration count, and *m* is the intersecting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to intersect with this sequence
    /// - Returns: Array of element intersecting with this sequence and given sequence
    @inlinable func intersection<S: Sequence>(with otherSequence: S) -> [Element]
    where S.Element == Element {
        lazy.intersectioned(with: otherSequence).asArray
    }
    
    // MARK: Substract
    
    /// Simply just shortcut to `lazy.substracted(by: otherSequence).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `substracted` instead
    /// ```
    /// // this will have time complexity O(k + l + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.lazy.substractToArray(by: otherArray).forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(k + l) since the intersection check will be executed while iterating forEach
    /// myArray.lazy.substracted(by: otherArray).forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O(*n* *m*) on average, where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to substract this sequence
    /// - Returns: Array of element from this sequence substracted by given sequence
    @inlinable func substract<S: Sequence>(by otherSequence: S) -> [Element]
    where S.Element == Element {
        lazy.substracted(by: otherSequence, where: ==).asArray
    }
}

// MARK: Hashable Sequence + Extensions

public extension Sequence where Element: Hashable {
    
    // MARK: Unique
    
    /// Simply just shortcut to `lazy.uniqued.asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `uniqued` instead
    /// ```
    /// // this will have time complexity O(2n)
    /// // O(n) when in uniquedArray and another O(n) when do forEach operation
    /// myArray.unique.forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(n) since the filtering will be executed while iterating forEach
    /// myArray.lazy.uniqued.forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O(*n*) on average, where *n* is the original sequence iterator iteration count
    @inlinable var unique: [Element] {
        lazy.uniqued.asArray
    }
    
    // MARK: Symetric Difference
    
    /// Simply just shortcut to `lazy.symetricDifferenced(from: otherSequence).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `symetricDifferenced` instead
    /// ```
    /// // this will have time complexity O(2k + 2l + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.symetricDifference(by: otherArray).forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(2k + 2l) since the intersection check will be executed while iterating forEach
    /// myArray.lazy.symetricDifferenced(by: otherArray).forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O( 2 (*n* + *m*) ) on average where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to have a symetric difference with this sequence
    /// - Returns: Array of symetric difference element from this sequence and the given sequence
    @inlinable func symetricDifference<S: Sequence>(from otherSequence: S) -> [Element]
    where S.Element == Element {
        lazy.symetricDifferenced(from: otherSequence).asArray
    }
    
    // MARK: Intersection
    
    /// Simply just shortcut to `lazy.intersectioned(with: otherSequence).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `intersectioned` instead
    /// ```
    /// // this will have time complexity O(k + l + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.intersection(with: otherArray).forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(k + l) since the intersection check will be executed while iterating forEach
    /// myArray.lazy.intersectioned(with: otherArray).forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O(*n* + *m*) on average, where *n* is the original sequence iterator iteration count, and *m* is the intersecting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to intersect with this sequence
    /// - Returns: Array of element intersecting with this sequence and given sequence
    @inlinable func intersection<S: Sequence>(with otherSequence: S) -> [Element]
    where S.Element == Element {
        lazy.intersectioned(with: otherSequence).asArray
    }
    
    // MARK: Substract
    
    /// Simply just shortcut to `lazy.substracted(by: otherSequence).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `substracted` instead
    /// ```
    /// // this will have time complexity O(k + l + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.lazy.substractToArray(by: otherArray).forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(k + l) since the intersection check will be executed while iterating forEach
    /// myArray.lazy.substracted(by: otherArray).forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O(*n* + *m*) on average, where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to substract this sequence
    /// - Returns: Array of element from this sequence substracted by given sequence
    @inlinable func substract<S: Sequence>(by otherSequence: S) -> [Element]
    where S.Element == Element {
        lazy.substracted(by: otherSequence).asArray
    }
}

// MARK: AnyObject Sequence + Extensions

public extension Sequence where Element: AnyObject {
    
    // MARK: Unique
    
    /// Simply just shortcut to `lazy.uniquedObjects.asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `uniquedObjects` instead
    /// ```
    /// // this will have time complexity O(2n)
    /// // O(n) when in uniquedObjectsArray and another O(n) when do forEach operation
    /// myArray.uniqueObjects.forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(n) since the filtering will be executed while iterating forEach
    /// myArray.lazy.uniquedObjects.forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O(*n*) on average, where *n* is the original sequence iterator iteration count
    @inlinable var uniqueObjects: [Element] {
        lazy.uniquedObjects.asArray
    }
    
    // MARK: Symetric Difference
    
    /// Simply just shortcut to `lazy.objectsSymetricDifferenced(from: otherSequence).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `objectsSymetricDifferenced` instead
    /// ```
    /// // this will have time complexity O(2k + 2l + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.objectsSymetricDifferenceArray(by: otherArray).forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(2k + 2l) since the intersection check will be executed while iterating forEach
    /// myArray.lazy.objectsSymetricDifferenced(by: otherArray).forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O( 2 (*n* + *m*) ) on average where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to have an object symetric difference with this sequence
    /// - Returns: Array of object symetric difference element from this sequence and the given sequence
    @inlinable func objectsSymetricDifference<S: Sequence>(from otherSequence: S) -> [Element]
    where S.Element == Element {
        lazy.objectsSymetricDifferenced(from: otherSequence).asArray
    }
    
    // MARK: Intersection
    
    /// Simply just shortcut to `lazy.objectIntersectioned(with: otherSequence).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `intersectioned` instead
    /// ```
    /// // this will have time complexity O(k + l + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.objectsIntersection(with: otherArray).forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(k + l) since the intersection check will be executed while iterating forEach
    /// myArray.lazy.objectIntersectioned(with: otherArray).forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O(*n* + *m*) on average, where *n* is the original sequence iterator iteration count, and *m* is the intersecting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to intersect with this sequence
    /// - Returns: Array of objects intersecting with this sequence and given sequence
    @inlinable func objectsIntersection<S: Sequence>(with otherSequence: S) -> [Element]
    where S.Element == Element {
        lazy.objectIntersectioned(with: otherSequence).asArray
    }
    
    // MARK: Substract
    
    /// Simply just shortcut to `lazy.objectsSubstracted(by: otherSequence).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `substracted` instead
    /// ```
    /// // this will have time complexity O(k + l + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.lazy.objectsSubstractedToArray(by: otherArray).forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(k + l) since the intersection check will be executed while iterating forEach
    /// myArray.lazy.objectsSubstracted(by: otherArray).forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O(*n* + *m*) on average, where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to substract this sequence
    /// - Returns: Array of object from this sequence substracted by given sequence
    @inlinable func objectsSubstract<S: Sequence>(by otherSequence: S) -> [Element]
    where S.Element == Element {
        lazy.objectsSubstracted(by: otherSequence).asArray
    }
}
