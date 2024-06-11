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
import AuthenticationServices
import UIKit

@Observable
@MainActor
class AuthenticationHandler: NSObject {
  
  var callbackURLScheme = "com.raywenderlich.StarCharles"
  var sheetIsActive = false
  let contextProvider: ASPresentationAnchor?
  
  init(contextProvider: ASPresentationAnchor?) {
    self.contextProvider = contextProvider
  }
}


extension AuthenticationHandler {
  
  @discardableResult
  func getIdTokenOrLoginIfNeeded() async throws -> String {
    let callBackURL = await getAuthorizationCode()
    let tokenModel = try await getToken(authorizationCode: callBackURL.get())
    KeychainHelper.create(value: tokenModel.accessToken, forIdentifier: "accessTokenId")
    return tokenModel.accessToken
    
    
  }
  private func getAuthorizationCode () async -> Result<String, Error> {
    return await withCheckedContinuation { [weak self] continuation in
      guard let self = self else {
        return continuation.resume(returning: .failure(CustomError.invalidData))
      }
      guard let url = NetworkingHandler.createAuthorizationURL() else {
        return continuation.resume(returning: .failure(CustomError.invalidURL))
      }
      
      if !sheetIsActive {
        let authenticationSession = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackURLScheme) { [weak self] callbackURL, error in
          self?.sheetIsActive = false
          if let error = error {
            continuation.resume(returning: .failure(CustomError.dissmissLogin(error: error.localizedDescription)))
          } else {
            if let callbackURL = callbackURL,
               let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems,
               let code = queryItems.first(where: {$0.name == "code"})?.value {
              continuation.resume(returning: .success(code))
            } else {
              continuation.resume(returning: .failure(CustomError.invalidData))
            }
          }
        }
        authenticationSession.presentationContextProvider = self
        authenticationSession.prefersEphemeralWebBrowserSession = false
        sheetIsActive = authenticationSession.start()
      } else {
        continuation.resume(returning: .failure(CustomError.internalError("The sheet is there already")))
      }
    }
    
  }
  private func getToken(authorizationCode: String? = nil, refreshToken: String? = nil) async throws -> TokenModel {
    do {
      var body: Data?
      if let code = authorizationCode {
        body = NetworkingHandler.createBody(code: code)
      }
      
      let request = try NetworkingHandler.createTokenRequest(
        urlString: NetworkingHandler.accessTokenURL,
        method: "POST",
        header: ["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json"],
        body: body
      )
      
      if let response: TokenModel = try await NetworkingHandler.sendRequest(request: request) {
        return response
      } else {
        throw CustomError.invalidData
      }
    } catch let error {
      throw error
    }
    
    
  }
  func logout() throws {
  }
}

extension AuthenticationHandler: ASWebAuthenticationPresentationContextProviding {
  public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    return self.contextProvider ?? ASPresentationAnchor()
  }
}



extension NetworkingHandler {
  
  public static var authorizeURL = "https://github.com/login/oauth/authorize"
  public static var accessTokenURL = "https://github.com/login/oauth/access_token"
  public static var verifier = SecurityHelper.generateCodeVerifier()
  public static var challenge = SecurityHelper.generateCodeChallenge(from: verifier)
  
  static func createAuthorizationURL() -> URL? {
    guard let authorizeURL = URL(string: NetworkingHandler.authorizeURL) else {
      return nil
    }
    let queryItems = [
      URLQueryItem(name: "client_id", value: "Ov23liORMNilbcrDa7bC"),
      URLQueryItem(name: "redirect_uri", value: "com.raywenderlich.StarCharles://callback"),
      URLQueryItem(name: "response_type", value: "code"),
      URLQueryItem(name: "scope", value: "read:user user:email"),
      URLQueryItem(name: "code_challenge_method", value: "S256"),
      URLQueryItem(name: "code_challenge", value: challenge)
    ]
    return createUrlComponents(url: authorizeURL, queryItems: queryItems).url
    
  }
  static func createTokenRequest(urlString: String,
                                 method: String,
                                 header: [String: String],
                                 body: Data?) throws -> URLRequest {
    guard let url = URL(string: urlString) else { throw CustomError.invalidURL }
    var URLRequest = URLRequest(url: url)
    URLRequest.httpMethod = method
    URLRequest.allHTTPHeaderFields = header
    URLRequest.httpBody = body
    return URLRequest
    
    
  }
  static func createBody(code: String? = nil, refreshToken: String? = nil) -> Data? {
    guard let url = URL(string: NetworkingHandler.accessTokenURL) else {return nil}
    
    var queryItems = [
      URLQueryItem(name: "client_id", value: "Ov23liORMNilbcrDa7bC"),
      URLQueryItem(name: "client_secret", value: "9b0ce014ae90dde0ad4c5b143a8ba84299679a12"),
      URLQueryItem(name: "redirect_uri", value: "com.raywenderlich.StarCharles://callback"),
    ]
    if let code = code {
      queryItems.append(URLQueryItem(name: "code", value: code))
    }
    return createUrlComponents(url: url, queryItems: queryItems).query?.data(using: .utf8)
  }
  
  
  private static func createUrlComponents(url: URL, queryItems: [URLQueryItem]?) -> URLComponents {
    var urlComponents = URLComponents()
    urlComponents.scheme = url.scheme
    urlComponents.host = url.host
    urlComponents.path = url.path
    urlComponents.queryItems = queryItems
    return urlComponents
  }
  
  
}

