//
//  IntersectionSequence.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 1/9/22.
//

import Foundation

// MARK: LazySequence + Extensions

public extension LazySequence {
    
    /// Create a sequence wrapper that will only iterate elements intersecting between two sequence
    /// Since it will only check intersecting elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(*n* + *m*) where *n* is the original sequence iterator iteration count, and *m* is the intersecting sequence iterator iteration count
    /// - Parameters:
    ///   - otherSequence: A sequence to intersect with this sequence
    ///   - projection: A closure that accepts an element of this sequence as its argument and returns an hashable value.
    /// - Returns: LazySequence that will check intersecting element during its iterator iteration
    @inlinable func intersectioned<S: Sequence, Projection: Hashable>(
        with otherSequence: S,
        usingProjection projection: @escaping (Element) -> Projection) -> LazySequence<Element>
    where S.Element == Element {
        LazySequence(
            iterator: IntersectionProjectionSequenceIterator(
                sequence: self,
                intersectedBy: otherSequence,
                projection: projection
            )
        )
    }
    
    /// Create a sequence wrapper that will only iterate elements intersecting between two sequence
    /// Since it will only check intersecting elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(*n* *m*) where *n* is the original sequence iterator iteration count, and *m* is the intersecting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to intersect with this sequence
    /// - Parameter consideredSame: A Closure that takes two elements as arguments and Bool as return value. If its return `True`, then the element will be considered the same, otherwise its not.
    /// - Returns: LazySequence that will check intersecting element during its iterator iteration
    @inlinable func intersectioned<S: Sequence>(
        with otherSequence: S,
        where consideredSame: @escaping (Element, Element) -> Bool) -> LazySequence<Element>
    where S.Element == Element {
        LazySequence(
            iterator: ComparisonIntersectionSequenceIterator(
                sequence: self,
                intersectedBy: otherSequence,
                consideredSame: consideredSame
            )
        )
    }
}

// MARK: Equatable LazySequence + Extensions

public extension LazySequence where Element: Equatable {
    
    /// Create a sequence wrapper that will only iterate elements intersecting between two sequence
    /// Since it will only check intersecting elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(*n* *m*) where *n* is the original sequence iterator iteration count, and *m* is the intersecting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to intersect with this sequence
    /// - Returns: LazySequence that will check intersecting element during its iterator iteration
    @inlinable func intersectioned<S: Sequence>(with otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        intersectioned(with: otherSequence, where: ==)
    }
}

// MARK: Hashable Sequence + Extensions

public extension LazySequence where Element: Hashable {
    
    /// Create a sequence wrapper that will only iterate elements intersecting between two sequence
    /// Since it will only check intersecting elements when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(*n* + *m*) where *n* is the original sequence iterator iteration count, and *m* is the intersecting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to intersect with this sequence
    /// - Returns: LazySequence that will check intersecting element during its iterator iteration
    @inlinable func intersectioned<S: Sequence>(with otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        LazySequence(
            iterator: IntersectionHashableSequenceIterator(sequence: self, intersectedBy: otherSequence)
        )
    }
}

// MARK: AnyObject Sequence + Extensions

public extension LazySequence where Element: AnyObject {
    
    /// Create a sequence wrapper that will only iterate objects intersecting between two sequence
    /// Since it will only check intersecting objects when in iteration, the time complexity for the creation of this sequence is O(1)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have average complexity of O(*n* + *m*) where *n* is the original sequence iterator iteration count, and *m* is the intersecting sequence iterator iteration count
    /// - Parameter otherSequence: A sequence to intersect with this sequence
    /// - Returns: LazySequence that will check intersecting objects during its iterator iteration
    @inlinable func objectIntersectioned<S: Sequence>(with otherSequence: S) -> LazySequence<Element>
    where S.Element == Element {
        intersectioned(with: otherSequence) { ObjectIdentifier($0) }
    }
}

// MARK: IntersectionSequenceIterator

