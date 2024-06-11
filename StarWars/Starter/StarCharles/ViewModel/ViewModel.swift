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
import SwiftUI
import Observation

@Observable
class ViewModel {
  var films: [Film] = []
  var characters: [Character] = []
  var options = Options.allItems

  func fetchFilmsAsync() async throws {
    let request = RequestModel(path: .films, method: .get, header: ["Content-Type": "application/json", "cache-control": "no-cache"])
    let urlRequest = try NetworkingHandler.makeURLRequest(request: request)
    let films: Films = try await NetworkingHandler.sendRequest(request: urlRequest)
    self.films = films.results
  }
  
  func fetchFilmAsync(urlString: String) async throws {
    let request = RequestModel(baseURL: urlString, path: .empty, method: .get, header: ["Content-Type": "application/json", "cache-control": "no-cache"])
    let urlRequest = try NetworkingHandler.makeURLRequest(request: request)
    let film: Film = try await NetworkingHandler.sendRequest(request: urlRequest)
    self.films.append(film)
  }
  
  func fetchCharacterAsync(urlString: String) async throws {
    let request = RequestModel(baseURL: urlString, path: .empty, method: .get, header: ["Content-Type": "application/json", "cache-control": "no-cache"])
    let urlRequest = try NetworkingHandler.makeURLRequest(request: request)
    let character: Character = try await NetworkingHandler.sendRequest(request: urlRequest)
    self.characters.append(character)
  }
  func fetchCharactersAsync() async throws {
    let request = RequestModel(path: .people, method: .get, header: ["Content-Type": "application/json", "cache-control": "no-cache"])
    let urlRequest = try NetworkingHandler.makeURLRequest(request: request)
    let characters: Characters = try await NetworkingHandler.sendRequest(request: urlRequest)
    self.characters = characters.results
  }
}
