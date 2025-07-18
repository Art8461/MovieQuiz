//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Artem Kuzmenko on 29.06.2025.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    internal weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    private var currentQuestionIndex = 0
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        guard !movies.isEmpty else {
            loadData()
            return
        }

        let index = (0..<movies.count).randomElement() ?? 0
        guard let movie = movies[safe: index] else { return }

        let rating = Float(movie.rating) ?? 0
        let text = "Рейтинг этого фильма больше чем 7?"
        let correctAnswer = rating > 7

        // 1. Сначала отправляем вопрос без картинки
        let questionWithoutImage = QuizQuestion(
            image: Data(),
            text: text,
            correctAnswer: correctAnswer
        )

        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didReceiveNextQuestion(question: questionWithoutImage)
        }

        // 2. Загружаем изображение асинхронно через URLSession
        let url = movie.resizedImageURL
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.didFailToLoadData(with: error)
                }
                return
            }

            guard let data = data else {
                let error = NSError(domain: "ImageLoading", code: 0, userInfo: [NSLocalizedDescriptionKey: "Изображение не загрузилось"])
                DispatchQueue.main.async {
                    self.delegate?.didFailToLoadData(with: error)
                }
                return
            }

            let questionWithImage = QuizQuestion(
                image: data,
                text: text,
                correctAnswer: correctAnswer
            )

            DispatchQueue.main.async {
                self.delegate?.didUpdateImage(for: questionWithImage)
            }

        }.resume()
    }
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.currentQuestionIndex = 0
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func reset() {
        currentQuestionIndex = 0
    }
}
// MARK: - Data
/*private let allQuestions: [QuizQuestion] = [
 QuizQuestion(image: "The Godfather",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true),
 
 QuizQuestion(image: "The Dark Knight",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true),
 
 QuizQuestion(image: "Kill Bill",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true),
 
 QuizQuestion(image: "The Avengers",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true),
 
 QuizQuestion(image: "Deadpool",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true),
 
 QuizQuestion(image: "The Green Knight",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: true),
 
 QuizQuestion(image: "Old",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: false),
 
 QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: false),
 
 QuizQuestion(image: "Tesla",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: false),
 
 QuizQuestion(image: "Vivarium",
 text: "Рейтинг этого фильма больше чем 6?",
 correctAnswer: false)
 ]*/
