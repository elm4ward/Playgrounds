import Foundation
import UIKit

// --------------------------------------------------------------------------------
// MARK: - Usage
// --------------------------------------------------------------------------------

public final class ViewController: UIViewController, MainStoreAware, StoreSubscriber, ActionCreatorAware {

  // this is normally handled by ReSwift
  public typealias StoreSubscriberStateType = AppState

  // This is the env which has to be defined
  // this will provided access to dependencies
  // furthermore injection shortcuts can be defined
  public var env = ViewController.defaultEnv

  public override func viewWillAppear(_ animated: Bool) {

    // subscribe to MainStore
    subscribeToStore()

    // message
    let message = "Action \(now)"

    // any async action that could cause network or whatever
    dispatchAsync { creator in
       return Action("\(message) - handled by \(creator)")
    }
  }

  public override func viewWillDisappear(_ animated: Bool) {

    // unsubscribe from MainStore
    unsubscribeFromStore()
  }
  
}

