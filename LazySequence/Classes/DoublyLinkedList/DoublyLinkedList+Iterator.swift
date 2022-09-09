//
//  DoublyLinkedList+Iterator.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 05/09/22.
//

import Foundation

// MARK: DoublyLinkedListIterator

public struct DoublyLinkedListIterator<Element>: IteratorProtocol {
    
    private var currentNode: DoublyLinkedList<Element>.Node?
    
    init(root: DoublyLinkedList<Element>.Node?) {
        self.currentNode = root
    }
    
    public mutating func next() -> Element? {
        defer { currentNode = currentNode?.next }
        return currentNode?.element
    }
}

// MARK: DoublyLinkedListNodeIterator

class DoublyLinkedListNodeIterator<Element>: LazySequenceIterator<DoublyLinkedList<Element>.Node> {
    
    private var currentNode: DoublyLinkedList<Element>.Node?
    
    init(root: DoublyLinkedList<Element>.Node?) {
        self.currentNode = root
    }
    
    override func next() -> DoublyLinkedList<Element>.Node? {
        defer { currentNode = currentNode?.next }
        return currentNode
    }
}
