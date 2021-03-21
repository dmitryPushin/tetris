//
//  Array2DTests.swift
//  TetrisTests
//
//  Created by Dmitry Pushin on 18.03.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import XCTest
@testable import Tetris

class Array2DTests: XCTestCase {

    func testCloskWise() {
        // Given
        let arr = Array2D(elements: [[1, 2, 3],
                                     [4, 5, 6],
                                     [7, 8, 9]])

        // When
        let rotatedClockwise = arr?.rotated(angle: .degrees_90)

        // Then
        guard let arr2dNonNil = rotatedClockwise else {
            XCTFail("Incorrect elements size in prarmeters")
            return
        }
        XCTAssert(arr2dNonNil.elements == [[7, 4, 1],
                                           [8, 5, 2],
                                           [9, 6, 3]])
    }

    func test360DegreeRotation() {
        // Given
        let arr = Array2D(elements: [[1, 2, 3],
                                     [4, 5, 6],
                                     [7, 8, 9]])
        // When
        var rotated = arr?.rotated(angle: .degrees_270)
        rotated = rotated?.rotated(angle: .degrees_90)

        // Then
        XCTAssertTrue(arr?.elements == rotated?.elements)
    }

    func testInitWithCorrectParameters() {
        // Given
        let arr = [[1], [2], [3]]

        // When
        let arr2d = Array2D(elements: arr)

        //then
        guard let arr2dNonNil = arr2d else {
            XCTFail("Incorrect elements size in prarmeters")
            return
        }
        XCTAssertTrue(arr2dNonNil.columns == 3 && arr2dNonNil.rows == 1)
    }

    func testInitWithIncorrectParameters() {
        // Given
        let arr = [[], [22], [3]]

        // When
        let a1 = Array2D(elements: arr)

        //then
        XCTAssertNil(a1)
    }


    func testRowFill() {
        // Given
        let columns = 3
        var grid = Array2D<Int>(columns: columns, rows: 4)

        // When
        grid[1] = Array(repeating: 1, count: columns)

        // Then
        XCTAssertTrue(grid[1]?.filter({ $0 != 1 }).count == 0, "Array2D fill failed")
    }

    func testInvalidSubscription() {
        // Given

        // When

        // THen
    }

    override func setUp() {}

    override func tearDown() {}
}


