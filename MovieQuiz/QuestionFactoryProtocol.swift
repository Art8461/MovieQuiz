//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Artem Kuzmenko on 30.06.2025.
//

import Foundation
protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
    func reset() 
}

