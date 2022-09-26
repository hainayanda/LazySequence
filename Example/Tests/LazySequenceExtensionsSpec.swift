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
        it("should generate symetric differrence based on projection") {
            let left: [Dummy] = .dummies(count: Int.random(in: 20..<50))
            let leftSubstracted = Array(left[0..<15])
            let rightSubstracted: [Dummy] = .dummies(count: Int.random(in: 10 ..< 20))
            let expected: [Dummy] = leftSubstracted + rightSubstracted
            let right: [Dummy] = Array(left[15..<left.count]) + rightSubstracted
            let symetricDifference = left.symetricDifference(from: right) { $0.uuid }
            expect(symetricDifference.compactMap { $0.uuid }).to(equal(expected.compactMap { $0.uuid }))
        }
        it("should generate symetric differrence equatables") {
            let left: [DummyEquatable] = .dummies(count: Int.random(in: 20..<50))
            let leftSubstracted = Array(left[0..<15])
            let rightSubstracted: [DummyEquatable] = .dummies(count: Int.random(in: 10 ..< 20))
            let expected: [DummyEquatable] = leftSubstracted + rightSubstracted
            let right: [DummyEquatable] = Array(left[15..<left.count]) + rightSubstracted
            let symetricDifference = left.symetricDifference(from: right)
            expect(symetricDifference).to(equal(expected))
        }
        it("should generate symetric differrence hashables") {
            let left: [DummyHashable] = .dummies(count: Int.random(in: 20..<50))
            let leftSubstracted = Array(left[0..<15])
            let rightSubstracted: [DummyHashable] = .dummies(count: Int.random(in: 10 ..< 20))
            let expected: [DummyHashable] = leftSubstracted + rightSubstracted
            let right: [DummyHashable] = Array(left[15..<left.count]) + rightSubstracted
            let symetricDifference = left.symetricDifference(from: right)
            expect(symetricDifference).to(equal(expected))
        }
        it("should generate symetric differrence objects") {
            let left: [DummyObject] = .dummies(count: Int.random(in: 20..<50))
            let leftSubstracted = Array(left[0..<15])
            let rightSubstracted: [DummyObject] = .dummies(count: Int.random(in: 10 ..< 20))
            let expected: [DummyObject] = leftSubstracted + rightSubstracted
            let right: [DummyObject] = Array(left[15..<left.count]) + rightSubstracted
            let symetricDifference = left.objectsSymetricDifference(from: right)
            expect(symetricDifference.compactMap { $0.uuid }).to(equal(expected.compactMap { $0.uuid }))
        }
    }
}
