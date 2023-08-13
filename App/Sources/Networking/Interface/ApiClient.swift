//
//  Created by Jeans Ruiz on 11/08/23.
//

import Foundation

public struct ApiClient {
  public var apiRequest: (URLRequestable, NetworkLogger) async throws -> (Data, URLResponse)
  public var logger: () -> NetworkLogger

  public init(
    apiRequest: @escaping (URLRequestable, NetworkLogger) async throws -> (Data, URLResponse),
    logger: @escaping () -> NetworkLogger
  ) {
    self.apiRequest = apiRequest
    self.logger = logger
  }

  public func apiRequest(
    endpoint: URLRequestable,
    file: StaticString = #file,
    line: UInt = #line
  ) async throws -> (Data, URLResponse) {
    do {
      let (data, response) = try await apiRequest(endpoint, logger())
      return (data, response)
    } catch {
      throw ApiError(error: error, file: file, line: line)
    }
  }

  public func apiRequest<A: Decodable>(
    endpoint: URLRequestable,
    as: A.Type,
    file: StaticString = #file,
    line: UInt = #line
  ) async throws -> A {
    let (data, _) = try await apiRequest(endpoint: endpoint, file: file, line: line)

    do {
      return try endpoint.responseDecoder.decode(A.self, from: data)
    } catch {
      logger().logError(error)
      throw ApiError(error: error, file: file, line: line)
    }
  }
}
