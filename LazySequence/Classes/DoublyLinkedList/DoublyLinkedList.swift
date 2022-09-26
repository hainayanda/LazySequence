//
//  DoublyLinkedList.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 03/09/22.
//

import Foundation
import Chary

// MARK: DoublyLinkedList

/// Use this instead of regular array if you need to do many mutable manipulation.
/// This generally will have less time complexity for most of manipulation task
/// Use array instead if you need to do many direct access to the element using index
/// This generally will have more time complexity for most of accessing task
final public class DoublyLinkedList<Element> {
    let queue: DispatchQueue = DispatchQueue(label: UUID().uuidString)
    @Atomic var root: Node?
    @Atomic var tail: Node?
    @Atomic private var populated: [Node: Void] = [:]
    
    /// First element in this DoublyLinkedList
    @inlinable public var first: Element? { firstNode?.element }
    
    /// Last element in this DoublyLinkedList
    @inlinable public var last: Element? { lastNode?.element }
    
    /// First node in this DoublyLinkedList
    public var firstNode: Node? { root }
    
    /// Last node in this DoublyLinkedList
    public var lastNode: Node? { tail }
    
    /// Number of element in this DoublyLinkedList
    public var count: Int { populated.count }
    
    public init() {
        $root = queue
        $tail = queue
        $populated = queue
    }
    
    public convenience init<S>(_ sequence: S) where S : Sequence, Element == S.Element {
        self.init()
        append(contentsOf: sequence)
    }
    
    /// Get Node at a given index
    /// - Complexity: O (*n*) or O (*m*) which one is less, where *n* is the given index - 1 and *m* is count - index - 1
    /// - Parameter index: Index of Node
    /// - Returns: Node at a given index. `nil` if the index is out of bounds
    public func node(at index: Int) -> Node? {
        queue.safeSync {
            if index < 0 || index > count { return nil }
            let reverseIndex = count - index - 1
            if index < reverseIndex {
                root?.queue = queue
                return root?.nextNode(for: index)
            } else {
                tail?.queue = queue
                return tail?.previousNode(for: reverseIndex)
            }
        }
    }
    
    /// Check whether this sequence have a given node or not.
    /// This will use the Node object identifier to search, so it will ignore the element inside the node.
    /// - Complexity: O (1) on average
    /// - Parameter node: Node to search
    /// - Returns: `True` if the node is found and `False` if not
    public func contains(node: Node) -> Bool {
        queue.safeSync {
            populated[node] != nil
        }
    }
    
    /// Append a node to this DoublyLinkedList
    /// It will search for the existing Node and move it to the last if found
    /// - Complexity: O (1) on average
    /// - Parameter node: node appended at the last of this sequence
    public func append(node: Node) {
        queue.safeSync {
            if contains(node: node) {
                naiveRemove(node: node)
            }
            naiveAppend(node: node)
        }
    }
    
    /// Append a new element to this sequence
    /// - Complexity: O (1)
    /// - Parameter newElement: New element that will be added at the last of this sequence
    public func append(_ newElement: Element) {
        queue.safeSync {
            naiveAppend(node: Node(element: newElement))
        }
    }
    
    /// Append a new elements to this sequence
    /// - Complexity: O (*n*) where *n* is the length of new elements
    /// - Parameter newElements: New elements that will be added at the last of this sequence
    public func append<S>(contentsOf newElements: S) where S : Sequence, Element == S.Element {
        queue.safeSync {
            prepareNodes(from: newElements) { sequenceRoot, sequenceTail in
                guard root != nil, let tail = self.tail else {
                    root = sequenceRoot
                    tail = sequenceTail
                    return
                }
                tail.queue = queue
                tail.next = sequenceRoot
                sequenceRoot.previous = tail
                self.tail = sequenceTail
            }
        }
    }
    
    /// Inset a node to this DoublyLinkedList
    /// It will search for the existing Node and move it to the given index if found
    /// If the index is same as this sequence count, it will just do append
    /// If the index is out of bounds it throw fatal error
    /// - Complexity: O (1) on average
    /// - Parameters:
    ///   - node: Node inserted
    ///   - index: Index of node
    public func insert(node: Node, at index: Int) {
        queue.safeSync {
            if contains(node: node) {
                naiveRemove(node: node)
            }
            if index == count {
                naiveAppend(node: node)
                return
            }
            guard index >= 0 && index < count else {
                fatalError("Index should be greater than zero and less than sequence count")
            }
            let nodeAtIndex = self.node(at: index)
            nodeAtIndex?.previous?.next = node
            node.previous = nodeAtIndex?.previous
            nodeAtIndex?.previous = node
            node.next = nodeAtIndex
            populated[node] = ()
        }
    }
    
    /// Inset a new element to this DoublyLinkedList
    /// If the index is same as this sequence count, it will just do append
    /// If the index is out of bounds it throw fatal error
    /// - Complexity: O (1) on average
    /// - Parameters:
    ///   - newElement: New element inserted
    ///   - index: Index of the new element
    public func insert(_ newElement: Element, at index: Int) {
        queue.safeSync {
            self.insert(node: Node(element: newElement, queue: queue), at: index)
        }
    }
    
