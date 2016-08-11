import Foundation

// --------------------------------------------------------------------------------
// MARK: - Protocols extending EnvAware get access to dependencies
// --------------------------------------------------------------------------------

/// Give all `MainStoreAware` types some shortcuts for `dispatch`.
public extension EnvAware {

  var now: Date {
    return env.now()
  }

}

/// Give all `MainStoreAware` types some shortcuts for `dispatch`.
public extension MainStoreAware {

  func dispatch(_ action: Action) {
    self.env.mainStore().dispatch(action)
  }

}

/// Give all `MainStoreAware` types that are StoreSubscriber
/// some shortcuts for `subscribe` and `unsubscribe`.
public extension MainStoreAware where
  Self: StoreSubscriber,
  Self.StoreSubscriberStateType == AppState {

  func subscribeToStore() {
    self.env.mainStore().subscribe(self)
  }

  func unsubscribeFromStore() {
    self.env.mainStore().unsubscribe(self)
  }
  
}

// Give all `MainStoreAware` types that are StoreSubscriber and ActionCreatorAware
// some shortcuts for `dispatchAsync`. ... and so on
public extension MainStoreAware where
  Self: StoreSubscriber,
  Self: ActionCreatorAware,
  Self.StoreSubscriberStateType == AppState {

  func dispatchAsync(_ actionFrom: (ActionCreatorType) -> (Action)) {
    let action = actionFrom(env.actionCreator())
    self.env.mainStore().dispatch(action)
  }

}
