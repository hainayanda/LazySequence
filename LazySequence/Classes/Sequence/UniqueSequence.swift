//
//  UniqueSequence.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 31/8/22.
//

import Foundation

// MARK: LazySequence + Extensions

public extension LazySequence {
    
    /// Create a sequence wrapper that will filter out repeating elements during iterator iteration.
    /// Since it will only filtering when in iteration, the time complexity for the creation of this sequence is O(1).
    /// Filtering duplicates will be using a hash, so on average time complexity for iterating this sequence will be around O(n) or on worst case will be O(log n)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have complexity of O(*n*) on average where *n* is the original sequence iterator iteration count
    /// - Parameter projection: A closure that accepts an element of this sequence as its argument and returns an hashable value.
    /// - Returns: LazySequence that will filtering out repeating elements during its iterator iteration
    @inlinable func uniqued<Projection: Hashable>(byProjection projection: @escaping (Element) -> Projection) -> LazySequence<Element> {
        LazySequence(iterator: UniqueProjectionSequenceIterator(sequence: self, projection: projection))
    }
    
    /// Create a sequence wrapper that will filter out repeating elements during iterator iteration.
    /// Since it will only filtering when in iteration, the time complexity for the creation of this sequence is O(1).
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have complexity of O(*n*^2) on average where *n* is the original sequence iterator iteration count
    /// - Parameter consideredSame: A Closure that takes two elements as arguments and Bool as return value. If its return `True`, then the element will be considered the same, otherwise its not.
    /// - Returns: LazySequence that will filtering out repeating elements during its iterator iteration
    @inlinable func uniqued(where consideredSame: @escaping (Element, Element) -> Bool) -> LazySequence<Element> {
        LazySequence(
            iterator: UniqueManualComparisonSequenceIterator(
                sequence: self,
                where: consideredSame
            )
        )
    }
}

// MARK: Equatable LazySequence + Extensions

public extension LazySequence where Element: Equatable {
    
    /// Create a sequence wrapper that will filter out repeating elements during iterator iteration.
    /// Since it will only filtering when in iteration, the time complexity for the creation of this sequence is O(1).
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have complexity of O(*n*^2) on average where *n* is the original sequence iterator iteration count
    @inlinable var uniqued: LazySequence<Element> {
        uniqued(where: ==)
    }
}

// MARK: Hashable LazySequence + Extensions

public extension LazySequence where Element: Hashable {
    
    /// Create a sequence wrapper that will filter out repeating elements during iterator iteration.
    /// Since it will only filtering when in iteration, the time complexity for the creation of this sequence is O(1).
    /// Filtering duplicates will be using a hash, so on average time complexity for iterating this sequence will be around O(n) or on worst case will be O(log n)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have complexity of O(*n*) on average where *n* is the original sequence iterator iteration count
    @inlinable var uniqued: LazySequence<Element> {
        LazySequence(iterator: UniqueHashableSequenceIterator(sequence: self))
    }
}

// MARK: AnyObject LazySequence + Extensions

public extension LazySequence where Element: AnyObject {
    
    /// Create a sequence wrapper that will filter out repeating elements during iterator iteration.
    /// Since it will only filtering when in iteration, the time complexity for the creation of this sequence is O(1).
    /// Filtering duplicates will be using a hash, so on average time complexity for iterating this sequence will be around O(n) or on worst case will be O(log n)
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have complexity of O(*n*) on average where *n* is the original sequence iterator iteration count
    @inlinable var uniquedObjects: LazySequence<Element> {
        uniqued { ObjectIdentifier($0) }
    }
}

// MARK: UniqueSequenceIterator

open class UniqueSequenceIterator<BaseSequence: Sequence>: LazySequenceIterator<BaseSequence.Element> {
    
    typealias BaseIterator = BaseSequence.Iterator
    
    var iterator: BaseIterator
    
    public init(sequence: BaseSequence) {
        iterator = sequence.makeIterator()
    }
    
    open override func next() -> Element? {
        guard let nextIteration = iterator.next() else {
            return nil
        }
        return nextIfRepeated(for: nextIteration) ? next() : nextIteration
    }
    
    open func nextIfRepeated(for element: Element) -> Bool {
        fatalError("this method should be overriden")
    }
}

// MARK: UniqueManualComparisonSequenceIterator

public final class UniqueManualComparisonSequenceIterator<BaseSequence: Sequence>: UniqueSequenceIterator<BaseSequence> {
    
    public typealias Comparison = (Element, Element) -> Bool
    
    var iterated: [Element] = []
    var cosideredSame: Comparison
    
    public init(sequence: BaseSequence, where cosideredSame: @escaping Comparison) {
        self.cosideredSame = cosideredSame
        super.init(sequence: sequence)
    }
    
    public override func nextIfRepeated(for element: UniqueSequenceIterator<BaseSequence>.Element) -> Bool {
        guard !iterated.contains(where: { cosideredSame(element, $0) }) else {
            return true
        }
        iterated.append(element)
        return false
    }
}

// MARK: UniqueHashableSequenceIterator

public final class UniqueHashableSequenceIterator<BaseSequence: Sequence>: UniqueSequenceIterator<BaseSequence> where BaseSequence.Element: Hashable {
    
    var iterated: [Element: Void] = [:]
    
    public override func nextIfRepeated(for element: UniqueSequenceIterator<BaseSequence>.Element) -> Bool {
        guard iterated[element] == nil else {
            return true
        }
        iterated[element] = ()
        return false
    }
}

// MARK: UniqueProjectionSequenceIterator

public final class UniqueProjectionSequenceIterator<BaseSequence: Sequence, Projection: Hashable>: UniqueSequenceIterator<BaseSequence> {
    
    public typealias HashProjection = (Element) -> Projection
    
    let hashProjection: HashProjection
    var iterated: [Projection: Void] = [:]
    
    public init(sequence: BaseSequence, projection: @escaping HashProjection) {
        self.hashProjection = projection
        super.init(sequence: sequence)
    }
    
    public override func nextIfRepeated(for element: UniqueSequenceIterator<BaseSequence>.Element) -> Bool {
        let identifier = hashProjection(element)
        guard iterated[identifier] == nil else {
            return true
        }
        iterated[identifier] = ()
        return false
    }
}
