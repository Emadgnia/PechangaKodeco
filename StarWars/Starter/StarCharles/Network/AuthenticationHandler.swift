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
  }
  private func getAuthorizationCode () async -> Result<String, Error> {
  }
  private func getToken(authorizationCode: String? = nil, refreshToken: String? = nil) async throws -> TokenModel {
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
  }
  static func createTokenRequest(urlString: String,
                                 method: String,
                                 header: [String: String],
                                 body: Data?) throws -> URLRequest {
  }
  static func createBody(code: String? = nil, refreshToken: String? = nil) -> Data? {
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

