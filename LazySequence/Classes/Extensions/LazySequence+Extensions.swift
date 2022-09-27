//
//  LazySequence+Extensions.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 2/9/22.
//

import Foundation

public extension LazySequence {
    
    /// Simply just a shortcut to `Array(self)`
    @inlinable var asArray: [Element] { Array(self) }
    
    /// Create a sequence wrapper that will only iterate elements symmetric difference between two sequence
    /// Since it will only check symmetric difference elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O( 2 (*n* + *m*) ) where *n* is the original sequence iterator iteration count, and *m* is the subtracting sequence iterator iteration count
    /// - Parameters:
    ///   - otherSequence: A sequence to have a symmetric difference with this sequence
    ///   - projection: A closure that accepts an element of this sequence as its argument and returns an hashable value.
    /// - Returns: LazySequence that will check symmetric difference element during its iterator iteration
    @inlinable func symmetricDifferenced<S: Sequence, Projection: Hashable>(
        from otherSequence: S,
        _ projection: @escaping (Element) -> Projection) -> LazySequence<Element>
    where S.Element == Element {
        let left = self.subtracted(by: otherSequence, usingProjection: projection)
        let right = otherSequence.lazy.subtracted(by: self, usingProjection: projection)
        return left.combined(with: right)
    }
    
    /// Create a sequence wrapper that will only iterate elements symmetric difference between two sequence
    /// Since it will only check symmetric difference elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O( 2 *n* *m* ) where *n* is the original sequence iterator iteration count, and *m* is the subtracting sequence iterator iteration count
    /// - Parameters:
    ///   - otherSequence: A sequence to have a symmetric difference with this sequence
    ///   - consideredSame: consideredSame: A Closure that takes two elements as arguments and Bool as return value. If its return `True`, then the element will be considered the same, otherwise its not.
    /// - Returns: LazySequence that will check symmetric difference element during its iterator iteration
    @inlinable func symmetricDifferenced<S: Sequence>(
        from otherSequence: S,
        where consideredSame: @escaping (Element, Element) -> Bool) -> LazySequence<Element>
    where S.Element == Element {
        let left = self.subtracted(by: otherSequence, where: consideredSame)
        let right = otherSequence.lazy.subtracted(by: self, where: consideredSame)
        return left.combined(with: right)
    }
}

public extension LazySequence where Element: Equatable {
    
    /// Create a sequence wrapper that will only iterate elements symmetric difference between two sequence
    /// Since it will only check symmetric difference elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(2 *n* *m*) where *n* is the original sequence iterator iteration count, and *m* is the subtracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to have a symmetric difference with this sequence
    /// - Returns: LazySequence that will check symmetric difference element during its iterator iteration
    @inlinable func symmetricDifferenced<S: Sequence>(from otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        let left = self.subtracted(by: otherSequence)
        let right = otherSequence.lazy.subtracted(by: self)
        return left.combined(with: right)
    }
}

public extension LazySequence where Element: Hashable {
    
    /// Create a sequence wrapper that will only iterate elements symmetric difference between two sequence
    /// Since it will only check symmetric difference elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O( 2 (*n* + *m*) ) where *n* is the original sequence iterator iteration count, and *m* is the subtracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to subtract this sequence
    /// - Returns: LazySequence that will check symmetric difference element during its iterator iteration
    @inlinable func symmetricDifferenced<S: Sequence>(from otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        let left = self.subtracted(by: otherSequence)
        let right = otherSequence.lazy.subtracted(by: self)
        return left.combined(with: right)
    }
}

public extension LazySequence where Element: AnyObject {
    
    /// Create a sequence wrapper that will only iterate objects symmetric difference between two sequence
    /// Since it will only check symmetric difference objects when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O( 2 (*n* + *m*) )  where *n* is the original sequence iterator iteration count, and *m* is the subtracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to have an object symmetric difference with this sequence
    /// - Returns: LazySequence that will check symmetric difference object during its iterator iteration
    @inlinable func objectsSymmetricDifferenced<S: Sequence>(from otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        symmetricDifferenced(from: otherSequence) { ObjectIdentifier($0) }
    }
}
