//
//  HTTPNetwork.swift
//  HTTPNetworkAPI
//
//  Created by Maor Shamsian on 02/05/2020.
//  Copyright © 2020 Maor Shamsian. All rights reserved.
//

import Foundation

public class HTTPNetwork: NSObject {
    
    // MARK: - Public Properties
    
    public let configuration: HTTPNetworkConfiguration
    public typealias OnSuccessHandler = (String?) -> Void
    public typealias OnSuccessCodableHandler<T: Codable> = (T?) -> Void
    public typealias OnFailureHandler = (Error) -> Void
    
    // MARK: - Internal Properties
    
    internal typealias URLSessionTaskIdentifier = Int
    internal var tasks = [URLSessionTaskIdentifier: HTTPRequestTask]()
    
    // MARK: - Private Properties
    
    private let queuesProvider: HTTPNetworkQueuesProvider
    private typealias URLSessionTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    private lazy var urlSession: URLSession = {
        return  URLSession(configuration: .default,
                           delegate: self,
                           delegateQueue: queuesProvider.delegateQueue)
    }()
    
    // MARK: - Init
    
    public init(configuration: HTTPNetworkConfiguration? = nil) {
        self.configuration = configuration ?? HTTPNetworkConfiguration()
        self.queuesProvider = HTTPNetworkQueuesProvider()
    }
    
    // MARK: - Public API
    
    /// This is the begining for creating a new request
    /// The methods returns a RequestBuilder to begin building the request.
    public func makeRequest() -> HTTPRequestBuilder {
        return HTTPRequestBuilder()
    }
    
    /// Execute request and receive String response
    /// - Parameters:
    ///   - request: The request to execute
    ///   - onSuccess: Completion handler for success case with response String
    ///   - onFailure: Completion handler for error case with error
    public func execute(request: HTTPRequestProtocol,
                        onSuccess: @escaping OnSuccessHandler,
                        onFailure: @escaping OnFailureHandler) {
        let task = createTask(from: request,
                              completionHandler: onResponseHandler(request: request,
                                                                   onSuccess: onSuccess,
                                                                   onFailure: onFailure))
        addAndExecute(task: task)
    }
    
    /// Execute request and receive Codable response
    /// You should specify the type of the codable in the completion handler
    /// - Parameters:
    ///   - request: The request to execute
    ///   - onSuccess: Completion handler for success case with response Codable
    ///   - onFailure: Completion handler for error case with error
    public func execute<T: Codable>(request: HTTPRequestProtocol,
                                    onSuccess: @escaping OnSuccessCodableHandler<T>,
                                    onFailure: @escaping OnFailureHandler) {
        let task = createTask(from: request,
                              completionHandler: onResponseHandler(request: request,
                                                                   onSuccess: onSuccess,
                                                                   onFailure: onFailure))
        addAndExecute(task: task)
    }
    
    // MARK: - Private API
    
    /// This method creates HTTPRequestTask from HTTPRequestProtocol and completionHandler
    /// The completionHandler is necessary in order to instansiate URLSessionDataTask
    /// - Parameters:
    ///   - request: The request to create the task from
    ///   - completionHandler: The completion handler for the task
    private func createTask(from request: HTTPRequestProtocol,
                            completionHandler: @escaping URLSessionTaskCompletionHandler) -> HTTPRequestTask {
        let urlRequest = URLRequest(request: request)
        
        let urlSessionTask = urlSession.dataTask(with: urlRequest,
                                                 completionHandler: completionHandler)
        
        return HTTPRequestTask(request: request, urlSessionTask: urlSessionTask)
    }
    
    /// This method Responsible for handling the Response of a task
    /// that was executed with a codable completion handler
    /// When the task complete successfully, It will decode the response to the corresponding
    /// specified type and will passed by `OnSuccess` Completion handler.
    /// Note that if the response was failed to be decoded, nil will be passed on handler.
    /// If the task failed, an error handler will be called.
    /// - Parameters:
    ///   - request: The request to handle
    ///   - onSuccess: Completion handler for success case with the optional decoded model
    ///   - onFailure: Completion handler for error case
    private func onResponseHandler<T: Codable>(request: HTTPRequestProtocol,
                                               onSuccess: @escaping OnSuccessCodableHandler<T>,
                                               onFailure: @escaping OnFailureHandler) -> URLSessionTaskCompletionHandler {
        return { (data, response, error) in
    
            self.onResponseHandler(request: request,
                                   data: data,
                                   response: response,
                                   error: error,
                                   onSuccess: { onSuccess(JSONDecoder().decode(data: $0)) },
                                   onFailure: onFailure)
            
        }
    }
    
    /// This method Responsible for handling the Response of a task
    /// that was executed with a String completion handler
    /// When the task complete successfully, It will try to create a String with UTF8 encoding
    /// from the response and will passed by `OnSuccess` Completion handler.
    /// Note that if the response was failed to be encoded, nil will be passed on handler.
    /// If the task failed, an error handler will be called.
    /// - Parameters:
    ///   - request: The request to handle
    ///   - onSuccess: Completion handler for success case with the optional decoded model
    ///   - onFailure: Completion handler for error case
    private func onResponseHandler(request: HTTPRequestProtocol,
                                   onSuccess: @escaping OnSuccessHandler,
                                   onFailure: @escaping OnFailureHandler) -> URLSessionTaskCompletionHandler {
        return { (data, response, error) in
            
            self.onResponseHandler(request: request,
                                   data: data,
                                   response: response,
                                   error: error,
                                   onSuccess: { onSuccess(String(data: $0)) },
                                   onFailure: onFailure)
            
        }
    }
    
