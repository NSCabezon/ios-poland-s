//
//  PLPasswordEncryptionUseCaseTests.swift
//  PLLogin_ExampleTests
//

import XCTest
import CoreFoundationLib
import PLCommons
@testable import PLLogin

class PLPasswordEncryptionUseCaseTests: XCTestCase {

    private let dependencies = DependenciesDefault()

    let password = "Santandertest123#"
    let publicEncryptionKey = EncryptionKeyEntity(modulus: "c67eefe5c729497c59d362a5d873cf6d2e61f6d2cbd48641fd6d698c7bd92d2f3a2a4818f63df505d3b5a857ae30f323da62c29f231c31bb4e3943fa09934016387aa4f819c4d3f9691677d54d73e701dc6ee9653aa391ca4085a1251baa281572517e4f3b157964a8f8819186a27b46451f4eace20ef5cf6ba5151ae9d42e9c11d8d519804bb169917f0b0aba89c2b8c1dc0f0804b62bf1acd4803bba31883ccd03ec74b059fe81bdc32be97b58017475aea47fea57785ec64c312a24b1c43cb835a1e3177fb4b4aa45f47693412496ed17660a24b6b815ccd382ff7259b5ae9da1f4c04f04d3389e569501510c7db4aad7259f3d6362f8fbd0d2d5bdf11885", exponent: "8c21")

    override func setUpWithError() throws {
        try super.setUpWithError()
        self.setDependencies()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    /// Password is different each time, we only test that is generated and it is not empty
    func testEncryptPasswordWithPublicKey() throws {
        do {
            let useCaseResponse = try passwordEncryptionUseCase(PLPasswordEncryptionUseCaseInput(plainPassword: password, encryptionKey: publicEncryptionKey))
            let output = outputFrom(useCaseResponse)
            XCTAssertNotNil(output?.encryptedPassword, "Encrypted password generated")
        } catch {
            XCTFail("PLPasswordEncryptionUseCase: throw")
        }
    }
}

private extension PLPasswordEncryptionUseCaseTests {
    func setDependencies() {

    }

    // MARK: Handle useCase response
    func passwordEncryptionUseCase(_ input: PLPasswordEncryptionUseCaseInput) throws -> UseCaseResponse<PLPasswordEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>> {
            let useCase = PLPasswordEncryptionUseCase(dependenciesResolver: self.dependencies)
            let response = try useCase.executeUseCase(requestValues: input)
            return response
    }

   func outputFrom(_ response: UseCaseResponse<PLPasswordEncryptionUseCaseOutput, PLUseCaseErrorOutput<LoginErrorType>>) -> PLPasswordEncryptionUseCaseOutput? {
            let output = try? response.getOkResult()
            return output
    }
}
