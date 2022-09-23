//
//  PosixedSequence.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 06/09/22.
//

import Foundation

// MARK: LazySequence + Extensions

public extension LazySequence {
    
    /// Capped the sequence iteration to a given maximum iteration count
    /// This will create a new LazySequence that will only iterate the original sequence maximum at a given maximum iteration count
    /// - Complexity: O(1) on creation, when iterating O (*n*) at if iteration count is less than given maximum iteration and O (*m*) if iteration count is more than given start iteration index, where *n* is the original sequence iterator iteration count, and *m* is given start iteration index
    /// - Parameter maxIteration: Number of maximum iteration that will be performed by returned sequence
    /// - Returns: LazySequence that will only do iterating until given maximum iteration count or until iteration is finished
    @inlinable func droppedFirst(_ count: Int) -> LazySequence<Element> {
        droppedUntilEnumerated { index, _ in
            index >= count
        }
    }
    
    /// Drop a sequence elements until the given condition for the element is met
    /// This will create a new LazySequence that will only iterate the original sequence after the given condition for the element is met
    /// - Complexity: O (*n*) at maximum and O (*m*) at minimum, where *n* is the original sequence iterator iteration count, and *m* is iteration count after condition is met
    /// - Parameter found: Closure that accept element for each iteration and return Bool that indicate the iteration must stop
    /// - Returns: LazySequence that will only iterate the original sequence after the given condition for the element is met
    @inlinable func droppedUntil(found: @escaping (Element) -> Bool) -> LazySequence<Element> {
        droppedUntilEnumerated { _, element in
            found(element)
        }
    }
    
    /// Capped the sequence iteration until certain condition is met
    /// This will create a new LazySequence that will only iterate the original sequence until certain condition is met or until iteration is finished
    /// - Complexity: O (*n*) at maximum and O (*m*) at minimum, where *n* is the original sequence iterator iteration count, and *m* is iteration count after condition is met
    /// - Parameter coditionMet: Closure that accept index and element for each iteration and return Bool that indicate the iteration must stop
    /// - Returns: LazySequence that will only do iterating until certain condition is met or until iteration is finished
    @inlinable func droppedUntilEnumerated(found: @escaping (Int, Element) -> Bool) -> LazySequence<Element> {
        LazySequence(iterator: PosixedSequenceIteratorWrapper(sequence: self, startCondition: found))
    }
}

public extension LazySequence where Element: Equatable {
    /// Drop a sequence elements until the given element is found
    /// This will create a new LazySequence that will only iterate the original sequence after the given element is found
    /// - Complexity: O (*n*) at maximum and O (*m*) at minimum, where *n* is the original sequence iterator iteration count, and *m* is iteration count after condition is met
    /// - Parameter element: Element to be found
    /// - Returns: LazySequence that will only iterate the original sequence after the given element is found
    @inlinable func droppedUntil(found element: Element) -> LazySequence<Element> {
        return droppedUntil { $0 == element }
    }
}

public extension LazySequence where Element: AnyObject {
    /// Drop a sequence elements until the given object is found
    /// This will create a new LazySequence that will only iterate the original sequence after the given object is found
    /// - Complexity: O (*n*) at maximum and O (*m*) at minimum, where *n* is the original sequence iterator iteration count, and *m* is iteration count after condition is met
    /// - Parameter object: Object to be found
    /// - Returns: LazySequence that will only iterate the original sequence after the given object is found
    @inlinable func droppedUntil(objectFound object: Element) -> LazySequence<Element> {
        return droppedUntil { $0 === object }
    }
}

// MARK: PosixedSequenceIteratorWrapper

public final class PosixedSequenceIteratorWrapper<BaseSequence: Sequence>: LazySequenceIterator<BaseSequence.Element> {
    typealias BaseIterator = BaseSequence.Iterator
    
    let startCondition: (Int, BaseSequence.Element) -> Bool
    var started: Bool = false
    var iterator: EnumeratedSequence<BaseSequence>.Iterator
    
    public init(sequence: BaseSequence, startCondition: @escaping (Int, Element) -> Bool) {
        self.startCondition = startCondition
        self.iterator = sequence.enumerated().makeIterator()
    }
    
    public override func next() -> Element? {
        guard started else {
            guard let next = iterator.next() else { return nil }
            guard startCondition(next.offset, next.element) else {
                return self.next()
            }
            started = true
            return next.element
        }
        return iterator.next()?.element
    }
}
