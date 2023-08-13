//
//  Created by Jeans Ruiz on 11/08/23.
//

import Foundation

extension ApiClient {
  public static func live(
    networkConfig: NetworkConfig,
    urlSession: URLSessionManager = .live,
    logger: NetworkLogger = .live
  ) -> ApiClient {
    return ApiClient(
      apiRequest: { try await request(endpoint: $0, networkConfig: networkConfig, urlSession: urlSession, logger: $1) },
      logger: { logger }
    )
  }
}

private func request(
  endpoint: URLRequestable,
  networkConfig: NetworkConfig,
  urlSession: URLSessionManager,
  logger: NetworkLogger
) async throws -> (Data, URLResponse) {
  guard let request = try? endpoint.urlRequest(with: networkConfig) else {
    throw URLError(.badURL)
  }
  logger.logRequest(request)
  do {
    let (data, response) = try await urlSession.request(request)
    logger.logResponse(data, response)
    return (data, response)
  } catch {
    logger.logError(error)
    throw error
  }
}
