//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Artem Kuzmenko on 12.07.2025.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        print("📡 Загружаю фильмы...")
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                print("✅ Получены данные: \(data.count) байт")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON от сервера:\n\(jsonString)")
                }
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    print("✅ Успешно декодировано")
                    handler(.success(mostPopularMovies))
                } catch {
                    print("❌ Ошибка декодирования: \(error)")
                    handler(.failure(error))
                }
            case .failure(let error):
                print("❌ Ошибка сети: \(error)")
                handler(.failure(error))
            }
        }
    }
}
