//
//  InterpolationSequenceSpec.swift
//  LazySequence_Tests
//
//  Created by Nayanda Haberty on 08/09/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import LazySequence

class InterpolationSequenceSpec: QuickSpec {
    
    override func spec() {
        it("should do insert one element interpolated on sequence") {
            let array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
            let expected1 = [1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8, 0, 9, 0]
            let expected2 = [1, 2, 0, 3, 4, 0, 5, 6, 0, 7, 8, 0, 9]
            let expected3 = [1, 2, 3, 0, 4, 5, 6, 0, 7, 8, 9, 0]
            expect(array.lazy.inserted(forEach: 1, element: 0).asArray).to(equal(expected1))
            expect(array.lazy.inserted(forEach: 2, element: 0).asArray).to(equal(expected2))
            expect(array.lazy.inserted(forEach: 3, element: 0).asArray).to(equal(expected3))
        }
        it("should do insert multiple element interpolated on sequence") {
            let array = [1, 2, 3, 4, 5, 6, 7, 8]
            let expected1 = [1, 0, 9, 2, 0, 9, 3, 0, 9, 4, 0, 9, 5, 0, 9, 6, 0, 9, 7, 0, 9, 8, 0, 9]
            let expected2 = [1, 2, 0, 9, 3, 4, 0, 9, 5, 6, 0, 9, 7, 8, 0, 9]
            let expected3 = [1, 2, 3, 0, 9, 4, 5, 6, 0, 9, 7, 8]
            expect(array.lazy.inserted(forEach: 1, elements: [0, 9]).asArray).to(equal(expected1))
            expect(array.lazy.inserted(forEach: 2, elements: [0, 9]).asArray).to(equal(expected2))
            expect(array.lazy.inserted(forEach: 3, elements: [0, 9]).asArray).to(equal(expected3))
        }
    }
}
