//
//  LazySequenceExtensionsSpec.swift
//  LazySequence_Tests
//
//  Created by Nayanda Haberty on 03/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import LazySequence

class LazySequenceExtensionsSpec: QuickSpec {
    
    override func spec() {
        it("should generate symmetric differrence based on projection") {
            let left: [Dummy] = .dummies(count: Int.random(in: 20..<50))
            let leftSubtracted = Array(left[0..<15])
            let rightSubtracted: [Dummy] = .dummies(count: Int.random(in: 10 ..< 20))
            let expected: [Dummy] = leftSubtracted + rightSubtracted
            let right: [Dummy] = Array(left[15..<left.count]) + rightSubtracted
            let symmetricDifference = left.symmetricDifference(from: right) { $0.uuid }
            expect(symmetricDifference.compactMap { $0.uuid }).to(equal(expected.compactMap { $0.uuid }))
        }
        it("should generate symmetric differrence equatables") {
            let left: [DummyEquatable] = .dummies(count: Int.random(in: 20..<50))
            let leftSubtracted = Array(left[0..<15])
            let rightSubtracted: [DummyEquatable] = .dummies(count: Int.random(in: 10 ..< 20))
            let expected: [DummyEquatable] = leftSubtracted + rightSubtracted
            let right: [DummyEquatable] = Array(left[15..<left.count]) + rightSubtracted
            let symmetricDifference = left.symmetricDifference(from: right)
            expect(symmetricDifference).to(equal(expected))
        }
        it("should generate symmetric differrence hashables") {
            let left: [DummyHashable] = .dummies(count: Int.random(in: 20..<50))
            let leftSubtracted = Array(left[0..<15])
            let rightSubtracted: [DummyHashable] = .dummies(count: Int.random(in: 10 ..< 20))
            let expected: [DummyHashable] = leftSubtracted + rightSubtracted
            let right: [DummyHashable] = Array(left[15..<left.count]) + rightSubtracted
            let symmetricDifference = left.symmetricDifference(from: right)
            expect(symmetricDifference).to(equal(expected))
        }
        it("should generate symmetric differrence objects") {
            let left: [DummyObject] = .dummies(count: Int.random(in: 20..<50))
            let leftSubtracted = Array(left[0..<15])
            let rightSubtracted: [DummyObject] = .dummies(count: Int.random(in: 10 ..< 20))
            let expected: [DummyObject] = leftSubtracted + rightSubtracted
            let right: [DummyObject] = Array(left[15..<left.count]) + rightSubtracted
            let symmetricDifference = left.objectsSymmetricDifference(from: right)
            expect(symmetricDifference.compactMap { $0.uuid }).to(equal(expected.compactMap { $0.uuid }))
        }
    }
}
