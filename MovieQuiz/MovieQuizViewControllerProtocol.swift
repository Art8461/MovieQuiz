//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Artem Kuzmenko on 31.07.2025.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStep)
    func show(result: QuizResults)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