    /// This method Responsible for handling the low level details of the Response.
    /// 1. Mapping Request errors and call to another funciton thar responsible to handle them
    /// 2. Checking the status code of the response and call the appropriate handler
    /// 3. Remove the task from the current tasks
    ///
    /// If the request completes successfully, the data parameter of the completion handler block contains the resource data, and the error parameter is nil.
    /// If the request fails, the data parameter is nil and the error parameter contain information about the failure.
    /// If a response from the server is received, regardless of whether the request completes successfully or fails, the response parameter contains that information.
    /// - Parameters:
    ///   - request: The request of the current task
    ///   - data: The data of the response (If exist)
    ///   - response: The response of the current task (If exist)
    ///   - error: The error of the task (If exist)
    ///   - onSuccess: A success completion handler
    ///   - onFailure: A Failure ompletion handler
    private func onResponseHandler(request: HTTPRequestProtocol,
                                   data: Data?,
                                   response: URLResponse?,
                                   error: Error?,
                                   onSuccess: @escaping (Data?) -> Void,
                                   onFailure: @escaping OnFailureHandler) {
        
        defer { removeTask(findBy: request) }

        if let error = error {
            self.onResponse(error: error,
                            request: request,
                            response: response,
                            completion: onFailure)
        } else {
            
            let httpResponse = response as! HTTPURLResponse
            
            if (200 ... 299) ~= httpResponse.statusCode {
                onSuccess(data)
            } else {
                onFailure(HTTPNetworkError.responseError(statusCode: httpResponse.statusCode))
            }
            
        }
    }
    
    /// This method should handle the error of the task
    /// We need to verify whether the error occurred because of the exceeded amount of redirects
    /// - Parameters:
    ///   - error: The Error of the task
    ///   - request: The task request
    ///   - response: The task response
    ///   - completion: Completion handler with error
    private func onResponse(error: Error,
                            request: HTTPRequestProtocol,
                            response: URLResponse?,
                            completion: @escaping OnFailureHandler) {
        
        guard let task = getReqestTask(from: request.id) else {
            completion(error)
            return
        }
            
        if let numberOfRedirections = numberOfRedirections(for: task.urlSessionTask),
            !isValid(numberOfRedirections: numberOfRedirections) {
            completion(HTTPNetworkError.exceedNumOfRedirections(redirections: task.redirectCount))
        } else {
            completion(error)
        }
    }
    
    /// This methods adds a task to the tasks dictionary and execute it
    /// - Parameter task: The task to operate on
    private func addAndExecute(task: HTTPRequestTask) {
        queuesProvider.rootQueue.async {
            self.add(task: task)
            self.fire(task: task)
        }
    }
    
    /// Adding a task to the tasks dictionary with the unique id as key
    /// - Parameter task: The task to add
    private func add(task: HTTPRequestTask) {
        tasks[task.id] = task
    }
    
    /// Fetching the task from tasks dictionary by the request id
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    /// - Parameter requestID: The HTTPRequest id
    private func getReqestTask(from requestID: String) -> HTTPRequestTask? {
        return tasks.values.first(where: { $0.request.id == requestID })
    }
    
    /// Removing task from the tasks dictionary by URLSessionTask
    /// - Parameter task: The task to remove
    private func remove(task: URLSessionTask) {
        tasks[task.taskIdentifier] = nil
    }
    
    /// Removing a task from the tasks dictionary by HTTPRequestProtocol
    /// - Parameter request: The request where the task is operated on
    private func removeTask(findBy request: HTTPRequestProtocol) {
        guard let task = getReqestTask(from: request.id) else {
            return
        }
        remove(task: task.urlSessionTask)
    }
    
    /// Fire the url Session task
    /// - Parameter task: the task to fire
    private func fire(task: HTTPRequestTask) {
        task.urlSessionTask.resume()
    }
    
    /// Cancel a task
    /// - Parameter task: The task to cancel
    private func cancel(task: URLSessionTask) {
        task.cancel()
    }
    
    /// This function returns the number of redirects that the current task did
    /// Note that if the current task is not exist, it will return nil
    /// - Parameter task: The task to get the count of
    private func numberOfRedirections(for task: URLSessionTask) -> Int? {
        return tasks[task.taskIdentifier]?.redirectCount
    }
    
    /// This function Increment the number of the redirects
    /// - Parameter task: The task to increment the redirect count
    private func incrementNumberOfRedirections(for task: URLSessionTask) {
        tasks[task.taskIdentifier]?.redirectCount += 1
    }
    
    /// This function checks if the number of the redirects is below the maximum defined
    /// - Parameter numberOfRedirections: The number of redirects to check
    private func isValid(numberOfRedirections: Int) -> Bool {
        guard let maxRedirections = configuration.maxRedirections else {
            return true
        }
        return numberOfRedirections < maxRedirections
    }
}

extension HTTPNetwork: URLSessionTaskDelegate {
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        
        self.incrementNumberOfRedirections(for: task)
        
        guard let redirectCount = numberOfRedirections(for: task),
            isValid(numberOfRedirections: redirectCount) else {
                cancel(task: task)
                completionHandler(nil)
                return
        }
        
        completionHandler(request)
    }
}

