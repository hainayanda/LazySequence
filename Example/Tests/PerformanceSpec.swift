//
//  PerformanceSpec.swift
//  LazySequence_Tests
//
//  Created by Nayanda Haberty on 06/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import LazySequence

class PerformanceSpec: QuickSpec {
    
    override func spec() {
        it("should generally faster when doing multiple task than the regular swift") {
            let array: [Dummy] = .dummies(count: 100)
            let result = compareAvgTimeIntervalOf {
                let sorted = array.sorted { $0.id.uuid.0 > $1.id.uuid.0 }
                let mapped = sorted.map { DummyEquatable(id: $0.id) }
                let filtered = mapped.filter { $0.id.uuid.0 % 2 == 0 }
                let result = mapped + filtered
                result.forEach { print($0) }
            } and: {
                let sorted = array.lazy.sortedSequence { $0.id.uuid.0 > $1.id.uuid.0 }
                let mapped = sorted.mapped { DummyEquatable(id: $0.id) }
                let filtered = mapped.filtered { $0.id.uuid.0 % 2 == 0 }
                let result = mapped.combined(with: filtered)
                result.forEach { print($0) }
            }
            switch result {
            case .greaterThanBy(percent: let percent):
                fail("lazy sequence averagely slower than regular sequence by \((percent * 100).rounded(toPlaces: 2))% for multiple task")
            case .lessThanBy(percent: let percent):
                print("lazy sequence averagely faster than regular sequence by \((percent * 100).rounded(toPlaces: 2))% for multiple task")
            }

        }
    }
}

func timeIntervalOf(task: () -> Void) -> TimeInterval {
    let startDate = Date()
    task()
    return abs(startDate.timeIntervalSinceNow)
}

enum TimeIntervalComparison {
    case greaterThanBy(percent: Double)
    case lessThanBy(percent: Double)
}

func compareAvgTimeIntervalOf(_ task1: () -> Void, and taks2: () -> Void) -> TimeIntervalComparison {
    var intervals1: TimeInterval = 0
    var intervals2: TimeInterval = 0
    (0..<50).forEach { _ in
        intervals1 += timeIntervalOf(task: task1)
        intervals2 += timeIntervalOf(task: taks2)
    }
    let difference = intervals1 - intervals2
    return difference > 0 ? .greaterThanBy(percent: difference / intervals2) : .lessThanBy(percent: abs(difference) / intervals1)
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
