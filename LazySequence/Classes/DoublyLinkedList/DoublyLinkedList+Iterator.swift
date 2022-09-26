//
//  DoublyLinkedList+Iterator.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 05/09/22.
//

import Foundation

// MARK: DoublyLinkedListIterator

public struct DoublyLinkedListIterator<Element>: IteratorProtocol {
    
    private var currentNode: Node?
    
    init(root: DoublyLinkedList<Element>.Node?) {
        self.currentNode = root?.toIteratorNode()
    }
    
    public mutating func next() -> Element? {
        defer { currentNode = currentNode?.next }
        return currentNode?.element
    }
}

// MARK: DoublyLinkedListIterator.Node

extension DoublyLinkedListIterator {
    class Node {
        let element: Element
        let next: Node?
        
        init(element: Element, next: Node?) {
            self.element = element
            self.next = next
        }
    }
}

// MARK: DoublyLinkedList.Node + Extensions

extension DoublyLinkedList.Node {
    func toIteratorNode() -> DoublyLinkedListIterator<Element>.Node {
        .init(element: element, next: next?.toIteratorNode())
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
