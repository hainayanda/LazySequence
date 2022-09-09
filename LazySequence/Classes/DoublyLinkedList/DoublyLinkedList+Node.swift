//
//  DoublyLinkedList+Node.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 05/09/22.
//

import Foundation

// MARK: DoublyLinkedList Node

extension DoublyLinkedList {
    /// Node of DoubleLinkedList
    public class Node {
        /// Element stored in this Node
        public var element: Element
        public internal(set) var previous: Node?
        public internal(set) var next: Node?
        
        init(element: Element, previous: Node? = nil, next: Node? = nil) {
            self.element = element
            self.previous = previous
            self.next = next
        }
    }
}

// MARK: DoublyLinkedList Node Internal

extension DoublyLinkedList.Node {
    
    func removeFromLink() {
        previous?.next = next
        next?.previous = previous
        next = nil
        previous = nil
    }
    
    var mostNext: DoublyLinkedList<Element>.Node {
        next?.mostNext ?? self
    }
    
    var mostPrevious: DoublyLinkedList<Element>.Node {
        previous?.mostPrevious ?? self
    }
    
    func nextNode(for count: Int) -> DoublyLinkedList<Element>.Node? {
        count == 0 ? self: next?.nextNode(for: count - 1)
    }
    
    func previousNode(for count: Int) -> DoublyLinkedList<Element>.Node? {
        count == 0 ? self: previous?.previousNode(for: count - 1)
    }
}

// MARK: DoublyLinkedList Node + Hashable

extension DoublyLinkedList.Node: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    public static func == (lhs: DoublyLinkedList<Element>.Node, rhs: DoublyLinkedList<Element>.Node) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
