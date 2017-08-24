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
	private var swiftRPC: MockSwiftRPC!

    override func setUp()
	{
        super.setUp()

		// Make sure to fill out the server settings in the TestsConfig.swift file.
		swiftRPC = MockSwiftRPC(username: "", password: "")
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
		let jsonResponse =
"""
{
	"result": "000000008b0f1bc19009361b30547a86588b0a3a00d6f2dbbe1f744eff3cb21f",
	"error": null,
	"id": 1
}
"""
		swiftRPC.mockedResponseData = jsonResponse.data(using: .utf8)

		let expectation = XCTestExpectation(description: "Fetch info using raw invocation.")

		swiftRPC.invoke(method: "getblockhash", parameters: [636])
		{
			(result: RPCResult<RPCRawResult>) in

			if case .result(let response) = result,
			   case .value(let hashValue) = response,
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

	func testGetInfo()
	{
		let jsonResponse =
"""
{
    "result":
    {
        "version": 140600,
        "protocolversion": 70015,
        "walletversion": 60000,
        "balance": 0.41921317,
        "blocks": 481871,
        "timeoffset": -1,
        "connections": 8,
        "proxy": "",
        "difficulty": 272888550038.8189,
        "testnet": false,
        "keypoololdest": 1501808674,
        "keypoolsize": 100,
        "unlocked_until": 0,
        "paytxfee": 0.00000000,
        "relayfee": 0.00001000,
        "errors": ""
    },
    "error": null,
    "id": 1
}
"""
		swiftRPC.mockedResponseData = jsonResponse.data(using: .utf8)

		let expectation = XCTestExpectation(description: "Fetch info.")

		swiftRPC.getinfo()
		{
			(result) in

			if case .result(let info) = result
			{
				XCTAssertEqual(info.version, 140600)
				XCTAssertEqual(info.protocolversion, 70015)
				XCTAssertEqual(info.walletversion, 60000)
				XCTAssertEqual(info.balance, 0.41921317)
				XCTAssertEqual(info.blocks, 481871)
				XCTAssertEqual(info.timeoffset, -1)
				XCTAssertEqual(info.connections, 8)
				XCTAssertEqual(info.proxy, "")
				XCTAssertEqual(info.difficulty, 272888550038.8189)
				XCTAssertEqual(info.testnet, false)
				XCTAssertEqual(info.keypoololdest, 1501808674)
				XCTAssertEqual(info.keypoolsize, 100)
				XCTAssertEqual(info.unlocked_until, 0)
				XCTAssertEqual(info.paytxfee, 0.00000000)
				XCTAssertEqual(info.relayfee, 0.00001000)
				XCTAssertEqual(info.errors, "")
			}
			else
			{
				XCTFail("Unexpected response from 'getinfo' RPC request.")
			}

			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 15.0)
	}

	func testGetBestBlockHash()
	{
		let jsonResponse =
"""
{
	"result": "0000000000000000032099c69bec4a5b8e1da358998c7764cbc02a533c804dab",
	"error": null,
	"id": 1
}
"""
		swiftRPC.mockedResponseData = jsonResponse.data(using: .utf8)

		let expectation = XCTestExpectation(description: "Fetch info using raw invocation.")

		swiftRPC.getbestblockhash()
		{
			(result) in

			if case .result(let hashString) = result
			{
				// This test will fail if run on a coin other than Bitcoin
				XCTAssertEqual("0000000000000000032099c69bec4a5b8e1da358998c7764cbc02a533c804dab", hashString)
			}
			else
			{
				XCTFail("Unexpected response from 'getbestblockhash' RPC request.")
			}

			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 15.0)
	}

	func testGetBlockCount()
	{
		let jsonResponse =
"""
{
	"result": 481872,
	"error": null,
	"id": 1
}
"""
		swiftRPC.mockedResponseData = jsonResponse.data(using: .utf8)

		let expectation = XCTestExpectation(description: "Fetch info using raw invocation.")

		swiftRPC.getblockcount()
			{
				(result) in

				if case .result(let blockCount) = result
				{
					// This test will fail if run on a coin other than Bitcoin
					XCTAssertEqual(481872, blockCount)
				}
				else
				{
					XCTFail("Unexpected response from 'getbestblockhash' RPC request.")
				}

				expectation.fulfill()
		}

		wait(for: [expectation], timeout: 15.0)
	}
}

class MockSwiftRPC: SwiftRPC
{
	var mockedResponseData: Data?
	{
		get
		{
			return (urlSession as! MockURLSession).mockedResponseData
		}

		set
		{
			(urlSession as! MockURLSession).mockedResponseData = newValue
		}
	}

	init(username: String, password: String)
	{
		super.init(username: username, password: password)

		self.urlSession = MockURLSession()
	}

	class MockURLSession: URLSession
	{
		var mockedResponseData: Data? = nil

		override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
		{
			completionHandler(mockedResponseData, HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "1.1", headerFields: nil), nil)

			return MockURLSessionDataTask()
		}
	}

	class MockURLSessionDataTask: URLSessionDataTask
	{
		override func resume() {}
	}
}
