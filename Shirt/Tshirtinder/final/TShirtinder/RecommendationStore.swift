/// Copyright (c) 2022 Razeware LLC
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
import TabularData

#if canImport(CreateML)
import CreateML
#endif

final class RecommendationStore {
  private let queue = DispatchQueue(label: "com.recommendation-service.queue", qos: .userInitiated)

  func computeRecommendations(basedOn items: [FavoriteWrapper<Shirt>]) async throws -> [Shirt] {
    return try await withCheckedThrowingContinuation { continuation in
      queue.async {
        #if targetEnvironment(simulator)
        continuation.resume(throwing: NSError(domain: "Simulator Not Supported", code: -1))
        #else
        let trainingData = items.filter {
          $0.isFavorite != nil
        }

        let trainingDataFrame = self.dataFrame(for: trainingData)

        let testData = items
        let testDataFrame = self.dataFrame(for: testData)

        do {
          let regressor = try MLLinearRegressor(trainingData: trainingDataFrame, targetColumn: "favorite")

          let predictionsColumn = (try regressor.predictions(from: testDataFrame)).compactMap { value in
            value as? Double
          }

          let sorted = zip(testData, predictionsColumn)
            .sorted { lhs, rhs -> Bool in
              lhs.1 > rhs.1
            }
            .filter {
              $0.1 > 0
            }
            .prefix(10)

          print(sorted.map(\.1))

          let result = sorted.map(\.0.model)

          continuation.resume(returning: result)
        } catch {
          continuation.resume(throwing: error)
        }
        #endif
      }
    }
  }

  private func dataFrame(for data: [FavoriteWrapper<Shirt>]) -> DataFrame {
    var dataFrame = DataFrame()

    dataFrame.append(
      column: Column(name: "color", contents: data.map(\.model.color.rawValue))
    )

    dataFrame.append(
      column: Column(name: "design", contents: data.map(\.model.design.rawValue))
    )

    dataFrame.append(
      column: Column(name: "neck", contents: data.map(\.model.neck.rawValue))
    )

    dataFrame.append(
      column: Column(name: "sleeve", contents: data.map(\.model.sleeve.rawValue))
    )

    dataFrame.append(
      column: Column<Int>(
        name: "favorite",
        contents: data.map {
          if let isFavorite = $0.isFavorite {
            return isFavorite ? 1 : -1
          } else {
            return 0
          }
        }
      )
    )

    return dataFrame
  }
}
