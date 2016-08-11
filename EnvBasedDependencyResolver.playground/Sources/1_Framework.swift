import Foundation

// --------------------------------------------------------------------------------
// MARK: - ApplicationContextProvider
// --------------------------------------------------------------------------------

/// `ApplicationContextProvider` defines all basic dependencies available to all targets.
/// To be implemented by `ApplicationContext`, `MockContext`,  whatever.
public protocol ApplicationContextProvider {

  func now() -> Date

  func webService() -> WebServiceType.Type

  func actionCreator() -> ActionCreatorType

  func mainStore() -> Store<AppState>
}

// --------------------------------------------------------------------------------
// MARK: - DependencyResolver
// --------------------------------------------------------------------------------

/// DependencyResolver protocol
///
/// Used as a way to restrict injection of shared dependencies.
/// Like: `webService`, `mainStore` and so forth.
///
/// Restriction means that `DependencyResolver` does not expose any
/// dependencies in the protocol.
///
/// Access will be granted via extension like:
///
///      extension DependencyResolver where Territory == ViewController {
///        func mainStore() -> MainStore {
///          return resolve { $0.mainStore() }
///        }
///      }
///
///
public protocol DependencyResolver {

  /// Territory is the type that accesses the Resolver.
  associatedtype Territory

  /// Resolve will take a `(ApplicationContext) -> D` closure.
  /// This is more or less a lawless implementaion of a Reader Monad.
  /// Depending on the actual type of `ApplicationContext`
  /// this will return the valid dependency of Type D.
  /// - parameter dependency: (ApplicationContext) -> D
  /// - returns: D
  func resolve<D>(_ dependency: (ApplicationContextProvider) -> D) -> D
}

// --------------------------------------------------------------------------------
// MARK: - Env
// --------------------------------------------------------------------------------

/// Env a.k.a. DependencyResolver implementation
///
/// Will be created with a generic type `T` a.k.a Territory
/// which gets hooked up to the `Territory` of `DependencyResolver` protocol.
public struct Env<T>: DependencyResolver {

  /// The `Territory` from `DependencyResolver` protocol
  public typealias Territory = T

  /// The `applicationContext` providing access to all Dependencies.
  private var applicationContext: ApplicationContextProvider

  /// init
  public init(applicationContext: ApplicationContextProvider) {
    self.applicationContext = applicationContext
  }

  /// A public function to swap the applicationContext for e.g. mocks
  public mutating func swap(applicationContext swappedContext: ApplicationContextProvider) {
    applicationContext = swappedContext
  }

  /// Resolve will return the dependency.
  public func resolve<D>(_ dependencyFrom: (ApplicationContextProvider) -> D) -> D {
    return dependencyFrom(applicationContext)
  }

}

extension Env: CustomStringConvertible {

  public var description: String {
    return "Env with \(applicationContext)"
  }
}

// --------------------------------------------------------------------------------
// MARK: - EnvAware
// --------------------------------------------------------------------------------

/// Every type that should get access to dependencies should conform to EnvAware.
/// Currently this means that you need a propery called `env`.
///
/// Typical Usage:
///
///     final class ViewController: UIViewController, EnvAware {
///       var env = ViewController.defaultEnv
///     }
///
public protocol EnvAware {

  /// The `env` generic to Self
  var env: Env<Self> { get set }

}


