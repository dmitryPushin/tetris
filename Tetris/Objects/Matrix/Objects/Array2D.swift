//
//  Array2D.swift
//  Tetris
//
//  Created by Dmitry Pushin on 15.03.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import Foundation

struct Array2D<T> {
    let columns: Int
    let rows: Int

    private(set) var elements: [[T?]]

    init(columns: Int, rows: Int) {
        self.rows = rows
        self.columns = columns

        elements = Array<[T?]>(repeating: Array<T?>(repeating: nil, count: columns), count: rows)
    }

    init?(elements: [[T?]]) {
        let subarraysSet = Set(elements.map {$0.count })
        let isLengthEqually = subarraysSet.count == 1
        guard isLengthEqually else { return nil }

        self.elements = elements
        self.rows = subarraysSet.first ?? 0
        self.columns = elements.count
    }

    subscript(row: Int, column: Int) -> T? {
        get {
            return isValid(row: row, column: column) ? elements[row][column] : nil
        }

        set(newValue) {
            guard isValid(row: row, column: column) else { return }
            elements[row][column] = newValue
        }
    }

    subscript(row: Int) -> [T?]? {
        get {
            if 0..<rows ~= row {
                return elements[row]
            } else {
                return nil
            }
        }

        set(newValue) {
            guard 0..<rows ~= row,
                  let newValue = newValue else { return }
            elements[row] = newValue
        }
    }

    private func isValid(row: Int, column: Int) -> Bool {
        return 0..<rows ~= row && 0..<columns ~= column
    }

    mutating func fillWith(value: T) {
        elements = Array<[T?]>(repeating: Array<T?>(repeating: value, count: columns), count: rows)
    }

    func rotated(angle: RotationAngle) -> Array2D<T>? {
        var rotatedStructure: Array2D? = self
        let numberOfRotations = RotationAngle.allCases.firstIndex(of: angle)!
        var counter = 0
        while numberOfRotations > 0 && counter < numberOfRotations {
            rotatedStructure = rotatedStructure?.rotatedClockwise()
            counter += 1
        }
        return rotatedStructure
    }

    private func rotatedClockwise() -> Array2D<T>? {
        var transposed = [[T?]](repeating: [], count: elements.count)
        for row in elements {
            for (i, inner) in row.enumerated() {
                transposed[i].append(inner)
            }
        }

        var reversed = [[T?]](repeating: [], count: elements.count)
        transposed.enumerated().forEach { (i, element) in
            reversed[i] = element.reversed()
        }
        return Array2D(elements: reversed)
    }
}

extension Array2D {
    func printArray() {
        #if DEBUG
        var result = ""
        for i in 0..<rows {
            guard let row = self[i]?.compactMap({ $0 }) else { continue }
            result += row.map({ "\($0)" }).joined(separator: ",") + "\n"
        }
        print(result)
        #endif
    }
}
