//
//  RPCRequest.swift
//  SwiftRPC
//
//  Created by Bruno Philipe on 23/8/17.
//  Copyright © 2017 Bruno Philipe. All rights reserved.
//

import Foundation

open class RPCRequest
{
	private let task: URLSessionTask

	open let requestId: Int64

	open var completed: Bool
	{
		return task.state == .completed
	}

	public init(task: URLSessionTask, requestId: Int64)
	{
		self.task = task
		self.requestId = requestId
	}
}
