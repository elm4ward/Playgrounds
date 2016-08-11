import Foundation
import UIKit

struct WebService: WebServiceType {}

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

  /// returns a `Env` type with provided `ApplicationContext`.
  /// - parameter applicationContext: ApplicationContext
  /// - returns: Env<Self>
  static func env(withContext applicationContext: ApplicationContextProvider) -> Env<Self> {
    return Env(applicationContext: applicationContext)
  }
  
}


/// Give all `MainStoreAware` types some shortcuts for `dispatch`.
extension MainStoreAware {

  func dispatch(_ action: Action) {
    self.env.mainStore().dispatch(action)
  }

}

/// Give all `MainStoreAware` types that are StoreSubscriber
/// some shortcuts for `subscribe` and `unsubscribe`.
extension MainStoreAware where
  Self: StoreSubscriber,
  Self.StoreSubscriberStateType == AppState {

  func subscribeToStore() {
    self.env.mainStore().subscribe(self)
  }

  func unsubscribeFromStore() {
    self.env.mainStore().unsubscribe(self)
  }

}

/// Give all `MainStoreAware` types that are StoreSubscriber and ActionCreatorAware
/// some shortcuts for `dispatchAsync`.
//extension MainStoreAware where
//  Self: StoreSubscriber,
//  Self: ActionCreatorAware,
//  Self.StoreSubscriberStateType == AppState {
//
//  func dispatchAsync(_ actionFrom: (ActionCreator) -> Store<AppState>.AsyncActionCreator) {
//    let action = actionFrom(env.actionCreator())
//    self.env.mainStore().dispatch(action)
//  }
//  
//}

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

  public func actionCreator() -> ActionCreator {
    return ActionCreator()
  }

}

// --------------------------------------------------------------------------------
// MARK: - Usage
// --------------------------------------------------------------------------------

final class ViewController: UIViewController, MainStoreAware {

  var env = ViewController.defaultEnv

  override func viewWillAppear(_ animated: Bool) {

    
    dispatch(Action())

  }

}


