//
//  RPCResult.swift
//  SwiftRPC
//
//  Created by Bruno Philipe on 23/8/17.
//  Copyright © 2017 Bruno Philipe. All rights reserved.
//

import Foundation

/// Represents the result field of an RPC response, which can be an individual value, an array, or a dictionary.
public enum RPCRawResult: Codable
{
	case value(RPCValue)
	case array([RPCValue])
	case dict([String: RPCValue])

	public init(from decoder: Decoder) throws
	{
		let singleDecoder = try decoder.singleValueContainer()

		if let value = try? singleDecoder.decode(RPCValue.self)
		{
			self = .value(value)
		}
		else if let array = try? singleDecoder.decode([RPCValue].self)
		{
			self = .array(array)
		}
		else if let dict = try? singleDecoder.decode([String: RPCValue].self)
		{
			self = .dict(dict)
		}
		else
		{
			throw NSError(domain: SwiftRPC.errorDomain, code: 1005, userInfo: [NSLocalizedDescriptionKey: "Failed to parse RPCResult"])
		}
	}

	public func encode(to encoder: Encoder) throws
	{
		var singleEncoder = encoder.singleValueContainer()

		switch self
		{
		case .array(let array):
			try singleEncoder.encode(array)

		case .dict(let dict):
			try singleEncoder.encode(dict)

		case .value(let value):
			try singleEncoder.encode(value)
		}
	}
}
