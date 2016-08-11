import Foundation
import UIKit

// --------------------------------------------------------------------------------
// MARK: Allowing Injection EnvAware
// --------------------------------------------------------------------------------

/// Extension for EnvAware to provide easy access to
///     class XYZ {
///       env: Env<XYZ> = Env(applicationContext: RealContext())
///     }
///
public extension EnvAware {

  /// returns a `Env` type with provided `ApplicationContext`.
  /// - parameter applicationContext: ApplicationContext
  /// - returns: Env<Self>
  static func env(withContext applicationContext: ApplicationContextProvider) -> Env<Self> {
    return Env(applicationContext: applicationContext)
  }

}

// --------------------------------------------------------------------------------
// MARK: - MockContext
// --------------------------------------------------------------------------------

struct WebServiceMock: WebServiceType {}

// --------------------------------------------------------------------------------
// MARK: - mockin helpers
// --------------------------------------------------------------------------------

/// Takes an EnvAware input and returns it with a MockContext.
/// - parameter envAware: EA
/// - parameter ac: default is MockContext()
/// - returns: EA
func withMockedDependencies<EA>(_ envAware: EA,
                            from ac: ApplicationContextProvider = MockContext()) -> EA
  where EA: EnvAware {
    var ea = envAware
    ea.env.swap(applicationContext: ac)
    return ea
}


func controllerForId<C>(_ storyboardId: String,
                     with ac: ApplicationContextProvider = MockContext()) -> C
  where C: UIViewController, C: EnvAware {
    guard let c = UIStoryboard().instantiateViewController(withIdentifier: storyboardId) as? C else {
      fatalError("\(storyboardId) not matching with return Type \(C.self)")
    }
    return withMockedDependencies(c)
}


// ----------------------------------------------------------------------------------------------------
// MARK: - Mock 1
// ----------------------------------------------------------------------------------------------------

struct MockContext: ApplicationContextProvider {

  let testStore = Store<AppState>()

  public func now() -> Date {
    return Date.distantPast
  }

  func webService() -> WebServiceType.Type {
    return WebServiceMock.self
  }

  func mainStore() -> Store<AppState> {
    return testStore
  }

  func actionCreator() -> ActionCreatorType {
    return withMockedDependencies(ActionCreator())
  }
  
}

print("### Test with default Mock")

let vc = withMockedDependencies(ViewController())

vc.viewWillAppear(true)

vc.viewWillDisappear(true)

// ----------------------------------------------------------------------------------------------------
// MARK: - Mock 2
// ----------------------------------------------------------------------------------------------------

struct MockContextTomorrow: ApplicationContextProvider {

  let testStore = Store<AppState>()

  public func now() -> Date {
    return Date.distantFuture
  }

  func webService() -> WebServiceType.Type {
    return WebServiceMock.self
  }

  func mainStore() -> Store<AppState> {
    return testStore
  }

  func actionCreator() -> ActionCreatorType {
    return withMockedDependencies(ActionCreator())
  }
  
}

print("### Test with second Mock")

let vc2 = withMockedDependencies(ViewController(), from: MockContextTomorrow())

vc2.viewWillAppear(true)

vc2.viewWillDisappear(true)
