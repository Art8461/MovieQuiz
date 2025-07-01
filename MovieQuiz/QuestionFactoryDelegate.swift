//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Artem Kuzmenko on 30.06.2025.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
