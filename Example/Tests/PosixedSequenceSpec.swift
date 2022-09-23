//
//  PosixedSequenceSpec.swift
//  LazySequence_Tests
//
//  Created by Nayanda Haberty on 08/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import LazySequence

class PosixedSequenceSpec: QuickSpec {
    
    override func spec() {
        it("should drop first count of sequnce") {
            let array: [DummyEquatable] = .dummies(count: Int.random(in: 20..<50))
            var count: Int = 0
            array.lazy.droppedFirst(10).enumerated().forEach { index, element in
                count += 1
                expect(element).to(equal(array[index + 10]))
            }
            expect(count).to(equal(array.count - 10))
        }
        it("should drop until found") {
            let array: [DummyEquatable] = .dummies(count: Int.random(in: 20..<50))
            let indexOfElementToBeFound = Int.random(in: 10..<20)
            let elementToBeFound = array[indexOfElementToBeFound]
            var count: Int = 0
            array.lazy.droppedUntil(found: elementToBeFound).enumerated().forEach { index, element in
                count += 1
                expect(element).to(equal(array[index + indexOfElementToBeFound]))
            }
            expect(count).to(equal(array.count - indexOfElementToBeFound))
        }
        it("should drop all if not found") {
            let array: [DummyEquatable] = .dummies(count: Int.random(in: 20..<50))
            let elementToBeFound = DummyEquatable()
            var count: Int = 0
            array.lazy.droppedUntil(found: elementToBeFound).forEach { _ in
                count += 1
            }
            expect(count).to(equal(0))
        }
        it("should be faster than swift regular slice when doing multiple droppedFirst") {
            switch comparePosixWithArraySlice() {
            case .greaterThanBy(percent: let percent):
                fail("slice averagely slower than droppedFirst by \((percent * 100).rounded(toPlaces: 2))% for dropping half of its sequence content gradually 3 times")
            case .lessThanBy(percent: let percent):
                print("droppedFirst averagely faster than slice by \((percent * 100).rounded(toPlaces: 2))% for dropping half of its sequence content gradually 3 times")
            }
        }
    }
}

fileprivate func comparePosixWithArraySlice() -> TimeIntervalComparison {
    let array: [DummyEquatable] = .dummies(count: 1000)
    return compareAvgTimeIntervalOf {
        let sliced1 = array.dropFirst(500)
        let sliced2 = sliced1.dropFirst(250)
        let result = sliced2.dropFirst(125)
        result.enumerated().forEach { index, element in
            expect(element).to(equal(array[index + 875]))
        }
    } and: {
        let sliced1 = array.lazy.droppedFirst(500)
        let sliced2 = sliced1.droppedFirst(250)
        let result = sliced2.droppedFirst(125)
        result.enumerated().forEach { index, element in
            expect(element).to(equal(array[index + 875]))
        }
    }
}
