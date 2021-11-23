//
//  ProcessGroup.swift
//  PLCommons
//
//  Created by Marcos Álvarez Mesa on 11/11/21.
//

import DomainCommon
import Commons
import Models

public protocol ProcessGroupProtocol {
    associatedtype ProcessGroupInput
    associatedtype ProcessGroupOutput
    associatedtype ProcessGroupError: Error

    func execute(input: ProcessGroupInput, completion: @escaping (Result<ProcessGroupOutput, ProcessGroupError>) -> Void)
    func execute(completion: @escaping (Result<ProcessGroupOutput, ProcessGroupError>) -> Void)
}

open class ProcessGroup <ProcessGroupInput, ProcessGroupOutput, ProcessGroupError: Error>: ProcessGroupProtocol {

    public let dependenciesEngine: DependenciesResolver & DependenciesInjector

    public init(dependenciesEngine: DependenciesResolver & DependenciesInjector) {
        self.dependenciesEngine = dependenciesEngine
        self.registerDependencies()
    }

    open func registerDependencies() { }
    open func execute(input: ProcessGroupInput, completion: @escaping (Result<ProcessGroupOutput, ProcessGroupError>) -> Void) { }
    open func execute(completion: @escaping (Result<ProcessGroupOutput, ProcessGroupError>) -> Void) { }
}
