//
//  MappedSequence.swift
//  Gizmo
//
//  Created by Nayanda Haberty on 31/8/22.
//

import Foundation

// MARK: LazySequence + Extensions

public extension LazySequence {
    
    /// Create a sequence wrapper that will map each element during iterator iteration. It will then ignore error and nil from the iteration.
    /// Since it will only map when in iteration, the time complexity for the creation of this sequence is O(1) and the iteration time complexity will be the same as the original sequence iteration.
    /// ```
    /// // this operation below will have overall time complexity around O(n + 2m)
    /// // compactMap itself have time complexity O(n + m) which caused by mapping iteration and creating an array with sized m
    /// // The forEach iteration will have time complexity of O(m).
    /// // So then overall time complexity will be O(n + m) + O(m) which is O(n + 2m)
    /// myArray.compactMap { transform($0) }.forEach {
    ///     print($0)
    /// }
    ///
    /// // this operation below will have time complexity around O(n) since it will do the transform operation in the iteration itself
    /// myArray.lazy.compactMapped { transform($0) }.forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have complexity of O(*n*) where *n* number of iteration performed by the original sequence
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns an optional value.
    /// - Returns: LazySequence that will run the transformation during its iterator iteration
    @inlinable func compactMapped<Mapped>(_ transform: @escaping (Element) throws -> Mapped?) -> LazySequence<Mapped> {
        LazySequence<Mapped>(iterator: CompactMappedSequenceIterator(sequence: self, mapper: transform))
    }
    
    /// Create a sequence wrapper that will map each element during iterator iteration. It will then ignore error from the iteration.
    /// Since it will only map when in iteration, the time complexity for the creation of this sequence is O(1) and the iteration time complexity will be the same as the original sequence iteration.
    /// ```
    /// // this operation below will have overall time complexity around O(n + 2m)
    /// // compactMap itself have time complexity O(n + m) which caused by mapping iteration and creating an array with sized m
    /// // The forEach iteration will have time complexity of O(m).
    /// // So then overall time complexity will be O(n + m) + O(m) which is O(n + 2m)
    /// myArray.map { transform($0) }.forEach {
    ///     print($0)
    /// }
    ///
    /// // this operation below will have time complexity around O(n) since it will do the transform operation in the iteration itself
    /// myArray.lazy.mapped { transform($0) }.forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have complexity of O(*n*) where *n* number of iteration performed by the original sequence
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns mapped value.
    /// - Returns: LazySequence that will run the transformation during its iterator iteration
    @inlinable func mapped<Mapped>(_ transform: @escaping (Element) throws -> Mapped) -> LazySequence<Mapped> {
        LazySequence<Mapped>(iterator: MappedSequenceIterator(sequence: self, mapper: transform))
    }
}

public extension LazySequence where Element: Unwrappable {
    
    /// Simply just shortcut to `compactMapped { $0 }`
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have complexity of O(*n*) where *n* is the original sequence iteration count.
    /// - Returns: LazySequence that will ignore nil during its iterator iteration
    @inlinable func compacted() -> LazySequence<Element.Wrapped> {
        self.compactMapped { $0.unwrapped() }
    }
    
    /// Simply just shortcut to to `compacted().asArray`
    @inlinable var compactArray: [Element.Wrapped] {
        compacted().asArray
    }
}

// MARK: Unwrappable

public protocol Unwrappable {
    associatedtype Wrapped
    
    func unwrapped() -> Wrapped?
}

extension Optional: Unwrappable {
    public func unwrapped() -> Wrapped? { self }
}

// MARK: MappedSequenceIterator

public final class MappedSequenceIterator<BaseSequence: Sequence, Mapped>: LazySequenceIterator<Mapped> {
    public typealias Mapper = (BaseSequence.Element) throws -> Mapped
    typealias BaseIterator = BaseSequence.Iterator
    
    var iterator: BaseIterator
    let mapper: Mapper
    
    public init(sequence: BaseSequence, mapper: @escaping Mapper) {
        iterator = sequence.makeIterator()
        self.mapper = mapper
    }
    
    public override func next() -> Element? {
        guard let nextIteration = iterator.next() else {
            return nil
        }
        do {
            return try mapper(nextIteration)
        } catch {
            return next()
        }
    }
}

// MARK: CompactMappedSequenceIterator

public final class CompactMappedSequenceIterator<BaseSequence: Sequence, Mapped>: LazySequenceIterator<Mapped> {
    public typealias Mapper = (BaseSequence.Element) throws -> Mapped?
    typealias BaseIterator = BaseSequence.Iterator
    
    var iterator: BaseIterator
    let mapper: Mapper
    
    public init(sequence: BaseSequence, mapper: @escaping Mapper) {
        iterator = sequence.makeIterator()
        self.mapper = mapper
    }
    
    public override func next() -> Element? {
        guard let nextIteration = iterator.next() else {
            return nil
        }
        do {
            return try mapper(nextIteration) ?? next()
        } catch {
            return next()
        }
    }
}
