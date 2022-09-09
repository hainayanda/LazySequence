//
//  PrefixedSequence.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 03/09/22.
//

import Foundation

// MARK: Sequence + Extensions

public extension Sequence {
    
    /// Capped the sequence iteration to a given maximum iteration count
    /// This will create a new LazySequence that will only iterate the original sequence maximum at a given maximum iteration count
    /// - Complexity: O(1) on creation, when iterating O (*n*) at if iteration count is less than given maximum iteration and O (*m*) if iteration count is more than given maximum iteration, where *n* is the original sequence iterator iteration count, and *m* is given maximum iteration count
    /// - Parameter maxIteration: Number of maximum iteration that will be performed by returned sequence
    /// - Returns: LazySequence that will only do iterating until given maximum iteration count or until iteration is finished
    @inlinable func capped(atMaxIteration count: Int) -> LazySequence<Element> {
        prefixedUntilEnumerated { index, _ in
            index >= count
        }
    }
    
    /// Prefixed a sequence as much until the given condition for the element is met
    /// This will create a new LazySequence that will only iterate the original sequence until the given condition for the element is met
    /// - Complexity: O (*n*) at maximum and O (*m*) at minimum, where *n* is the original sequence iterator iteration count, and *m* is iteration count until condition is met
    /// - Parameter found: A closure that will take an Element for an argument and Bool as return value. If the return value is true, then the iteration will end
    /// - Returns: LazySequence that will only iterate the original sequence until the given condition for the element is met
    @inlinable func prefixedUntil(found: @escaping (Element) -> Bool) -> LazySequence<Element> {
        prefixedUntilEnumerated { _, element in
            found(element)
        }
    }
    
    /// Capped the sequence iteration until certain condition is met
    /// This will create a new LazySequence that will only iterate the original sequence until certain condition is met or until iteration is finished
    /// - Complexity: O (*n*) at maximum and O (*m*) at minimum, where *n* is the original sequence iterator iteration count, and *m* is iteration count until condition is met
    /// - Parameter untilFound: Closure that accept index and element for each iteration and return Bool that indicate the iteration must stop
    /// - Returns: LazySequence that will only do iterating until certain condition is met or until iteration is finished
    @inlinable func prefixedUntilEnumerated(found: @escaping (Int, Element) -> Bool) -> LazySequence<Element> {
        LazySequence(iterator: PrefixedSequenceIteratorWrapper(sequence: self, stopCondition: found))
    }
}

public extension Sequence where Element: Equatable {
    
    /// Prefixed a sequence as much until the given element is found
    /// This will create a new LazySequence that will only iterate the original sequence until the given element is found
    /// - Complexity: O (*n*) at maximum and O (*m*) at minimum, where *n* is the original sequence iterator iteration count, and *m* is iteration count until condition is met 
    /// - Parameter found: Element to be found
    /// - Returns: LazySequence that will only iterate the original sequence until the given element is found
    @inlinable func prefixedUntil(found element: Element) -> LazySequence<Element> {
        return prefixedUntil { $0 == element }
    }
}

public extension Sequence where Element: AnyObject {
    
    /// Prefixed a sequence as much until the given object is found
    /// This will create a new LazySequence that will only iterate the original sequence until the given object is found
    /// - Complexity: O (*n*) at maximum and O (*m*) at minimum, where *n* is the original sequence iterator iteration count, and *m* is iteration count until condition is met
    /// - Parameter object: Object to be found
    /// - Returns: LazySequence that will only iterate the original sequence until the given object is found
    @inlinable func prefixedUntil(objectFound object: Element) -> LazySequence<Element> {
        return prefixedUntil { $0 === object }
    }
}

// MARK: PrefixedSequenceIteratorWrapper

public final class PrefixedSequenceIteratorWrapper<BaseSequence: Sequence>: LazySequenceIterator<BaseSequence.Element> {
    typealias BaseIterator = EnumeratedSequence<BaseSequence>.Iterator
    
    let stopCondition: (Int, Element) -> Bool
    var iterator: BaseIterator
    
    public init(sequence: BaseSequence, stopCondition: @escaping (Int, Element) -> Bool) {
        self.stopCondition = stopCondition
        self.iterator = sequence.enumerated().makeIterator()
    }
    
    public override func next() -> Element? {
        guard let next = iterator.next(), !stopCondition(next.offset, next.element) else { return nil }
        return next.element
    }
}