    /// Inset a new elements to this DoublyLinkedList
    /// If the index is same as this sequence count, it will just do append
    /// If the index is out of bounds it throw fatal error
    /// - Complexity: O (*n*) where *n* is the length of new elements
    /// - Parameters:
    ///   - newElements: New elements inserted
    ///   - index: Index of the new elements
    public func insert<S>(contentsOf newElements: S, at index: Int) where S : Sequence, Element == S.Element {
        queue.safeSync {
            if index == count {
                append(contentsOf: newElements)
                return
            }
            guard index >= 0 && index < count else {
                fatalError("Index should be greater than zero and less than sequence count")
            }
            prepareNodes(from: newElements) { sequenceRoot, sequenceTail in
                let nodeAtIndex = self.node(at: index)
                nodeAtIndex?.previous?.next = sequenceRoot
                sequenceRoot.previous = nodeAtIndex?.previous
                nodeAtIndex?.previous = sequenceTail
                sequenceTail.next = nodeAtIndex
            }
        }
    }
    
    @discardableResult
    /// Remove a node from this sequence
    /// - Complexity: O (1) on average
    /// - Parameter node: Node to be removed
    /// - Returns: `True` if Node is exist in this sequence and removed, otherwise it will return `False`
    public func remove(node: Node) -> Bool {
        queue.safeSync {
            guard contains(node: node) else {
                return false
            }
            naiveRemove(node: node)
            return true
        }
    }
    
    @discardableResult
    /// Remove element at a given position
    /// - Complexity: O (*n*) or O (*m*) which one is less, where *n* is the given position - 1 and *m* is count - position - 1
    /// - Parameter position: Position of the element
    /// - Returns: Element removed, it will be nil if the position is out of bounds
    public func remove(at position: Int) -> Element? {
        queue.safeSync {
            guard let node = self.node(at: position) else {
                return nil
            }
            naiveRemove(node: node)
            return node.element
        }
    }
    
    @discardableResult
    /// Remove first element from this sequence
    /// - Complexity: O (1) on average
    /// - Returns: Element removed, it will be nil if the sequence is empty
    public func removeFirst() -> Element? {
        queue.safeSync {
            guard let node = firstNode else { return nil }
            naiveRemove(node: node)
            return node.element
        }
    }
    
    @discardableResult
    /// Remove last element from this sequence
    /// - Complexity: O (1) on average
    /// - Returns: Element removed, it will be nil if the sequence is empty
    public func removeLast() -> Element? {
        queue.safeSync {
            guard let node = lastNode else { return nil }
            naiveRemove(node: node)
            return node.element
        }
    }
    
    /// Remove all element that matched by the given closure
    /// - Complexity: O(*n*), where *n* is the length of this sequence
    /// - Parameter shouldBeRemoved: Array that accept the element and return Bool indicating the element should be removed or not
    public func removeAll(where shouldBeRemoved: (Element) throws -> Bool) rethrows {
        try queue.safeSync {
            guard let currentRoot = root else { return }
            var current: Node? = currentRoot
            var last: Node? = current
            repeat {
                let next = current?.next
                defer { current = next }
                guard let node = current, try shouldBeRemoved(node.element) else {
                    last = current
                    continue
                }
                if self.root === node {
                    let newRoot = node.next
                    newRoot?.previous = nil
                    self.root = newRoot
                }
                node.removeFromLink()
                populated[node] = nil
            } while current != nil
            self.tail = last
        }
    }
    
    /// Remove all elements from this sequence
    /// - Complexity: O (1)
    public func removeAll() {
        queue.safeSync {
            root = nil
            tail = nil
            populated = [:]
        }
    }
}

// MARK: DoublyLinkedList Internal

extension DoublyLinkedList {
    
    func naiveAppend(node: Node) {
        node.queue = queue
        defer { populated[node] = () }
        if self.root == nil {
            root = node
            tail = node
            return
        }
        node.previous = tail
        tail?.next = node
        tail = node.mostNext
    }
    
    func naiveRemove(node: Node) {
        node.queue = queue
        defer { populated[node] = nil }
        if root === node {
            let newRoot = node.next
            newRoot?.previous = nil
            root = newRoot
        }
        if tail === node {
            let newTail = node.previous
            newTail?.next = nil
            tail = newTail
        }
        node.removeFromLink()
    }
    
    func prepareNodes<S>(from sequence: S, then doTask: (_ sequenceRoot: Node, _ sequenceTail: Node) -> Void) where S : Sequence, Element == S.Element {
        let nodes: (root: Node, tail: Node)? = sequence.reduce(nil) { partialResult, element in
            let node = Node(element: element, queue: queue)
            populated[node] = ()
            guard let nodes = partialResult else { return (node, node) }
            nodes.tail.next = node
            node.previous = nodes.tail
            return (nodes.root, node)
        }
        guard let nodes = nodes else { return }
        doTask(nodes.root, nodes.tail)
    }
}
