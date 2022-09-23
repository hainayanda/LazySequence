//
//  InterposedSequence.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 06/09/22.
//

import Foundation

// MARK: LazySequence + Extensions

public extension LazySequence {
    /// Create a LazySequence that will insert given element for each given intervals when iterating.
    /// eg: `[1, 2, 3, 4]` will be iterated as `[1, 0, 2, 0, 3, 0, 4, 0]` if the given intervals is `1` and element is `0`.
    /// will be iterated as `[1, 2, 0, 3, 4, 0]` if the given intervals is `2` and element is `0`.
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have complexity of O(*n* + (*n* / *i*)) where *n* is the iteration count of original sequence, and *i* is intervals
    /// - Parameters:
    ///   - intervals: Intervals of element when the element should be inserted
    ///   - element: Element to be inserted for each intervals
    /// - Returns: LazySequence that will insert given element for each given intervals when iterating
    @inlinable func inserted(
        forEach intervals: Int,
        element: @escaping @autoclosure () -> Element) -> LazySequence<Element> {
            LazySequence(
                iterator: InterposedSequenceIteratorWrapper(sequence: self, intervals: intervals) {
                    [element()]
                }
            )
        }
    
    /// Create a LazySequence that will insert given elements for each given intervals when iterating
    /// eg: `[1, 2, 3, 4]` will be iterated as `[1, 0, 0, 2, 0, 0, 3, 0, 0, 4, 0, 0]` if the given intervals is `1` and elements is `[0, 0]`.
    /// will be iterated as `[1, 2, 0, 0, 3, 4, 0, 0]` if the given intervals is `2` and elements is `[0, 0]`.
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have complexity of O(*n* + ( *m* (*n* / *i*))) where *n* is the iteration count of original sequence, *m* is length of sequence inserted and  *i* is intervals
    /// - Parameters:
    ///   - intervals: Intervals of element when the elements should be inserted
    ///   - elements: Elements to be inserted for each intervals
    /// - Returns: LazySequence that will insert given elements for each given intervals when iterating
    @inlinable func inserted<S: Sequence>(
        forEach intervals: Int,
        elements: @escaping @autoclosure () -> S) -> LazySequence<Element> where S.Element == Element {
            LazySequence(
                iterator: InterposedSequenceIteratorWrapper(sequence: self, intervals: intervals) {
                    elements()
                }
            )
        }
    
    /// Create a LazySequence that will insert given elements for each given intervals when iterating
    /// eg: `[1, 2, 3, 4]` will be iterated as `[1, 0, 0, 2, 0, 0, 3, 0, 0, 4, 0, 0]` if the given intervals is `1` and elements is `0, 0`.
    /// will be iterated as `[1, 2, 0, 0, 3, 4, 0, 0]` if the given intervals is `2` and elements is `0, 0`.
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have complexity of O(*n* + ( *m* (*n* / *i*))) where *n* is the iteration count of original sequence, *m* is length of sequence inserted and  *i* is intervals
    /// - Parameters:
    ///   - intervals: Intervals of element when the elements should be inserted
    ///   - elements: Elements to be inserted for each intervals
    /// - Returns: LazySequence that will insert given elements for each given intervals when iterating
    @inlinable func inserted(forEach intervals: Int, _ elements: Element...) -> LazySequence<Element> {
        inserted(forEach: intervals, elements: elements)
    }
}

// MARK: InterposedSequenceIteratorWrapper

public final class InterposedSequenceIteratorWrapper<BaseSequence: Sequence, InterposerSequence: Sequence>: LazySequenceIterator<BaseSequence.Element> where InterposerSequence.Element == BaseSequence.Element {
    
    public typealias Interposer = () -> InterposerSequence
    typealias BaseIterator = BaseSequence.Iterator
    
    let intervals: Int
    let interposer: Interposer
    var iterator: BaseIterator
    var temporaryIterator: InterposerSequence.Iterator?
    var baseIndex: Int = 0
    
    public init(sequence: BaseSequence, intervals: Int, interposer: @escaping Interposer) {
        guard intervals > 0 else { fatalError("Interpose intervals should be greater than zero") }
        self.interposer = interposer
        self.iterator = sequence.makeIterator()
        self.intervals = intervals
    }
    
    public override func next() -> BaseSequence.Element? {
        guard temporaryIterator == nil else {
            return nextFromTemporatyIterator() ?? nextFromBaseIterator()
        }
        guard baseIndex > 0, baseIndex % intervals == 0 else {
            return nextFromBaseIterator()
        }
        temporaryIterator = interposer().makeIterator()
        return next()
    }
    
    func nextFromBaseIterator() -> BaseSequence.Element? {
        defer { baseIndex += 1}
        return iterator.next()
    }
    
    func nextFromTemporatyIterator() -> BaseSequence.Element? {
        guard let next = temporaryIterator?.next() else {
            temporaryIterator = nil
            return nil
        }
        return next
    }
}
