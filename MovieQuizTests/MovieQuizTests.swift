//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Artem Kuzmenko on 31.07.2025.
//

import Foundation
import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        //given
        let array = [1, 2, 3, 4, 5]
        //when
        let value = array[safe: 2]
        
        //then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }
    
    func testGetValueOutOfRange() throws {
        //given
        let array = [1, 2, 3, 4, 5]
        
        //when
        let value = array[safe: 20]
        
        //then
        XCTAssertNil(value)
    }
}
