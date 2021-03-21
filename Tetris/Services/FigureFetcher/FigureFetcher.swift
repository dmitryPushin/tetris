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
        if let elementURLs = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil) {
            return elementURLs.compactMap({ obtainModelFrom(url: $0) })
        }
        throw ErrorObject.noFigures
    }

    private static func obtainModelFrom(url: URL) -> DBFigureModel? {
        if let data = try? Data(contentsOf: url) ,
           let decoded = try? JSONDecoder().decode(DBFigureModel.self, from: data) {
            return decoded
        }
        return nil
    }
}
