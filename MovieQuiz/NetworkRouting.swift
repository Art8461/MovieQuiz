//
//  NetworkRouting.swift
//  MovieQuiz
//
//  Created by Artem Kuzmenko on 31.07.2025.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
