//
//  SubtractedSequence.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 1/9/22.
//

import Foundation

// MARK: LazySequence + Extensions

public extension LazySequence {
    
    /// Create a sequence wrapper that will only iterate elements subtracted between two sequence
    /// Since it will only check subtracted elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(*n* + *m*) where *n* is the original sequence iterator iteration count, and *m* is the subtracting sequence iterator iteration count
    /// - Parameters:
    ///   - otherSequence: A sequence to subtract this sequence
    ///   - projection: A closure that accepts an element of this sequence as its argument and returns an hashable value.
    /// - Returns: LazySequence that will check subtracted element during its iterator iteration
    @inlinable func subtracted<S: Sequence, Projection: Hashable>(
        by otherSequence: S,
        usingProjection projection: @escaping (Element) -> Projection) -> LazySequence<Element>
    where S.Element == Element {
        LazySequence(
            iterator: SubtractedProjectionSequenceIterator(
                sequence: self,
                subtractedBy: otherSequence,
                projection: projection
            )
        )
    }
    
    /// Create a sequence wrapper that will only iterate elements subtracted between two sequence
    /// Since it will only check subtracted elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(*n* *m*) where *n* is the original sequence iterator iteration count, and *m* is the subtracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to subtract this sequence
    /// - Parameter consideredSame: A Closure that takes two elements as arguments and Bool as return value. If its return `True`, then the element will be considered the same, otherwise its not.
    /// - Returns: LazySequence that will check subtracted element during its iterator iteration
    @inlinable func subtracted<S: Sequence>(
        by otherSequence: S,
        where consideredSame: @escaping (Element, Element) -> Bool) -> LazySequence<Element>
    where S.Element == Element {
        LazySequence(
            iterator: SubtractedManualComparisonSequenceIterator(
                sequence: self,
                subtractedBy: otherSequence,
                consideredSame: consideredSame
            )
        )
    }
}

// MARK: Equatable LazySequence + Extensions

public extension LazySequence where Element: Equatable {
    
    /// Create a sequence wrapper that will only iterate elements subtracted between two sequence
    /// Since it will only check subtracted elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(*n* *m*) where *n* is the original sequence iterator iteration count, and *m* is the subtracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to subtract this sequence
    /// - Returns: LazySequence that will check subtracted element during its iterator iteration
    @inlinable func subtracted<S: Sequence>(by otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        subtracted(by: otherSequence, where: ==)
    }
}

// MARK: Hashable LazySequence + Extensions

public extension LazySequence where Element: Hashable {
    
    /// Create a sequence wrapper that will only iterate elements subtracted between two sequence
    /// Since it will only check subtracted elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(*n* + *m*) where *n* is the original sequence iterator iteration count, and *m* is the subtracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to subtract this sequence
    /// - Returns: LazySequence that will check subtracted element during its iterator iteration
    @inlinable func subtracted<S: Sequence>(by otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        LazySequence(
            iterator: SubstractedHashableSequenceIterator(
                sequence: self,
                subtractedBy: otherSequence
            )
        )
    }
}

// MARK: AnyObject LazySequence + Extensions

public extension LazySequence where Element: AnyObject {
    
    /// Create a sequence wrapper that will only iterate objects subtracted between two sequence
    /// Since it will only check subtracted objects when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(*n* + *m*) where *n* is the original sequence iterator iteration count, and *m* is the subtracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to subtract this sequence
    /// - Returns: LazySequence that will check subtracted object during its iterator iteration
    @inlinable func objectsSubtracted<S: Sequence>(by otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        subtracted(by: otherSequence) { ObjectIdentifier($0) }
    }
}

// MARK: SubtractedSequenceIterator

open class SubtractedSequenceIterator<BaseSequence: Sequence, SubstractSequence: Sequence>:
    LazySequenceIterator<BaseSequence.Element>
where SubstractSequence.Element == BaseSequence.Element {
    
    typealias BaseIterator = BaseSequence.Iterator
    
    var iterator: BaseIterator
    
    public init(sequence: BaseSequence) {
        self.iterator = sequence.makeIterator()
    }
    
    public override func next() -> Element? {
        guard let nextIteration = iterator.next() else {
            return nil
        }
        guard nextIfAppearsInSubstractor(for: nextIteration) else {
            return nextIteration
        }
        return next()
    }
    
    open func nextIfAppearsInSubstractor(for element: Element) -> Bool {
        fatalError("this method should be overriden")
    }
}

// MARK: SubstractedEquatableSequenceIterator

public final class SubtractedManualComparisonSequenceIterator<BaseSequence: Sequence, SubtractSequence: Sequence>:
    SubtractedSequenceIterator<BaseSequence, SubtractSequence>
where SubtractSequence.Element == BaseSequence.Element {
    public typealias Comparison = (Element, Element) -> Bool
    
    let subtractor: SubtractSequence
    let consideredSame: Comparison
    
    public init(
        sequence: BaseSequence,
        subtractedBy subtractor: SubtractSequence,
        consideredSame: @escaping Comparison) {
            self.subtractor = subtractor
            self.consideredSame = consideredSame
            super.init(sequence: sequence)
        }
    
    public override func nextIfAppearsInSubstractor(for element: Element) -> Bool {
        subtractor.contains(where: { consideredSame(element, $0) })
    }
}

// MARK: SubstractedHashableSequenceIterator

public final class SubstractedHashableSequenceIterator<BaseSequence: Sequence, SubtractSequence: Sequence>:
    SubtractedSequenceIterator<BaseSequence, SubtractSequence>
where BaseSequence.Element: Hashable,
      SubtractSequence.Element == BaseSequence.Element {
    
    typealias SubtractIterator = SubtractSequence.Iterator
    
    var subtractIterator: SubtractIterator
    var populated: [Element: Void] = [:]
    
    public init(sequence: BaseSequence, subtractedBy subtractor: SubtractSequence) {
        self.subtractIterator = subtractor.makeIterator()
        super.init(sequence: sequence)
    }
    
    public override func nextIfAppearsInSubstractor(for element: Element) -> Bool {
        guard populated[element] == nil else {
            return true
        }
        while let next = subtractIterator.next() {
            populated[next] = ()
            if next == element {
                return true
            }
        }
        return false
    }
}

// MARK: SubstractedProjectionSequenceIterator

public final class SubtractedProjectionSequenceIterator<BaseSequence: Sequence, SubtractSequence: Sequence, Projection: Hashable>:
    SubtractedSequenceIterator<BaseSequence, SubtractSequence>
where SubtractSequence.Element == BaseSequence.Element {
    
    public typealias HashProjection = (Element) -> Projection
    typealias SubtractIterator = SubtractSequence.Iterator
    
    var subtractIterator: SubtractIterator
    var populated: [Projection: Void] = [:]
    let hashProjection: HashProjection
    
    public init(
        sequence: BaseSequence,
        subtractedBy subtractor: SubtractSequence,
        projection: @escaping HashProjection) {
            self.hashProjection = projection
            self.subtractIterator = subtractor.makeIterator()
            super.init(sequence: sequence)
        }
    
    public override func nextIfAppearsInSubstractor(for element: Element) -> Bool {
        let projection = hashProjection(element)
        guard populated[projection] == nil else {
            return true
        }
        while let next = subtractIterator.next() {
            let nextProjection = hashProjection(next)
            populated[nextProjection] = ()
            if nextProjection == projection {
                return true
            }
        }
        return false
    }
}