open class IntersectionSequenceIterator<BaseSequence: Sequence, IntersectSequence: Sequence>:
    LazySequenceIterator<BaseSequence.Element>
where IntersectSequence.Element == BaseSequence.Element {
    
    typealias BaseIterator = BaseSequence.Iterator
    
    var iterator: BaseIterator
    
    public init(sequence: BaseSequence) {
        self.iterator = sequence.makeIterator()
    }
    
    public override func next() -> Element? {
        guard let nextIteration = iterator.next() else {
            return nil
        }
        guard nextIfNotAppearsInIntersector(for: nextIteration) else {
            return nextIteration
        }
        return next()
    }
    
    open func nextIfNotAppearsInIntersector(for element: Element) -> Bool {
        fatalError("this method should be overriden")
    }
}

// MARK: IntersectionEquatableSequenceIterator

public final class ComparisonIntersectionSequenceIterator<BaseSequence: Sequence, IntersectSequence: Sequence>:
    IntersectionSequenceIterator<BaseSequence, IntersectSequence>
where IntersectSequence.Element == BaseSequence.Element {
    public typealias Comparison = (Element, Element) -> Bool
    
    let intersector: IntersectSequence
    let consideredSame: Comparison
    
    public init(
        sequence: BaseSequence,
        intersectedBy intersector: IntersectSequence,
        consideredSame: @escaping Comparison) {
            self.intersector = intersector
            self.consideredSame = consideredSame
            super.init(sequence: sequence)
        }
    
    public override func nextIfNotAppearsInIntersector(for element: IntersectionSequenceIterator<BaseSequence, IntersectSequence>.Element) -> Bool {
        !intersector.contains(where: { consideredSame(element, $0) })
    }
}

// MARK: IntersectionHashableSequenceIterator

public final class IntersectionHashableSequenceIterator<BaseSequence: Sequence, IntersectSequence: Sequence>:
    IntersectionSequenceIterator<BaseSequence, IntersectSequence>
where BaseSequence.Element: Hashable,
      IntersectSequence.Element == BaseSequence.Element {
    
    typealias IntersectIterator = IntersectSequence.Iterator
    
    var intersectIterator: IntersectIterator
    var populated: [Element: Void] = [:]
    
    public init(sequence: BaseSequence, intersectedBy intersector: IntersectSequence) {
        self.intersectIterator = intersector.makeIterator()
        super.init(sequence: sequence)
    }
    
    public override func nextIfNotAppearsInIntersector(for element: Element) -> Bool {
        guard populated[element] == nil else {
            return false
        }
        while let next = intersectIterator.next() {
            populated[next] = ()
            if next == element {
                return false
            }
        }
        return true
    }
}

// MARK: IntersectionProjectionSequenceIterator

public final class IntersectionProjectionSequenceIterator<BaseSequence: Sequence, IntersectSequence: Sequence, Projection: Hashable>:
    IntersectionSequenceIterator<BaseSequence, IntersectSequence>
where IntersectSequence.Element == BaseSequence.Element {
    
    public typealias HashProjection = (Element) -> Projection
    typealias IntersectIterator = IntersectSequence.Iterator
    
    var intersectIterator: IntersectIterator
    var populated: [Projection: Void] = [:]
    let hashProjection: HashProjection
    
    public init(
        sequence: BaseSequence,
        intersectedBy intersector: IntersectSequence,
        projection: @escaping HashProjection) {
            self.hashProjection = projection
            self.intersectIterator = intersector.makeIterator()
            super.init(sequence: sequence)
        }
    
    public override func nextIfNotAppearsInIntersector(for element: Element) -> Bool {
        let projection = hashProjection(element)
        guard populated[projection] == nil else {
            return false
        }
        while let next = intersectIterator.next() {
            let nextProjection = hashProjection(next)
            populated[nextProjection] = ()
            if nextProjection == projection {
                return false
            }
        }
        return true
    }
}
