//
//  UniqueSequenceSpec.swift
//  LazySequence_Tests
//
//  Created by Nayanda Haberty on 03/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import LazySequence

class UniqueSequenceSpec: QuickSpec {
    
    override func spec() {
        it("should create unique sequence from projection") {
            let expected: [Dummy] = .dummies(count: Int.random(in: 25..<50))
            let source: [Dummy] = Array(expected[0..<10]) + expected + Array(expected[20..<expected.count])
            expect(source.unique(byProjection: { $0.uuid }).compactMap { $0.uuid }).to(equal(expected.compactMap { $0.uuid }))
        }
        it("should create unique sequence from equatables") {
            let expected: [DummyEquatable] = .dummies(count: Int.random(in: 25..<50))
            let source: [DummyEquatable] = Array(expected[0..<10]) + expected + Array(expected[20..<expected.count])
            expect(source.unique).to(equal(expected))
        }
        it("should create unique sequence from hashables") {
            let expected: [DummyHashable] = .dummies(count: Int.random(in: 25..<50))
            let source: [DummyHashable] = Array(expected[0..<10]) + expected + Array(expected[20..<expected.count])
            expect(source.unique).to(equal(expected))
        }
        it("should create unique sequence from equatables") {
            let expected: [DummyObject] = .dummies(count: Int.random(in: 25..<50))
            let source: [DummyObject] = Array(expected[0..<10]) + expected + Array(expected[20..<expected.count])
            expect(source.uniqueObjects.compactMap { $0.uuid }).to(equal(expected.compactMap { $0.uuid }))
        }
    }
}
