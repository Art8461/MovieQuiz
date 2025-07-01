//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Artem Kuzmenko on 01.07.2025.
//

import Foundation

final class StatisticServiceImplementation: StatisticServiceProtocol {
    
    // MARK: - Keys
    
    private enum Keys: String {
        case correctAnswers
        case bestGame
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
    }
    
    // MARK: - Properties
    
    private let storage: UserDefaults = .standard
    
    // MARK: - Private
    
    private var correctAnswers: Int {
        get {
            return storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    
    // MARK: - StatisticServiceProtocol
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        let totalQuestions = gamesCount * 10
        guard totalQuestions > 0 else { return 0.0 }
        
        return (Double(correctAnswers) / Double(totalQuestions)) * 100
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        correctAnswers += count
        
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        if currentGame.correct > bestGame.correct {
            bestGame = currentGame
        }
    }
}
