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
    private let networkClient: NetworkRouting
    
    // MARK: - Init
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        let apikey = "k_zcuw1ytf"
        let stringUrl = "https://tv-api.com/en/API/Top250Movies/\(apikey)"
        guard let url = URL(string: stringUrl) else {
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
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    
                    if !mostPopularMovies.errorMessage.isEmpty || mostPopularMovies.items.isEmpty {
                        let apiError = NSError(
                            domain: "MoviesLoader",
                            code: 1,
                            userInfo: [NSLocalizedDescriptionKey: mostPopularMovies.errorMessage.isEmpty
                                       ? "Сервер вернул пустой список фильмов"
                                                                : mostPopularMovies.errorMessage]
                        )
                        handler(.failure(apiError))
                        return
                    }
                    
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
