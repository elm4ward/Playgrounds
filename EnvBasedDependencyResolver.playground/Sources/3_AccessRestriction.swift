import Foundation

// --------------------------------------------------------------------------------
// MARK: - DependencyResolver Access Config
// --------------------------------------------------------------------------------

/// Extending `DependencyResolver` to give access
/// to Date now for all Types
public extension DependencyResolver {

  func now() -> Date {
    return resolve { $0.now() }
  }

}

// --------------------------------------------------------------------------------
// MARK: - Access To WebService
// --------------------------------------------------------------------------------

/// WebServiceAware
public protocol WebServiceAware: EnvAware {}

/// Extending `DependencyResolver` to give access
/// to WebServiceType for all Types conforming to `WebServiceAware`
public extension DependencyResolver where Territory: WebServiceAware {

  func webService() -> WebServiceType.Type {
    return resolve { $0.webService() }
  }

}

// --------------------------------------------------------------------------------
// MARK: - Access To ActionCreator
// --------------------------------------------------------------------------------

/// ActionCreatorAware
public protocol ActionCreatorAware: EnvAware {}

public extension DependencyResolver where Territory: ActionCreatorAware {

  func actionCreator() -> ActionCreatorType {
    return resolve { $0.actionCreator() }
  }

}

// --------------------------------------------------------------------------------
// MARK: - Access To Store
// --------------------------------------------------------------------------------

public protocol MainStoreAware: EnvAware {}

/// Extending DependencyResolver` to give access to `mainStore`
public extension DependencyResolver where Territory: MainStoreAware {

  func mainStore() -> Store<AppState> {
    return resolve { $0.mainStore() }
  }
  
}
