//
//  LazySequenceError.swift
//  LazySequence
//
//  Created by Nayanda Haberty on 06/09/22.
//

import Foundation

public enum LazySequenceError: Error {
    case failToUnwrappingOptional(type: Any.Type)
}
