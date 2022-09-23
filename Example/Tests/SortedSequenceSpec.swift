//
//  SortedSequenceSpec.swift
//  LazySequence_Tests
//
//  Created by Nayanda Haberty on 08/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import LazySequence

class SortedSequenceSpec: QuickSpec {
    
    override func spec() {
        it("should sort sequence") {
            let array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].shuffled()
            var count: Int = 0
            array.lazy.sortedSequence().enumerated().forEach { index, element in
                count += 1
                expect(element).to(equal(index))
            }
            expect(count).to(equal(array.count))
        }
    }
}
