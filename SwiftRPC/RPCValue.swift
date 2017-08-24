//
//  RPCValue.swift
//  SwiftRPC
//
//  Created by Bruno Philipe on 24/8/17.
//  Copyright © 2017 Bruno Philipe. All rights reserved.
//

import Foundation

/// Represents a value in a JSON array/dictionary.
public enum RPCValue: Codable
{
	case string(String)
	case int(Int)
	case double(Double)
	case bool(Bool)
	case null

	public init(from decoder: Decoder) throws
	{
		let value = try decoder.singleValueContainer()

		if let intValue = try? value.decode(Int.self)
		{
			self = .int(intValue)
		}
		else if let doubleValue = try? value.decode(Double.self)
		{
			self = .double(doubleValue)
		}
		else if let stringValue = try? value.decode(String.self)
		{
			self = .string(stringValue)
		}
		else if value.decodeNil()
		{
			self = .null
		}
		else
		{
			self = .bool(try value.decode(Bool.self))
		}
	}

	public func encode(to encoder: Encoder) throws
	{
		var singleEncoder = encoder.singleValueContainer()

		switch self
		{
		case .bool(let boolValue):
			try singleEncoder.encode(boolValue)
		case .double(let doubleValue):
			try singleEncoder.encode(doubleValue)
		case .int(let intValue):
			try singleEncoder.encode(intValue)
		case .string(let stringValue):
			try singleEncoder.encode(stringValue)
		case .null:
			try singleEncoder.encodeNil()
		}
	}
}

extension RPCValue: ExpressibleByIntegerLiteral
{
	public typealias IntegerLiteralType = Int

	public init(integerLiteral value: IntegerLiteralType)
	{
		self = .int(value)
	}
}

extension RPCValue: ExpressibleByStringLiteral
{
	public typealias StringLiteralType = String

	public init(stringLiteral value: StringLiteralType)
	{
		self = .string(value)
	}
}

extension RPCValue: ExpressibleByFloatLiteral
{
	public typealias FloatLiteralType = Double

	public init(floatLiteral value: FloatLiteralType)
	{
		self = .double(value)
	}
}

extension RPCValue: ExpressibleByNilLiteral
{
	public init(nilLiteral: ())
	{
		self = .null
	}
}

extension RPCValue: ExpressibleByBooleanLiteral
{
	public typealias BooleanLiteralType = Bool

	public init(booleanLiteral value: BooleanLiteralType)
	{
		self = .bool(value)
	}
}
