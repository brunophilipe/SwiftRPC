//
//  SwiftRPC.swift
//  SwiftRPC
//
//  Created by Bruno Philipe on 23/8/17.
//  Copyright © 2017 Bruno Philipe. All rights reserved.
//

import Foundation

open class SwiftRPC
{
	private let username: String
	private let password: String
	private let host: String
	private let port: Int
	private let url: String

	open static var errorDomain = "com.brunophilipe.SwiftRPC"

	/// The count of processed requests, regardless of whether the request was successful or not.
	/// The value of this property is used as a nonce for the "id" parameter of requests.
	private var requestCount: Int64 = 0

	/// The JSON encoder used for all requests.
	private let jsonEncoder = JSONEncoder()

	/// The JSON decoder used for all requests.
	private let jsonDecoder = JSONDecoder()

	internal var urlSession: URLSession

	public init(username: String, password: String, host: String = "localhost", port: Int = 8332, url: String = "")
	{
		self.username = username
		self.password = password
		self.host = host
		self.port = port
		self.url = url

		urlSession = URLSession(configuration: .default)
	}

	@discardableResult
	open func invoke<T>(method: String, parameters: [RPCValue] = [], completion: @escaping (RPCResult<T>) -> Void) -> RPCRequest?
	{
		guard let url = URL(string: "http://\(host):\(port)/\(url)"),
			  let base64Auth = "\(username):\(password)".data(using: .ascii)?.base64EncodedString() else
		{
			return nil
		}

		requestCount += 1

		guard let jsonRequest = try? jsonEncoder.encode(StructuredRequest(method: method, params: parameters, id: requestCount)) else
		{
			return nil
		}

		var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
		request.setValue("Basic \(base64Auth)", forHTTPHeaderField: "Authorization")
		request.setValue("application/json", forHTTPHeaderField: "Content-type")
		request.httpMethod = "POST"
		request.httpBody = jsonRequest

		let task = urlSession.dataTask(with: request)
		{
			(data, response, error) in

			if let data = data
			{
				do
				{
					let response = try self.jsonDecoder.decode(RPCResponse<T>.self, from: data)

					if let result = response.result
					{
						completion(.result(result))
					}
					else if let error = response.error
					{
						completion(.error(NSError(domain: SwiftRPC.errorDomain, code: 1003, userInfo: ["code": error.code, NSLocalizedDescriptionKey: error.message])))
					}
				}
				catch let error
				{
					print("Error: \(error.localizedDescription)")
					completion(.error(NSError(domain: SwiftRPC.errorDomain, code: 1002)))
				}
			}
			else if let error = error
			{
				completion(.error(error))
			}
			else if let httpResponse = response as? HTTPURLResponse
			{
				if httpResponse.statusCode != 200
				{
					completion(.error(NSError(domain: SwiftRPC.errorDomain, code: 1001)))
				}
			}
		}

		task.resume()

		return RPCRequest(task: task, requestId: requestCount)
	}

	internal struct StructuredRequest: Codable
	{
		var method: String
		var params: [RPCValue]
		var id: Int64
	}
}

public enum RPCResult<T: Codable>
{
	case error(Error)
	case result(T)
}

public struct RPCResponse<T: Codable>: Codable
{
	var result: T?
	var error: RPCError?
	var id: Int
}

public struct RPCError: Codable
{
	var code: Int
	var message: String
}
