//
//  DoublyLinkedList+Node.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 05/09/22.
//

import Foundation
import Chary

// MARK: DoublyLinkedList Node

extension DoublyLinkedList {
    /// Node of DoubleLinkedList
    public class Node {
        var queue: DispatchQueue {
            didSet {
                guard queue != oldValue else { return }
                $element = queue
                $previous = queue
                $next = queue
            }
        }
        /// Element stored in this Node
        @Atomic public var element: Element
        @Atomic public internal(set) var previous: Node?
        @Atomic public internal(set) var next: Node?
        
        init(element: Element,
             previous: Node? = nil,
             next: Node? = nil,
             queue: DispatchQueue = DispatchQueue(label: UUID().uuidString)) {
            self.queue = queue
            self.element = element
            self.previous = previous
            self.next = next
            $element = queue
            $previous = queue
            $next = queue
        }
    }
}

// MARK: DoublyLinkedList Node Internal

extension DoublyLinkedList.Node {
    
    func removeFromLink() {
        queue.safeSync {
            previous?.next = next
            next?.previous = previous
            next = nil
            previous = nil
        }
    }
    
    var mostNext: DoublyLinkedList<Element>.Node {
        queue.safeSync {
            next?.queue = queue
            return next?.mostNext ?? self
        }
    }
    
    var mostPrevious: DoublyLinkedList<Element>.Node {
        queue.safeSync {
            previous?.queue = queue
            return previous?.mostPrevious ?? self
        }
    }
    
    func nextNode(for count: Int) -> DoublyLinkedList<Element>.Node? {
        queue.safeSync {
            guard count != 0 else { return self }
            next?.queue = queue
            return next?.nextNode(for: count - 1)
        }
    }
    
    func previousNode(for count: Int) -> DoublyLinkedList<Element>.Node? {
        queue.safeSync {
            guard count != 0 else { return self }
            previous?.queue = queue
            return previous?.previousNode(for: count - 1)
        }
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
