//
//  CombinedSequenceSpec.swift
//  LazySequence_Tests
//
//  Created by Nayanda Haberty on 03/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import LazySequence

class CombinedSequenceSpec: QuickSpec {
    
    override func spec() {
        it("should combine sequences") {
            let first: [DummyEquatable] = .dummies(count: Int.random(in: 10..<50))
            let second: [DummyEquatable] = .dummies(count: Int.random(in: 10..<50))
            let expected = first + second
            expect(first.lazy.combined(with: second).asArray).to(equal(expected))
        }
//        it("should be faster than swift regular append when doing multiple combined") {
//            switch compareAvgAppendAndCombinedTimeInterval() {
//            case .greaterThanBy(percent: let percent):
//                fail("combined averagely slower than append by \((percent * 100).rounded(toPlaces: 2))% to combined 4 array")
//            case .lessThanBy(percent: let percent):
//                print("combined averagely faster than append by \((percent * 100).rounded(toPlaces: 2))% to combined 4 array")
//            }
//        }
    }
}

private func compareAvgAppendAndCombinedTimeInterval() -> TimeIntervalComparison {
    let array1: [DummyEquatable] = .dummies(count: 250)
    let array2: [DummyEquatable] = .dummies(count: 250)
    let array3: [DummyEquatable] = .dummies(count: 250)
    let array4: [DummyEquatable] = .dummies(count: 250)
    let expected = array1 + array2 + array3 + array4
    return compareAvgTimeIntervalOf {
        var result = array1
        result.append(contentsOf: array2)
        result.append(contentsOf: array3)
        result.append(contentsOf: array4)
        expect(result).to(equal(expected))
    } and: {
        let result = array1.lazy.combined(with: array2)
            .combined(with: array3)
            .combined(with: array4)
            .asArray
        expect(result).to(equal(expected))
    }
}
