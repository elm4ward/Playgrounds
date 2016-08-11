import Foundation

// --------------------------------------------------------------------------------
// MARK: - Dependencies
// --------------------------------------------------------------------------------

public struct ActionCreator: ActionCreatorType, EnvAware {

  public var env = ActionCreator.defaultEnv

  public init(){

  }
}

struct WebService: WebServiceType {}

// --------------------------------------------------------------------------------
// MARK: - ApplicationContext
// --------------------------------------------------------------------------------

/// `ApplicationContext` for RealLife®.
/// No one should mess with that – just kidding.
///
/// Every Dependency is defined here. That does not mean it is available everywhere.
/// In order to make it visible the `DependencyResolver` needs to be extended.
public struct ApplicationContext: ApplicationContextProvider {

  let store = Store<AppState>()

  public func mainStore() -> Store<AppState> {
    return store
  }

  public func now() -> Date {
    return Date()
  }

  public func webService() -> WebServiceType.Type {
    return WebService.self
  }

  public func actionCreator() -> ActionCreatorType {
    return ActionCreator()
  }
  
}

// --------------------------------------------------------------------------------
// MARK: - EnvAware
// --------------------------------------------------------------------------------

/// Extension for EnvAware to provide easy access to
///     class XYZ {
///       env: Env<XYZ> = Env(applicationContext: RealContext())
///     }
///
public extension EnvAware {

  /// `defaultEnv` is used to provide easy access to the generic definition of the `env` property
  static var defaultEnv: Env<Self> {
    return Env(applicationContext: ApplicationContext())
  }

}
