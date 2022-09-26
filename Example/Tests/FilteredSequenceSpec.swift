//
//  FilteredSequenceSpec.swift
//  LazySequence_Tests
//
//  Created by Nayanda Haberty on 03/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import LazySequence

class FilteredSequenceSpec: QuickSpec {
    
    override func spec() {
        it("should filter iteration") {
            let source: [DummyEquatable?] = .dummies(count: Int.random(in: 10..<50))
            let expected = source.filter { $0 != nil }
            var count = 0
            source.lazy.filtered { $0 != nil }.enumerated().forEach { index, identifier in
                expect(identifier).to(equal(expected[index]))
                count += 1
            }
            expect(count).to(equal(expected.count))
        }
        it("should be faster than swift regular filter when doing multiple filter") {
            switch compareAvgFilterAndFilteredTimeInterval() {
            case .greaterThanBy(percent: let percent):
                fail("filtered averagely slower than filter by \((percent * 100).rounded(toPlaces: 2))% for 4 filtering task")
            case .lessThanBy(percent: let percent):
                print("filtered averagely faster than filter by \((percent * 100).rounded(toPlaces: 2))% for 4 filtering task")
            }
        }
    }
}

private func compareAvgFilterAndFilteredTimeInterval() -> TimeIntervalComparison {
    let array: [Dummy] = .dummies(count: 1000)
    return compareAvgTimeIntervalOf {
        let filtered0 = array.filter { $0.uuid.uuid.0 % 9 == 0 }
        let filtered1 = filtered0.filter { $0.uuid.uuid.1 % 7 == 0 }
        let filtered2 = filtered1.filter { $0.uuid.uuid.2 % 5 == 0 }
        let filtered3 = filtered2.filter { $0.uuid.uuid.3 % 3 == 0 }
        filtered3.forEach {
            expect($0.uuid.uuid.0 % 9 == 0).to(beTrue())
            expect($0.uuid.uuid.1 % 7 == 0).to(beTrue())
            expect($0.uuid.uuid.2 % 5 == 0).to(beTrue())
            expect($0.uuid.uuid.3 % 3 == 0).to(beTrue())
        }
    } and: {
        let filtered0 = array.lazy.filtered { $0.uuid.uuid.0 % 9 == 0 }
        let filtered1 = filtered0.filtered { $0.uuid.uuid.1 % 7 == 0 }
        let filtered2 = filtered1.filtered { $0.uuid.uuid.2 % 5 == 0 }
        let filtered3 = filtered2.filtered { $0.uuid.uuid.3 % 3 == 0 }
        filtered3.forEach {
            expect($0.uuid.uuid.0 % 9 == 0).to(beTrue())
            expect($0.uuid.uuid.1 % 7 == 0).to(beTrue())
            expect($0.uuid.uuid.2 % 5 == 0).to(beTrue())
            expect($0.uuid.uuid.3 % 3 == 0).to(beTrue())
        }
    }
}
