/// Copyright (c) 2021 Razeware LLC
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

public final class NetworkingHandler {
  
  @discardableResult
  static func sendRequest<Response: Codable>(request: URLRequest, sessionDelegate: URLSessionTaskDelegate? = nil) async throws -> Response {
    let session: URLSession
    if let delegate = sessionDelegate {
      session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
    } else {
      session = URLSession.shared
    }
    do {
      let (data, response) = try await session.data(for: request)
      guard let response = response as? HTTPURLResponse else {
        throw CustomError.noResponse
      }
      
      switch response.statusCode {
      case 200...299:
        if data.isEmpty {
          throw CustomError.emptyResponseData
        } else {
          let decoder = JSONDecoder()
          decoder.dateDecodingStrategy = .secondsSince1970
          print("----- Response ------")
          print(request.url)
          do {
            return try decoder.decode(Response.self, from: data)
          } catch {
            print("----- Decoding Error ----- \(error)")
            throw CustomError.decodingError(error.localizedDescription)
          }
        }
      case 401:
        throw CustomError.unauthorized
      case 402:
        throw CustomError.clientEntityError(data: data, code: response.statusCode)
      case 403:
        throw CustomError.forbidden
      case 404...499:
        throw CustomError.clientEntityError(data: data, code: response.statusCode)
      case 500...599:
        throw CustomError.backendError(response.statusCode)
      default:
        throw CustomError.unexpectedStatusCode(response.statusCode)
      }
    } catch {
      if let error = error as? URLError {
        throw CustomError.urlError(error.errorCode, error.localizedDescription)
      } else {
        throw error
      }
    }
  }
  
  static func makeURLRequest(request: RequestModel) throws -> URLRequest {
    guard let url = URL(string: request.baseURL + request.path.rawValue) else {
      throw CustomError.invalidURL
    }
    
    var URLRequest = URLRequest(url: url)
    URLRequest.httpMethod = request.method.rawValue
    URLRequest.allHTTPHeaderFields = request.header
    print("---- URL Request ----")
    print("\(url)")
    
    if let body = request.body {
      URLRequest.httpBody = body
      print("---- URL Body ----")
      print("\(body)")
    }
    return URLRequest
  }
}

