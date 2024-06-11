/// Copyright (c) 2024 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
public enum CustomError: Error, LocalizedError, Equatable {
  case decodingError(_ description: String? = nil)
  case invalidURL
  case noResponse
  case unknown
  case noInternet
  case invalidData
  case mockedError
  case mockedSuccess
  case emptyResponseData
  case unauthorized
  case forbidden
  case unexpectedStatusCode(_ code: Int)
  case backendError(_ code: Int)
  case requestFailed(_ description: String)
  case urlError(_ code: Int, _ description: String? = nil)
  case encodingError(_ description: String)
  case clientEntityError(data: Data, code: Int)
  case dissmissLogin(error: String)
  case internalError(_ msg: String)
  public var message: String {
    switch self {
    case .invalidURL, .noResponse, .unauthorized, .forbidden, .unknown, .noInternet, .invalidData:
      return "networkErrorMessage.\(self)"
    case .decodingError(let description):
      return "Decoding Error: \(description ?? "No Description")"
    case .mockedError:
      return "This is a mocked error"
    case .mockedSuccess:
      return "This is a mocked success"
    case .urlError(let code, let description):
      return "URLError Description: \(description ?? "No Description") || Code: \(code)"
    case .unexpectedStatusCode(let code):
      return "Unexpected Error with code: \(code)"
    case .requestFailed(let description):
      return "Request Failed error -> \(description)"
    case .encodingError(let description):
      return "JSON Conversion Failure -> \(description)"
    case .backendError(let code):
      return "Backend Error with code: \(code)"
    case .clientEntityError(data: _, code: let code):
      return "known error with code: \(code)"
    case .emptyResponseData:
      return "Empty Response Data"
    case .dissmissLogin(let error):
      return "Dissmiss Login \(error)"
    case .internalError(let msg):
      return "Unexpected Error with code: \(msg)"
    }
  }
  
  public var title: String {
    switch self {
    case .decodingError, .invalidURL, .noResponse, .unauthorized, .forbidden, .unknown,
        .noInternet, .invalidData, .requestFailed, .urlError, .backendError,
        .unexpectedStatusCode, .encodingError, .clientEntityError, .emptyResponseData, .dissmissLogin, .internalError:
      return "networkErrorTitle.\(self)"
    case .mockedError:
      return "Mock Error"
    case .mockedSuccess:
      return "Mock Success"
    }
  }
}
