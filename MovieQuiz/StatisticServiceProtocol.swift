//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Artem Kuzmenko on 01.07.2025.
//

import Foundation
protocol StatisticServiceProtocol {
    
    // MARK: - Properties
    
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    // MARK: - Methods
    
    func store(correct count: Int, total amount: Int)
}
