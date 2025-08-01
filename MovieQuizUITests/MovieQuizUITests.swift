//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Artem Kuzmenko on 31.07.2025.
//
import XCTest

final class MovieQuizUITests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testYesButton() throws {
        let firstPoster = app.images.element(boundBy: 0)
        XCTAssertTrue(firstPoster.waitForExistence(timeout: 5), "Постер не появился на экране")
        
        let yesButton = app.buttons["Yes"]
        XCTAssertTrue(yesButton.exists, "Кнопка Yes не найдена")
        
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        yesButton.tap()
        
        sleep(2) // Задержка для обновления изображения
        
        let secondPosterData = firstPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData, "Постер не изменился после нажатия Yes")
    }
    
    func testNoButton() throws {
        let firstPoster = app.images.element(boundBy: 0)
        XCTAssertTrue(firstPoster.waitForExistence(timeout: 5), "Постер не появился на экране")
        
        let noButton = app.buttons["No"]
        XCTAssertTrue(noButton.exists, "Кнопка No не найдена")
        
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        noButton.tap()
        
        sleep(2) // Задержка для обновления изображения
        
        let secondPosterData = firstPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData, "Постер не изменился после нажатия No")
    }
    
    func testGameFinishAlert() throws {
        let yesButton = app.buttons["Yes"]
        XCTAssertTrue(yesButton.waitForExistence(timeout: 5), "Кнопка Yes не найдена")
        
        for _ in 0..<10 {
            yesButton.tap()
            sleep(1) // Пауза между нажатиями
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Алёрт не появился после 10 вопросов")
        
        let alertButton = alert.buttons["Сыграть ещё раз"]
        XCTAssertTrue(alertButton.exists, "Кнопка 'Сыграть ещё раз' не найдена в алёрте")
        
        // Нажать на кнопку
        let playAgainButton = alert.buttons["Сыграть ещё раз"]
        playAgainButton.tap()
        // Проверка, что алерт исчез
        XCTAssertFalse(alert.exists, "Алерт не исчез после нажатия на 'Сыграть ещё раз'")
        
        // Проверка, что счётчик сброшен на 1/10
        let counterLabel = app.staticTexts["1/10"]
        XCTAssertTrue(counterLabel.waitForExistence(timeout: 5), "Счётчик не сброшен на 1/10")
    }
}
