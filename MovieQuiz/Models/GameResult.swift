//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Artem Kuzmenko on 01.07.2025.
//
import Foundation

struct GameResult: Codable, Equatable {
    let correct: Int
    let total: Int
    let date: Date

    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
