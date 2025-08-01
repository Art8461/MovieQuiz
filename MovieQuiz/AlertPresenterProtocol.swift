//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Artem Kuzmenko on 31.07.2025.
//
import Foundation
import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func present(alert: UIAlertController, animated: Bool)
}
