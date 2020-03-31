/// Capable of being authenticated.
public protocol Authenticatable { }

public protocol Authenticator: Middleware { }

public protocol RequestAuthenticator: Authenticator {
    func authenticate(request: Request) -> EventLoopFuture<Void>
}

extension RequestAuthenticator {
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        return self.authenticate(request: request).flatMap {
            next.respond(to: request)
        }
    }
}

// MARK: Basic

public protocol BasicAuthenticator: RequestAuthenticator {
    func authenticate(basic: BasicAuthorization, for request: Request) -> EventLoopFuture<Void>
}

extension BasicAuthenticator {
    public func authenticate(request: Request) -> EventLoopFuture<Void> {
        guard let basicAuthorization = request.headers.basicAuthorization else {
            return request.eventLoop.makeSucceededFuture(())
        }
        return self.authenticate(basic: basicAuthorization, for: request)
    }
}

// MARK: Bearer

public protocol BearerAuthenticator: RequestAuthenticator {
    func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<Void>
}

extension BearerAuthenticator {
    public func authenticate(request: Request) -> EventLoopFuture<Void> {
        guard let bearerAuthorization = request.headers.bearerAuthorization else {
            return request.eventLoop.makeSucceededFuture(())
        }
        return self.authenticate(bearer: bearerAuthorization, for: request)
    }
}

// MARK: Credentials

public protocol CredentialsAuthenticator: RequestAuthenticator {
    associatedtype Credentials: Content
    func authenticate(credentials: Credentials, for request: Request) -> EventLoopFuture<Void>
}

extension CredentialsAuthenticator {
    public func authenticate(request: Request) -> EventLoopFuture<Void> {
        let credentials: Credentials
        do {
            credentials = try request.content.decode(Credentials.self)
        } catch {
            request.logger.error("Could not decode credentials: \(error)")
            return request.eventLoop.makeSucceededFuture(())
        }
        return self.authenticate(credentials: credentials, for: request)
    }
}
