//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Artem Kuzmenko on 30.06.2025.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
    func willLoadNextQuestion()
    func didUpdateImage(for question: QuizQuestion)
}
