//
//  MappedSequenceSpec.swift
//  LazySequence_Tests
//
//  Created by Nayanda Haberty on 03/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import LazySequence

class MappedSequenceSpec: QuickSpec {
    
    override func spec() {
        it("should compactMapped iteration") {
            let source: [DummyEquatable?] = .dummies(count: Int.random(in: 10..<50))
            let expected = source.compactMap { $0 }
            expect(source.lazy.compactArray).to(equal(expected))
        }
        it("should mapped iteration") {
            let source: [DummyEquatable] = .dummies(count: Int.random(in: 10..<50))
            let expected = source.map { $0.uuid }
            var count = 0
            source.lazy.mapped { $0.uuid }.enumerated().forEach { index, identifier in
                expect(identifier).to(equal(expected[index]))
                count += 1
            }
            expect(count).to(equal(expected.count))
        }
//        it("should be faster than swift regular map when doing multiple mapped") {
//            switch compareAvgMapAndMappedTimeInterval() {
//            case .greaterThanBy(percent: let percent):
//                fail("mapped averagely slower than map by \((percent * 100).rounded(toPlaces: 2))% for mapping 4 times in a row")
//            case .lessThanBy(percent: let percent):
//                print("mapped averagely faster than map by \((percent * 100).rounded(toPlaces: 2))% for mapping 4 times in a row")
//            }
//        }
//        it("should be faster than swift compactMap append when doing multiple compactMapped") {
//            switch compareAvgCompactMapAndCompactMappedTimeInterval() {
//            case .greaterThanBy(percent: let percent):
//                fail("compactMapped averagely slower than compactMap by \((percent * 100).rounded(toPlaces: 2))% for mapping 4 times in a row")
//            case .lessThanBy(percent: let percent):
//                print("compactMapped averagely faster than compactMap by \((percent * 100).rounded(toPlaces: 2))% for mapping 4 times in a row")
//            }
//        }
    }
}

private func compareAvgMapAndMappedTimeInterval() -> TimeIntervalComparison {
    let array: [DummyEquatable] = .dummies(count: 1000)
    return compareAvgTimeIntervalOf {
        let mapped1 = array.map { $0.uuid }
        let mapped2 = mapped1.map { DummyObject(uuid: $0) }
        let mapped3 = mapped2.map { $0.uuid }
        let result = mapped3.map { DummyEquatable(uuid: $0) }
        result.enumerated().forEach { index, element in
            expect(element).to(equal(array[index]))
        }
    } and: {
        let mapped1 = array.lazy.mapped { $0.uuid }
        let mapped2 = mapped1.mapped { DummyObject(uuid: $0) }
        let mapped3 = mapped2.mapped { $0.uuid }
        let result = mapped3.mapped { DummyEquatable(uuid: $0) }
        result.enumerated().forEach { index, element in
            expect(element).to(equal(array[index]))
        }
    }
}

private func compareAvgCompactMapAndCompactMappedTimeInterval() -> TimeIntervalComparison {
    let array: [Dummy] = .dummies(count: 1000)
    return compareAvgTimeIntervalOf {
        let mapped1 = array.compactMap { $0.uuid.uuid.0 % 3 == 0 ? $0.uuid : nil }
        let mapped2 = mapped1.compactMap { $0.uuid.1 % 5 == 0 ? DummyObject(uuid: $0) : nil }
        let mapped3 = mapped2.compactMap { $0.uuid.uuid.2 % 7 == 0 ? $0.uuid : nil }
        let result = mapped3.compactMap { $0.uuid.3 % 9 == 0 ? DummyEquatable(uuid: $0) : nil }
        result.forEach {
            expect($0.uuid.uuid.0 % 3 == 0).to(beTrue())
            expect($0.uuid.uuid.1 % 5 == 0).to(beTrue())
            expect($0.uuid.uuid.2 % 7 == 0).to(beTrue())
            expect($0.uuid.uuid.3 % 9 == 0).to(beTrue())
        }
    } and: {
        let mapped1 = array.lazy.compactMapped { $0.uuid.uuid.0 % 3 == 0 ? $0.uuid : nil }
        let mapped2 = mapped1.compactMapped { $0.uuid.1 % 5 == 0 ? DummyObject(uuid: $0) : nil }
        let mapped3 = mapped2.compactMapped { $0.uuid.uuid.2 % 7 == 0 ? $0.uuid : nil }
        let result = mapped3.compactMapped { $0.uuid.3 % 9 == 0 ? DummyEquatable(uuid: $0) : nil }
        result.forEach {
            expect($0.uuid.uuid.0 % 3 == 0).to(beTrue())
            expect($0.uuid.uuid.1 % 5 == 0).to(beTrue())
            expect($0.uuid.uuid.2 % 7 == 0).to(beTrue())
            expect($0.uuid.uuid.3 % 9 == 0).to(beTrue())
        }
    }
}
