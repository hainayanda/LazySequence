//
//  CommonModel.swift
//  LazySequence_Tests
//
//  Created by Nayanda Haberty on 03/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

class DummyObject {
    let uuid: UUID
    
    init(uuid: UUID =  UUID()) {
        self.uuid = uuid
    }
}

struct DummyHashable: Hashable {
    let uuid: UUID
    
    init(uuid: UUID =  UUID()) {
        self.uuid = uuid
    }
}

struct DummyEquatable: Equatable {
    let uuid: UUID
    
    init(uuid: UUID =  UUID()) {
        self.uuid = uuid
    }
}

struct Dummy {
    let uuid: UUID
    
    init(uuid: UUID =  UUID()) {
        self.uuid = uuid
    }
}

extension Array where Element == DummyObject? {
    static func dummies(count: Int) -> [DummyObject?] {
        (0 ..< count).map { _ in
            return Bool.random() ? DummyObject() : nil
        }
    }
}

extension Array where Element == DummyObject {
    static func dummies(count: Int) -> [DummyObject] {
        (0 ..< count).map { _ in
            DummyObject()
        }
    }
}

extension Array where Element == DummyHashable? {
    static func dummies(count: Int) -> [DummyHashable?] {
        (0 ..< count).map { _ in
            return Bool.random() ? DummyHashable() : nil
        }
    }
}

extension Array where Element == DummyHashable {
    static func dummies(count: Int) -> [DummyHashable] {
        (0 ..< count).map { _ in
            DummyHashable()
        }
    }
}

extension Array where Element == DummyEquatable? {
    static func dummies(count: Int) -> [DummyEquatable?] {
        (0 ..< count).map { _ in
            return Bool.random() ? DummyEquatable() : nil
        }
    }
}

extension Array where Element == DummyEquatable {
    static func dummies(count: Int) -> [DummyEquatable] {
        (0 ..< count).map { _ in
            DummyEquatable()
        }
    }
}

extension Array where Element == Dummy? {
    static func dummies(count: Int) -> [Dummy?] {
        (0 ..< count).map { _ in
            return Bool.random() ? Dummy() : nil
        }
    }
}

extension Array where Element == Dummy {
    static func dummies(count: Int) -> [Dummy] {
        (0 ..< count).map { _ in
            Dummy()
        }
    }
}
