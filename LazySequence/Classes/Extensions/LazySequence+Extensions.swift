//
//  LazySequence+Extensions.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 2/9/22.
//

import Foundation

public extension LazySequence {
    
    /// Simply just a shortcut to `Array(self)`
    var asArray: [Element] { Array(self) }
    
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
        let right = otherSequence.lazy.substracted(by: self, usingProjection: projection)
        return left.combined(with: right)
    }
}

public extension LazySequence where Element: Equatable {
    
    /// Create a sequence wrapper that will only iterate elements symetric difference between two sequence
    /// Since it will only check symetric difference elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(2 *n* *m*) where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to have a symetric difference with this sequence
    /// - Returns: LazySequence that will check symetric difference element during its iterator iteration
    @inlinable func symetricDifferenced<S: Sequence>(from otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        let left = self.substracted(by: otherSequence)
        let right = otherSequence.lazy.substracted(by: self)
        return left.combined(with: right)
    }
}

public extension LazySequence where Element: Hashable {
    
    /// Create a sequence wrapper that will only iterate elements symetric difference between two sequence
    /// Since it will only check symetric difference elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O( 2 (*n* + *m*) ) where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to substract this sequence
    /// - Returns: LazySequence that will check symetric difference element during its iterator iteration
    @inlinable func symetricDifferenced<S: Sequence>(from otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        let left = self.substracted(by: otherSequence)
        let right = otherSequence.lazy.substracted(by: self)
        return left.combined(with: right)
    }
}

public extension LazySequence where Element: AnyObject {
    
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
