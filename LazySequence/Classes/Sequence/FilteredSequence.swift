//
//  FilteredCollection.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 31/8/22.
//

import Foundation

// MARK: LazySequence + Extensions

public extension LazySequence {
    
    /// Create a sequence wrapper that will filter each element during iterator iteration.
    /// Since it will only map when in iteration, the time complexity for the creation of this sequence is O(1) and the iteration time complexity will be the same as the original sequence iteration.
    /// ```
    /// // this operation below will have overall time complexity around O(n + m)
    /// // filter itself have time complexity O(n)
    /// // The forEach iteration will have time complexity of O(m) where m is length of filtered array.
    /// // So then overall time complexity will be O(n) + O(m) which is O(n + m)
    /// myArray.lazy.filter { shouldInclude($0) }.forEach {
    ///     print($0)
    /// }
    ///
    /// // this operation below will have time complexity around O(n) since it will do the filter operation in the iteration itself
    /// myArray.lazy.filtered { shouldInclude($0) }.forEach {
    ///     print($0)
    /// }
    /// ```
    /// - Complexity: Executing this code will have complexity of O(1). Iterating it will have complexity of O(*n*) where *n* is the length of original sequence
    /// - Parameter shouldInclude: A closure that takes an element of the sequence as its argument and returns a Boolean value indicating whether the element should be included in the iteration.
    /// - Returns: LazySequence that will run the filtering during its iterator iteration
    @inlinable func filtered(_ shouldInclude: @escaping (Element) -> Bool) -> LazySequence<Element> {
        LazySequence(iterator: FilteredSequenceIterator(sequence: self, filter: shouldInclude))
    }
}

public extension LazySequence where Element: Equatable {
    @inlinable func withRemoved(_ element: Element) -> LazySequence<Element> {
        filtered { $0 != element }
    }
}

// MARK: FilteredSequenceIterator

public final class FilteredSequenceIterator<BaseSequence: Sequence>: LazySequenceIterator<BaseSequence.Element> {
    public typealias Filter = (Element) -> Bool
    typealias BaseIterator = BaseSequence.Iterator
    
    var iterator: BaseIterator
    let filter: Filter
    
    public init(sequence: BaseSequence, filter: @escaping Filter) {
        iterator = sequence.makeIterator()
        self.filter = filter
    }
    
    public override func next() -> Element? {
        guard let nextIteration = iterator.next() else {
            return nil
        }
        return filter(nextIteration) ? nextIteration : next()
    }
}
