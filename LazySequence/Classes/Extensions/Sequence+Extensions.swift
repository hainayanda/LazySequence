//
//  Sequence+Extensions.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 23/9/22.
//

import Foundation

public extension Sequence {
    @inlinable var lazy: LazySequence<Element> {
        self as? LazySequence<Element> ?? LazySequence(sequence: self)
    }
}
