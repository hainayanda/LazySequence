//
//  PrefixedSequenceSpec.swift
//  LazySequence_Tests
//
//  Created by Nayanda Haberty on 08/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import LazySequence

class PrefixedSequenceSpec: QuickSpec {
    
    override func spec() {
        it("should capped at a given count") {
            let array: [DummyEquatable] = .dummies(count: Int.random(in: 20..<50))
            let capped = Int.random(in: 10..<20)
            var count: Int = 0
            array.capped(atMaxIteration: capped).enumerated().forEach { index, element in
                count += 1
                expect(element).to(equal(array[index]))
            }
            expect(count).to(equal(capped))
        }
        it("should drop until found") {
            let array: [DummyEquatable] = .dummies(count: Int.random(in: 20..<50))
            let indexOfElementToBeFound = Int.random(in: 10..<20)
            let elementToBeFound = array[indexOfElementToBeFound]
            var count: Int = 0
            array.prefixedUntil(found: elementToBeFound).enumerated().forEach { index, element in
                count += 1
                expect(element).to(equal(array[index]))
            }
            expect(count).to(equal(indexOfElementToBeFound))
        }
        it("should iterate all if not found") {
            let array: [DummyEquatable] = .dummies(count: Int.random(in: 20..<50))
            let elementToBeFound = DummyEquatable()
            var count: Int = 0
            array.prefixedUntil(found: elementToBeFound).forEach { _ in
                count += 1
            }
            expect(count).to(equal(array.count))
        }
    }
}
