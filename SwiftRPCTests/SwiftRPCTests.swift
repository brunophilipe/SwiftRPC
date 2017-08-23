//
//  SwiftRPCTests.swift
//  SwiftRPCTests
//
//  Created by Bruno Philipe on 23/8/17.
//  Copyright © 2017 Bruno Philipe. All rights reserved.
//

import XCTest
@testable import SwiftRPC

class SwiftRPCTests: XCTestCase
{
	private var swiftRPC: SwiftRPC!

    override func setUp()
	{
        super.setUp()

		// Make sure to fill out the server settings in the TestsConfig.swift file.
		swiftRPC = SwiftRPC(username: TestsConfig.username,
		                    password: TestsConfig.password,
		                    host: TestsConfig.host,
		                    port: TestsConfig.port,
		                    url: TestsConfig.path)
    }
    
    override func tearDown()
	{
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testValidSettings()
	{
		XCTAssertNotEqual("", TestsConfig.username, "Fill the username field in the TestsConfig.swift file before running tests.")
		XCTAssertNotEqual("", TestsConfig.password, "Fill the password field in the TestsConfig.swift file before running tests.")
	}
    
	func testSimpleInvocation()
	{
		let expectation = XCTestExpectation(description: "Fetch info using raw invocation")

		swiftRPC.invoke(method: "getblockhash", parameters: [636])
		{
			result in

			if case .structured(let structuredResponse) = result,
			   case .some(.value(let hashValue)) = structuredResponse.result,
			   case .string(let hashString) = hashValue
			{
				// This test will fail if run on a coin other than Bitcoin
				XCTAssertEqual("000000008b0f1bc19009361b30547a86588b0a3a00d6f2dbbe1f744eff3cb21f", hashString)
			}
			else
			{
				XCTFail("Unexpected response from 'getblockhash 636' RPC request.")
			}

			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 15.0)
	}
}
