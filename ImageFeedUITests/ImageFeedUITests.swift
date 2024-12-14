//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by N L on 26.9.24..
//
import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        // тестируем сценарий авторизации
//        app.buttons["Authenticate"].tap()
//        let webView = app.webViews["UnsplashWebView"]
//        XCTAssertTrue(webView.waitForExistence(timeout: 5))
// 
//        let loginTextField = webView.descendants(matching: .textField).element
//        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
//       
//        loginTextField.tap()
//        loginTextField.typeText("kibodo@yandex.ru") // удалить
//        webView.swipeUp()
//        
//        let passwordTextField = webView.descendants(matching: .secureTextField).element
//        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
//       
//        passwordTextField.tap()
//        passwordTextField.typeText("Kibodo25") // удалить
//        webView.swipeUp()
//        webView.buttons["Login"].tap()
// 
//        let tablesQuery = app.tables
//        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
//        print(app.debugDescription)
//        
//        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
    }
}


//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//    
//    @MainActor
//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    @MainActor
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
//}
