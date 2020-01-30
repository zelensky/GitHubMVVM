//
//  GitHubMVVMTests.swift
//  GitHubMVVMTests
//
//  Created by Dmytro Zelenskyi on 29.01.2020.
//  Copyright © 2020 3. All rights reserved.
//

import XCTest
import CoreData
@testable import GitHubMVVM

class GitHubMVVMTests: XCTestCase {
  
  var sut: SearchViewController<UITableViewCell, CDResult>!
  
  override func setUp() {
    super.setUp()
    sut = SearchViewController<UITableViewCell, CDResult>()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  func testInitSearchViewController() {
    XCTAssertNotNil(sut)
  }
  
  func testNumberOfRowsInSection() {
    let numberOfRowsInSection = sut.tableView(UITableView(), numberOfRowsInSection: 0)
    XCTAssertEqual(numberOfRowsInSection, 0)
  }
  
  func testCellForRowAtIndexPathReturnsCell() {
    
  }
  
}
