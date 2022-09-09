//
//  Sequence+Extensions.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 2/9/22.
//

import Foundation

public extension Sequence {
    
    /// Simply just a shortcut to `self as? [Element] ?? Array(self)`
    var asArray: [Element] {
        self as? [Element] ?? Array(self)
    }
    
    /// Simply just shortcut to `symetricDifferenced(from: otherSequence, projection).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `symetricDifferenced` instead
    /// ```
    /// // this will have time complexity O(2k + 2l + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.symetricDifferenced(by: otherArray) { projecting($0) }.forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(2k + 2l) since the intersection check will be executed while iterating forEach
    /// myArray.symetricDifferenced(by: otherArray) { projecting($0) }.forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O( 2 (*n* + *m*) ) on average where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameters:
    ///   - otherSequence: A sequence to have a symetric difference with this sequence
    ///   - projection: A closure that accepts an element of this sequence as its argument and returns an hashable value.
    /// - Returns: Array of symetric difference element from this sequence and the given sequence
    @inlinable func symetricDifferencedArray<S: Sequence, Projection: Hashable>(
        from otherSequence: S,
        _ projection: @escaping (Element) -> Projection) -> [Element]
    where S.Element == Element {
        symetricDifferenced(from: otherSequence, projection).asArray
    }
    
    /// Create a sequence wrapper that will only iterate elements symetric difference between two sequence
    /// Since it will only check symetric difference elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O( 2 (*n* + *m*) ) where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameters:
    ///   - otherSequence: A sequence to have a symetric difference with this sequence
    ///   - projection: A closure that accepts an element of this sequence as its argument and returns an hashable value.
    /// - Returns: LazySequence that will check symetric difference element during its iterator iteration
    @inlinable func symetricDifferenced<S: Sequence, Projection: Hashable>(
        from otherSequence: S,
        _ projection: @escaping (Element) -> Projection) -> LazySequence<Element>
    where S.Element == Element {
        let left = self.substracted(by: otherSequence, usingProjection: projection)
        let right = otherSequence.substracted(by: self, usingProjection: projection)
        return left.combined(with: right)
    }
}

public extension Sequence where Element: Equatable {
    
    /// Simply just shortcut to `symetricDifferenced(from: otherSequence).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `symetricDifferenced` instead
    /// ```
    /// // this will have time complexity O((2 * k * l) + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.symetricDifferenced(by: otherArray).forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(2 * k * l) since the intersection check will be executed while iterating forEach
    /// myArray.symetricDifferenced(by: otherArray).forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O( 2 *n* *m* ) on average where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to have a symetric difference with this sequence
    /// - Returns: Array of symetric difference element from this sequence and the given sequence
    @inlinable func symetricDifferencedArray<S: Sequence>(from otherSequence: S) -> [Element]
    where S.Element == Element {
        symetricDifferenced(from: otherSequence).asArray
    }
    
    /// Create a sequence wrapper that will only iterate elements symetric difference between two sequence
    /// Since it will only check symetric difference elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(2 *n* *m*) where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to have a symetric difference with this sequence
    /// - Returns: LazySequence that will check symetric difference element during its iterator iteration
    @inlinable func symetricDifferenced<S: Sequence>(from otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        let left = self.substracted(by: otherSequence)
        let right = otherSequence.substracted(by: self)
        return left.combined(with: right)
    }
}

public extension Sequence where Element: Hashable {
    
    /// Simply just shortcut to `symetricDifferenced(from: otherSequence).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `symetricDifferenced` instead
    /// ```
    /// // this will have time complexity O(2k + 2l + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.symetricDifferenced(by: otherArray).forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(2k + 2l) since the intersection check will be executed while iterating forEach
    /// myArray.symetricDifferenced(by: otherArray).forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O( 2 (*n* + *m*) ) on average where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to have a symetric difference with this sequence
    /// - Returns: Array of symetric difference element from this sequence and the given sequence
    @inlinable func symetricDifferencedArray<S: Sequence>(from otherSequence: S) -> [Element]
    where S.Element == Element {
        symetricDifferenced(from: otherSequence).asArray
    }
    
    /// Create a sequence wrapper that will only iterate elements symetric difference between two sequence
    /// Since it will only check symetric difference elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O( 2 (*n* + *m*) ) where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to substract this sequence
    /// - Returns: LazySequence that will check symetric difference element during its iterator iteration
    @inlinable func symetricDifferenced<S: Sequence>(from otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        let left = self.substracted(by: otherSequence)
        let right = otherSequence.substracted(by: self)
        return left.combined(with: right)
    }
}

public extension Sequence where Element: AnyObject {
    
    /// Simply just shortcut to `objectsSymetricDifferenced(from: otherSequence).asArray`
    /// Keep in mind this will automatically run the iterator iteration when creating an new Array.
    /// If you just need to iterate the element uniquely, consider using `objectsSymetricDifferenced` instead
    /// ```
    /// // this will have time complexity O(2k + 2l + m) where k is myArray length, l is otherArray length and m is intersection array length
    /// myArray.objectsSymetricDifferenceArray(by: otherArray).forEach {
    ///     print($0)
    /// }
    ///
    /// // this will have time complexity O(2k + 2l) since the intersection check will be executed while iterating forEach
    /// myArray.objectsSymetricDifferenced(by: otherArray).forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: O( 2 (*n* + *m*) ) on average where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to have an object symetric difference with this sequence
    /// - Returns: Array of object symetric difference element from this sequence and the given sequence
    @inlinable func objectsSymetricDifferenceArray<S: Sequence>(from otherSequence: S) -> [Element]
    where S.Element == Element {
        objectsSymetricDifferenced(from: otherSequence).asArray
    }
    
    /// Create a sequence wrapper that will only iterate objects symetric difference between two sequence
    /// Since it will only check symetric difference objects when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O( 2 (*n* + *m*) )  where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to have an object symetric difference with this sequence
    /// - Returns: LazySequence that will check symetric difference object during its iterator iteration
    @inlinable func objectsSymetricDifferenced<S: Sequence>(from otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        symetricDifferenced(from: otherSequence) { ObjectIdentifier($0) }
    }
}
