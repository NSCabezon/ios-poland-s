# DemoAuthenticator

This package is used to authenticate user inside demo apps


## Usage

Invoke `LoginViewControllerFactory.create(successViewControllerFactory:)` method and pass destination viewController's factory.

Example:
```
let authController = LoginViewControllerFactory().create(
    successViewControllerFactory: DemoAppFactory()
)
```

`successViewControllerFactory` argument should conform to `AuthSuccessViewControllerProducing` protocol:

```
public protocol AuthSuccessViewControllerProducing {
    func create(authToken: AuthToken) -> UIViewController
}
```
