//
//  LazySequence.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 1/9/22.
//

import Foundation

// MARK: LazySequence

/// LazySequence object to allow custom iterator for iterating the sequence wrapped
public final class LazySequence<Element>: Sequence {
    public typealias Iterator = LazySequenceIterator<Element>
    
    let iteratorFactory: () -> Iterator
    
    public init(iterator: @escaping @autoclosure () -> Iterator) {
        self.iteratorFactory = iterator
    }
    
    public init(iteratorFactory: @escaping @autoclosure () -> Iterator) {
        self.iteratorFactory = iteratorFactory
    }
    
    public convenience init<S: Sequence>(sequence: S) where S.Element == Element {
        self.init(iterator: LazySequenceIteratorWrapper(sequence: sequence))
    }
    
    public func makeIterator() -> Iterator {
        iteratorFactory()
    }
}

// MARK: LazySequenceIterator

/// Compatible Iterator for `LazySequenceIterator`
open class LazySequenceIterator<Element>: IteratorProtocol {
    
    open func next() -> Element? {
        fatalError("this method should be overriden")
    }
}

// MARK: LazySequenceIteratorWrapper

public final class LazySequenceIteratorWrapper<Wrapped: Sequence>: LazySequenceIterator<Wrapped.Element> {
    typealias Iterator = Wrapped.Iterator
    var iterator: Iterator
    
    init(sequence: Wrapped) {
        self.iterator = sequence.makeIterator()
    }
    
    public override func next() -> Element? {
        iterator.next()
    }
}
