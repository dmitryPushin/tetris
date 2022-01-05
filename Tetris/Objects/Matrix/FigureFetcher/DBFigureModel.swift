//
//  DBFigureModel.swift
//  Tetris
//
//  Created by Dmitry Pushin on 15.03.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import Foundation

enum DBFigureType: String, Codable {
    case standard
    case custom
}

enum DBFigureModelField: Int, CaseIterable {
    case empty = 0
    case filled = 1
}

struct DBFigureModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case structure
    }

    let id: String
    let type: DBFigureType
    let structure: Array2D<Int>

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(DBFigureType.self, forKey: .type)
        let elements = try container.decode([[Int]].self, forKey: .structure)

        guard DBFigureModel.isSquareMatrix(array: elements),
              let array2d = Array2D(elements: elements) else {
            throw ErrorObject.codableError
        }

        structure = array2d
    }

    private static func isSquareMatrix(array: [[Int]]) -> Bool {
        return Set([array.count]) == Set(array.map { $0.count })
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(structure.elements, forKey: .structure)
    }
}
