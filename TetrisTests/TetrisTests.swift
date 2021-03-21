//
//  TetrisTests.swift
//  TetrisTests
//
//  Created by Dmitry Pushin on 18/06/2019.
//  Copyright © 2019 Dmitry Pushin. All rights reserved.
//

import XCTest
@testable import Tetris

class TetrisTests: XCTestCase {

    func testArray2D() {
        // Given
        let columns = 3
        var array = Array2D<Element>(columns: columns, rows: 4)

        // When
        array[1] = Array(repeating: Element(type: .figure), count: columns)
        print(array)

        // Then

    }
    
    override func setUp() {}
    
    override func tearDown() {}
}
