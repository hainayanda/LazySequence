//
//  SubstractedSequence.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 1/9/22.
//

import Foundation

// MARK: LazySequence + Extensions

public extension LazySequence {
    
    /// Create a sequence wrapper that will only iterate elements substracted between two sequence
    /// Since it will only check substracted elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(*n* + *m*) where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameters:
    ///   - otherSequence: A sequence to substract this sequence
    ///   - projection: A closure that accepts an element of this sequence as its argument and returns an hashable value.
    /// - Returns: LazySequence that will check substracted element during its iterator iteration
    @inlinable func substracted<S: Sequence, Projection: Hashable>(
        by otherSequence: S,
        usingProjection projection: @escaping (Element) -> Projection) -> LazySequence<Element>
    where S.Element == Element {
        LazySequence(
            iterator: SubstractedProjectionSequenceIterator(
                sequence: self,
                substractedBy: otherSequence,
                projection: projection
            )
        )
    }
    
    /// Create a sequence wrapper that will only iterate elements substracted between two sequence
    /// Since it will only check substracted elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(*n* *m*) where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to substract this sequence
    /// - Parameter consideredSame: A Closure that takes two elements as arguments and Bool as return value. If its return `True`, then the element will be considered the same, otherwise its not.
    /// - Returns: LazySequence that will check substracted element during its iterator iteration
    @inlinable func substracted<S: Sequence>(by otherSequence: S, where consideredSame: @escaping (Element, Element) -> Bool) -> LazySequence<Element>
    where S.Element == Element {
        LazySequence(
            iterator: SubstractedManualComparisonSequenceIterator(
                sequence: self,
                substractedBy: otherSequence,
                consideredSame: consideredSame
            )
        )
    }
}

// MARK: Equatable LazySequence + Extensions

public extension LazySequence where Element: Equatable {
    
    /// Create a sequence wrapper that will only iterate elements substracted between two sequence
    /// Since it will only check substracted elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(*n* *m*) where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to substract this sequence
    /// - Returns: LazySequence that will check substracted element during its iterator iteration
    @inlinable func substracted<S: Sequence>(by otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        substracted(by: otherSequence, where: ==)
    }
}

// MARK: Hashable LazySequence + Extensions

public extension LazySequence where Element: Hashable {
    
    /// Create a sequence wrapper that will only iterate elements substracted between two sequence
    /// Since it will only check substracted elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(*n* + *m*) where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to substract this sequence
    /// - Returns: LazySequence that will check substracted element during its iterator iteration
    @inlinable func substracted<S: Sequence>(by otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        LazySequence(iterator: SubstractedHashableSequenceIterator(sequence: self, substractedBy: otherSequence))
    }
}

// MARK: AnyObject LazySequence + Extensions

public extension LazySequence where Element: AnyObject {
    
    /// Create a sequence wrapper that will only iterate objects substracted between two sequence
    /// Since it will only check substracted objects when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(*n* + *m*) where *n* is the original sequence iterator iteration count, and *m* is the substracting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to substract this sequence
    /// - Returns: LazySequence that will check substracted object during its iterator iteration
    @inlinable func objectsSubstracted<S: Sequence>(by otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        substracted(by: otherSequence) { ObjectIdentifier($0) }
    }
}

// MARK: SubstractedSequenceIterator

open class SubstractedSequenceIterator<BaseSequence: Sequence, SubstractSequence: Sequence>:  LazySequenceIterator<BaseSequence.Element>
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

public final class SubstractedManualComparisonSequenceIterator<BaseSequence: Sequence, SubstractSequence: Sequence>: SubstractedSequenceIterator<BaseSequence, SubstractSequence>
where SubstractSequence.Element == BaseSequence.Element {
    public typealias Comparison = (Element, Element) -> Bool
    
    let substractor: SubstractSequence
    let consideredSame: Comparison
    
    public init(sequence: BaseSequence, substractedBy substractor: SubstractSequence, consideredSame: @escaping Comparison) {
        self.substractor = substractor
        self.consideredSame = consideredSame
        super.init(sequence: sequence)
    }
    
    public override func nextIfAppearsInSubstractor(for element: Element) -> Bool {
        substractor.contains(where: { consideredSame(element, $0) })
    }
}

// MARK: SubstractedHashableSequenceIterator

public final class SubstractedHashableSequenceIterator<BaseSequence: Sequence, SubstractSequence: Sequence>: SubstractedSequenceIterator<BaseSequence, SubstractSequence>
where BaseSequence.Element: Hashable,
      SubstractSequence.Element == BaseSequence.Element {
    
    typealias SubstractIterator = SubstractSequence.Iterator
    
    var substractIterator: SubstractIterator
    var populated: [Element: Void] = [:]
    
    public init(sequence: BaseSequence, substractedBy substractor: SubstractSequence) {
        self.substractIterator = substractor.makeIterator()
        super.init(sequence: sequence)
    }
    
    public override func nextIfAppearsInSubstractor(for element: Element) -> Bool {
        guard populated[element] == nil else {
            return true
        }
        while let next = substractIterator.next() {
            populated[next] = ()
            if next == element {
                return true
            }
        }
        return false
    }
}

// MARK: SubstractedProjectionSequenceIterator

public final class SubstractedProjectionSequenceIterator<BaseSequence: Sequence, SubstractSequence: Sequence, Projection: Hashable>: SubstractedSequenceIterator<BaseSequence, SubstractSequence>
where SubstractSequence.Element == BaseSequence.Element {
    
    public typealias HashProjection = (Element) -> Projection
    typealias SubstractIterator = SubstractSequence.Iterator
    
    var substractIterator: SubstractIterator
    var populated: [Projection: Void] = [:]
    let hashProjection: HashProjection
    
    public init(sequence: BaseSequence, substractedBy substractor: SubstractSequence, projection: @escaping HashProjection) {
        self.hashProjection = projection
        self.substractIterator = substractor.makeIterator()
        super.init(sequence: sequence)
    }
    
    public override func nextIfAppearsInSubstractor(for element: SubstractedSequenceIterator<BaseSequence, SubstractSequence>.Element) -> Bool {
        let projection = hashProjection(element)
        guard populated[projection] == nil else {
            return true
        }
        while let next = substractIterator.next() {
            let nextProjection = hashProjection(next)
            populated[nextProjection] = ()
            if nextProjection == projection {
                return true
            }
        }
        return false
    }
}
