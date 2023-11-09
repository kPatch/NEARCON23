import Foundation

final class RestHandler {
    /// Shared Singleton object for use within the OpenAIKit API Module
    internal static let shared = RestHandler()

    /// Conforming to the Singleton Design Pattern
    private init() {  }

    /// Uses URLRequest to set up a HTTPMethod, and implement default values for the method cases.
    public enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }

    /// Decode a data object using `JSONDecoder.decode()`.
    /// - Parameters:
    ///   - type: The type of `T` that the data will decode to.
    ///   - data: `Data` input object.
    ///   - keyDecodingStrategy: Default is `.useDefaultKeys`.
    ///   - dataDecodingStrategy: Default is `.deferredToData`.
    ///   - dateDecodingStrategy: Default is `.deferredToDate`.
    /// - Returns: Decoded data of `T` type, or throws an `OpenAIErrorRaesponse` object.
    private func decodeData<T: Decodable>(
        _ type: T.Type = T.self,
        with data: Data,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .deferredToData,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate
    ) async throws -> T {
        let decoder = JSONDecoder()

        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dataDecodingStrategy = dataDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy

        guard let decoded = try? decoder.decode(type, from: data) else {
            throw NSError(domain: "Unable to decode object", code: -1)
        }
        return decoded
    }

    /// Takes a `URL` input, along with header information, and converts it into a `URLRequest`;
    /// and fetches the data using an `Async` `Await` wrapper for the older `dataTask` handler.
    /// - Parameters:
    ///   - url: `URL` to convert to a `URLRequest`.
    ///   - method: Input can be either a `.get` or a `.post` method, with the default being `.post`.
    ///   - headers: Header data for the request that uses a `[string:string]` dictionary,
    ///   and the default is set to an empty dictionary.
    ///   - body: Body data that defaults to `nil`.
    /// - Returns: The data that was fetched typed as a `Data` object.
    public static func asyncData(
        with url: URL,
        method: HTTPMethod = .post,
        headers: [String: String] = [:],
        body: Data? = nil
    ) async throws -> Data {
        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = [
            "accept": "application/json"
        ]
        request.httpBody = body

        headers.forEach { key, value in
            request.allHTTPHeaderFields?[key] = value
        }

        return try await self.asyncData(with: request)
    }

    /// An Async Await wrapper for the older `dataTask` handler.
    /// - Parameter request: `URLRequest` to be fetched from.
    /// - Returns: A Data object fetched from the` URLRequest`.
    private static func asyncData(with request: URLRequest) async throws -> Data {
        try await withCheckedThrowingContinuation { (con: CheckedContinuation<Data, Error>) in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    con.resume(throwing: error)
                } else if let data = data {
                    con.resume(returning: data)
                } else {
                    con.resume(returning: Data())
                }
            }

            task.resume()
        }
    }
    
    /// Decode a `URL` to the type `T` using either `asyncData()` for the Production Server;
    /// or using `decode()` for the Mock Server.
    /// - Parameters:
    ///   - type: The type of `T` that the data will decode to.
    ///   - with: The input url of type `URL` that will be fetched.
    ///   - apiKey: The API Key for use with the server.
    ///   - body: The POST body used to add parameters, defaults to `nil`.
    ///   - method: The method used for the function, defaults to `.post`.
    ///   - bodyRequired: Is the body required or not, used for `.get` and `.delete`, defaults to `false`.
    ///   - formSubmission: Is the body actually a form submission? Used for image submissionss, defaults to `false`.
    /// - Returns: The decoded object of type `T`.
    public func decodeUrl<T: Decodable>(
        _ type: T.Type = T.self,
        with url: URL,
        apiKey: String,
        method: HTTPMethod = .post
    ) async throws -> T {
        let data = try await Self.asyncData(
            with: url,
            method: method,
            headers: ["X-API-Key": apiKey]
        )

        return try await self.decodeData(with: data)
    }
}
