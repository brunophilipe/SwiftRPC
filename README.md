# SwiftRPC

Swift 4 implementation of the Bitcoin RPC protocol.

## About

This library allows applications to make RPC calls to any Bitcoin node software that implements the Bitcoin-RPC protocol.

Currently it provides a generic `invoke()` method which allows any arbitrary RPC method to be called, and a few concrete implementation of some RPC methods such as `getinfo`, `getbestblockhash`, and `getblockcount`. More concrete implementations will be added in the future, and it is very easy to create new ones with an extension. See the implementation of `getinfo` for a good example of how to create a high-level RPC call with error and type checking.

The current object structure is subject to change, so I would not recommend using this library on any serious project yet. Especially the usage of `invoke` can be a bit cumbersome, so I intend to simplify this library a lot in the future. Please feel free to make contributions.

## Example

```swift
let swiftRPC = SwiftRPC(username: "user", password: "pass")

// getinfo
swiftRPC.getinfo()
{
	(result) in

	if case .result(let info) = result
	{
		print(info.balance) // 0.42283
	}
}

// getbestblockhash
swiftRPC.getbestblockhash()
{
	(result) in

	if case .result(let hashString) = result
	{
		print(hashString) // 0000000000000000032099c69bec4a5b8e1da358998c7764cbc02a533c804dab
	}
}

// using invoke to query for a currently not-implemented method, 'getblockhash'
swiftRPC.invoke(method: "getblockhash", parameters: [636])
{
	(result: RPCResult<RPCRawResult>) in

	if case .result(let response) = result,
	   case .value(let hashValue) = response,
	   case .string(let hashString) = hashValue
	{
		print(hashString) // 000000008b0f1bc19009361b30547a86588b0a3a00d6f2dbbe1f744eff3cb21f
	}
}
```

## License

```
Copyright (c) 2017 Bruno Philipe

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```