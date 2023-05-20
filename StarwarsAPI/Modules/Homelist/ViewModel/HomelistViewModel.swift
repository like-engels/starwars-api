//
//  HomelistViewModel.swift
//  CatsAPITest
//
//  Created by Higashikata Maverick on 17/5/23.
//

import Foundation
import Combine

protocol HomelistViewModelRepresentable {
    
    var pageIndicatorSubject: CurrentValueSubject<String, Error> { get set }
    var thereIsPreviousPageSubject: CurrentValueSubject<Bool, Error> { get set }
    var thereIsNextPageSubject: CurrentValueSubject<Bool, Error> { get set }
    var currentResponseInfo: StarwarsResponse? { get set }
    
    func loadData(dataHandler: @escaping ([CharacterModel]?) -> Void)
    
    func previousPage(dataHandler: @escaping ([CharacterModel]?) -> Void)
    
    func nextPage(dataHandler: @escaping ([CharacterModel]?) -> Void)
    
}

class HomelistViewModel: HomelistViewModelRepresentable {
    
    var pageIndicatorSubject: CurrentValueSubject<String, Error> = CurrentValueSubject("Page: 1")
    var thereIsPreviousPageSubject: CurrentValueSubject<Bool, Error> = CurrentValueSubject(false)
    var thereIsNextPageSubject: CurrentValueSubject<Bool, Error> = CurrentValueSubject(true)
    
    var currentResponseInfo: StarwarsResponse?
    
    let httpClient = HttpClient<StarwarsResponse>()
    
    var currentPageIndex = 1
    
    
    
    func loadData(dataHandler: @escaping ([CharacterModel]?) -> Void) {
        
        httpClient.getData(from: "https://swapi.dev/api/people") { result in
                
            if case .failure(let error) = result { print(error.localizedDescription) }
                
            if case .success(let data) = result {
                
                self.currentResponseInfo = data
                
                if case .none = data.previous {
                    self.thereIsPreviousPageSubject.send(false)
                } else {
                    self.thereIsPreviousPageSubject.send(true)
                }
                
                if case .none = data.next {
                    self.thereIsNextPageSubject.send(false)
                } else {
                    self.thereIsNextPageSubject.send(true)
                }
                
                dataHandler(data.results)
            }
        }
    }
    
    func previousPage(dataHandler: @escaping ([CharacterModel]?) -> Void) {
        
        httpClient.getData(from: (self.currentResponseInfo?.previous)!) { result in
            
            if case .failure(let error) = result { print(error.localizedDescription) }
                
            if case .success(let data) = result {
                
                self.currentResponseInfo = data
                
                if case .none = data.previous {
                    self.thereIsPreviousPageSubject.send(false)
                } else {
                    self.thereIsPreviousPageSubject.send(true)
                }
                
                if case .none = data.next {
                    self.thereIsNextPageSubject.send(false)
                } else {
                    self.thereIsNextPageSubject.send(true)
                }
                
                self.currentPageIndex -= 1
                
                self.pageIndicatorSubject.send("Page: \(self.currentPageIndex)")
                
                dataHandler(data.results)
            }
            
        }
        
    }
    
    func nextPage(dataHandler: @escaping ([CharacterModel]?) -> Void) {
        
        httpClient.getData(from: (self.currentResponseInfo?.next)!) { result in
            
            if case .failure(let error) = result { print(error.localizedDescription) }
                
            if case .success(let data) = result {
                
                self.currentResponseInfo = data
                
                if case .none = data.previous {
                    self.thereIsPreviousPageSubject.send(false)
                } else {
                    self.thereIsPreviousPageSubject.send(true)
                }
                
                if case .none = data.next {
                    self.thereIsNextPageSubject.send(false)
                } else {
                    self.thereIsNextPageSubject.send(true)
                }
                
                self.currentPageIndex += 1
                
                self.pageIndicatorSubject.send("Page: \(self.currentPageIndex)")
                
                dataHandler(data.results)
            }
            
        }
        
    }
    
}
