//
//  FigureConverter.swift
//  Tetris
//
//  Created by Dmitry Pushin on 20.02.2021.
//  Copyright © 2021 Dmitry Pushin. All rights reserved.
//

import Foundation

protocol FigureFetcherInput {
    static func prepareFigures() throws -> [DBFigureModel]
}

class FigureFetcher {
    static func prepareFigures() throws -> [DBFigureModel] {
        if let figuresURL = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil) {
            let result = figuresURL
                .compactMap({ obtainModelFrom(url: $0) })
                .reduce([], +)
            return result
        }
        throw ErrorObject.noFigures
    }

    private static func obtainModelFrom(url: URL) -> [DBFigureModel]? {
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([DBFigureModel].self, from: data)
            return decoded
        } catch let error {
            print(error)
            return nil
        }
    }
}
