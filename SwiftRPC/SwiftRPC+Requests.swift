//
//  SwiftRPC+Requests.swift
//  SwiftRPC
//
//  Created by Bruno Philipe on 24/8/17.
//  Copyright © 2017 Bruno Philipe. All rights reserved.
//

import Foundation

public extension SwiftRPC
{
	func getinfo(completion: @escaping (RPCResult<RPCInfo>) -> Void)
	{
		invoke(method: "getinfo", completion: completion)
	}

	public struct RPCInfo: Codable
	{
		let version: Int
		let protocolversion: Int
		let walletversion: Int
		let balance: Double
		let blocks: Int
		let timeoffset: Int
		let connections: Int
		let proxy: String
		let difficulty: Double
		let testnet: Bool
		let keypoololdest: Int
		let keypoolsize: Int
		let unlocked_until: Int
		let paytxfee: Double
		let relayfee: Double
		let errors: String
	}
}

public extension SwiftRPC
{
	func getbestblockhash(completion: @escaping (RPCResult<String>) -> Void)
	{
		invoke(method: "getbestblockhash", completion: completion)
	}
}

public extension SwiftRPC
{
	func getblockcount(completion: @escaping (RPCResult<Int>) -> Void)
	{
		invoke(method: "getblockcount", completion: completion)
	}
}
