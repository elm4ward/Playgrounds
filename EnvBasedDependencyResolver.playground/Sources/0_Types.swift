// ----------------------------------------------------------------------------------------------------
// MARK: - ReSwift, And So Forth
//
// This is just to illustrate some real life types from Libraries or whatever
// ----------------------------------------------------------------------------------------------------

public protocol WebServiceType { }

public protocol State {}

public protocol ActionCreatorType {


}

public struct AppState: State { }

public protocol StoreType {

}

public struct Store<S: State>: StoreType {

  public init(){

  }

  public func subscribe(_ t: Any) {
    print("subscribe", t)
  }

  public func unsubscribe(_ t: Any) {
    print("unsubscribe", t)
  }

  public func dispatch(_ action: Action){
    print("dispatched", action)
  }
}

public struct Action {
  public let message: String
  public init(_ s: String){
    self.message = s
  }
}

public protocol StoreSubscriber {
  associatedtype StoreSubscriberStateType: State
}
