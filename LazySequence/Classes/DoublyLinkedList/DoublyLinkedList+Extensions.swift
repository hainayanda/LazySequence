//
//  DoublyLinkedList+Extensions.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 05/09/22.
//

import Foundation

// MARK: DoublyLinkedList + Sequence

extension DoublyLinkedList: Sequence {
    public typealias Iterator = DoublyLinkedListIterator<Element>
    
    public func makeIterator() -> DoublyLinkedListIterator<Element> {
        DoublyLinkedListIterator(root: root)
    }
    
    /// Create a LazySequence of Node that will iterate the Nodes of this DoublyLinkedList instead of the elements
    /// - Returns: a new LazySequence
    public func nodeSequence() -> LazySequence<Node> {
        let iterator = DoublyLinkedListNodeIterator(root: root)
        return LazySequence(iterator: iterator)
    }
}

// MARK: DoublyLinkedList + Collection

extension DoublyLinkedList: Collection {
    
    public typealias Index = Int
    
    public subscript(position: Int) -> Element {
        get {
            node(at: position)!.element
        }
        set {
            node(at: position)!.element = newValue
        }
    }
    
    public func index(after index: Int) -> Int { index + 1 }
    
    public var startIndex: Int { 0 }
    
    public var endIndex: Int { count }
}

// MARK: DoublyLinkedList + ExpressibleByArrayLiteral

extension DoublyLinkedList: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Element
    
    public convenience init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}
