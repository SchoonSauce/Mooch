//
//  MoochRouter.swift
//  Mooch
//
//  Created by adam on 9/7/16.
//  Copyright © 2016 cse498. All rights reserved.
//

import Alamofire

//Class that maps an API route to a URLRequest. Should only be used through MoochAPI or in tests
enum MoochAPIRouter: URLRequestConvertible {
    
    typealias RoutingInformation = (path: String, method: Alamofire.HTTPMethod, parameters: [String: Any]?, requiresAuthorization: Bool)
    
    static let baseURLString = Strings.MoochAPIRouter.baseURL.rawValue
    
    static fileprivate var email: String?
    static fileprivate var authorizationToken: String?
    
    static fileprivate var isAuthorizedOnce = false
    
    static fileprivate let NoParametersDictionary = [String : AnyObject]()
    
    static private let AuthorizationHeaderKey = "Authorization"
    static private let DeviceTypeValue = "iOS"
    
    case deleteListing(ownerId: Int, listingId: Int)
    
    case getCommunities
    case getExchangeAccept(listingOwnerId: Int, listingId: Int, exchangeId: Int)
    case getListing(id: Int)
    case getListingCategories
    case getListings(forCommunityWithId: Int)
    case getUser(withId: Int)
    case getUserOnce(withId: Int, email: String, authorizationToken: String)
    case getVisit(listingId: Int)
    
    case postExchange(listingOwnerId: Int, listingId: Int)
    case postListing(userId: Int, title: String, description: String?, price: Float, isFree: Bool, quantity: Int, categoryId: Int)
    case postLogin(withEmail: String, andPassword: String)
    case postUser(communityId: Int, name: String, email: String, phone: String, password: String, address: String?, deviceToken: String?)
    
    case putListing(listingId: Int, userId: Int, title: String, description: String?, price: Float, isFree: Bool, quantity: Int, categoryId: Int)
    case putUser(userId: Int, communityId: Int?, name: String?, email: String?, phone: String?, password: String?, address: String?, deviceToken: String?)
    
    //The keys to pass in as parameters mapped to strings
    enum ParameterMapping {
        enum PostExchange: String {
            case completed = "completed"
        }
        
        enum PostLogin: String {
            case email = "email"
            case password = "password"
        }
        
        enum PostListing: String {
            case photo = "image"
            case title = "title"
            case description = "detail"
            case price = "price"
            case isFree = "free"
            case quantity = "quantity"
            case categoryId = "category_id"
        }
        
        enum PostUser: String {
            //Required
            case communityId = "community_id"
            case photo = "image"
            case name = "name"
            case email = "email"
            case phone = "phone"
            case password = "password"
            
            case deviceType = "device_type"
            case deviceToken = "destination_token"
            
            //Optional
            case address = "address"
        }
    }
    
    //Returns the URL request for the route
    func asURLRequest() throws -> URLRequest {
        let routingInformation = getRoutingInformation()
        
        let url = try MoochAPIRouter.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(routingInformation.path))
        urlRequest.httpMethod = routingInformation.method.rawValue
        
        if routingInformation.requiresAuthorization {
            if let email = MoochAPIRouter.email, let authorizationToken = MoochAPIRouter.authorizationToken {
                let authorizationHeaderValue = self.authorizationHeaderValue(email: email, authorizationToken: authorizationToken)
                urlRequest.setValue(authorizationHeaderValue, forHTTPHeaderField: MoochAPIRouter.AuthorizationHeaderKey)
            } else {
                print("ERROR: API route that requires authorization has not been given the authorization credentials")
            }
        }
        
        //Removes the authorization credentials that were needed for just one call
        MoochAPIRouter.deauthorizeIfAuthorizedOnce()
        
        return try JSONEncoding.default.encode(urlRequest, with: routingInformation.parameters)
    }
    
    //Returns the routing information needed to create a url request for each route
    func getRoutingInformation() -> RoutingInformation {
        switch self {
        case .deleteListing(let userId, let listingId):
            return ("/users/\(userId)/listings/\(listingId)", .delete, nil, true)
            
        case .getCommunities:
            return ("/communities", .get, nil, false)
            
        case .getExchangeAccept(let listingOwnerId, let listingId, let exchangeId):
            return ("/users/\(listingOwnerId)/listings/\(listingId)/exchanges/\(exchangeId)/accept", .get, nil, true)
            
        case .getListing(let id):
            return ("/listings/\(id)", .get, nil, false)
            
        case .getListingCategories:
            return ("/categories", .get, nil, false)
            
        case .getListings(let communityId):
            return ("/communities/\(communityId)/listings", .get, nil, false)
            
        case .getUser(let userId):
            return ("/users/\(userId)", .get, nil, false)
            
        case .getUserOnce(let userId, let email, let authorizationToken):
            //Same route as .getUser, but we need to temporarily authenticate for this API call
            MoochAPIRouter.authorizeOnce(email: email, authorizationToken: authorizationToken)
            let routingInformation = MoochAPIRouter.getUser(withId: userId).getRoutingInformation()
            return (routingInformation.path, routingInformation.method, routingInformation.parameters, true)
            
        case .getVisit(let listingId):
            return ("/listings/\(listingId)/visit", .get, nil, false)
            
        case .postExchange(let listingOwnerId, let listingId):
            let parameters = [ParameterMapping.PostExchange.completed.rawValue : false]
            return ("/users/\(listingOwnerId)/listings/\(listingId)/exchanges/", .post, parameters, true)
            
        case .postListing(let userId, let title, let description, let price, let isFree, let quantity, let categoryId):
            var parameters: [String : Any] = [ParameterMapping.PostListing.title.rawValue : title, ParameterMapping.PostListing.price.rawValue : price, ParameterMapping.PostListing.isFree.rawValue : isFree, ParameterMapping.PostListing.quantity.rawValue : quantity, ParameterMapping.PostListing.categoryId.rawValue : categoryId]
            if description != nil { parameters[ParameterMapping.PostListing.description.rawValue] = description! }
            return ("/users/\(userId)/listings", .post, parameters, true)
            
        case .postLogin(let email, let password):
            let parameters = [ParameterMapping.PostLogin.email.rawValue : email, ParameterMapping.PostLogin.password.rawValue : password]
            return ("/sessions", .post, parameters, false)
        
        case .postUser(let communityId, let name, let email, let phone, let password, let address, let deviceToken):
            typealias mapping = ParameterMapping.PostUser
            
            var parameters: [String : Any] = [mapping.communityId.rawValue : communityId, mapping.name.rawValue : name, mapping.email.rawValue : email, mapping.phone.rawValue : phone, mapping.password.rawValue : password, mapping.deviceToken.rawValue : deviceToken, mapping.deviceType.rawValue : MoochAPIRouter.DeviceTypeValue]
            
            if address != nil { parameters[mapping.address.rawValue] =  address! }
            
            if let deviceToken = deviceToken {
                parameters[mapping.deviceToken.rawValue] = deviceToken
                parameters[mapping.deviceType.rawValue] = MoochAPIRouter.DeviceTypeValue
            }
            
            return ("/users", .post, parameters, false)
            
        case .putListing(let listingId, let userId, let title, let description, let price, let isFree, let quantity, let categoryId):
            //Much of the same routing information is shared with the POST Listing route
            let postListingRoutingInformation = MoochAPIRouter.postListing(userId: userId, title: title, description: description, price: price, isFree: isFree, quantity: quantity, categoryId: categoryId).getRoutingInformation()
            return ("\(postListingRoutingInformation.path)/\(listingId)", .put, postListingRoutingInformation.parameters, true)
            
        case .putUser(let userId, let communityId, let name, let email, let phone, let password, let address, let deviceToken):
            typealias mapping = ParameterMapping.PostUser
            
            var parameters = [String : Any]()
            
            //Add the parameters if they exist
            if let communityId = communityId { parameters[mapping.communityId.rawValue] = communityId }
            if let name = name { parameters[mapping.name.rawValue] = name }
            if let email = email { parameters[mapping.email.rawValue] = email }
            if let phone = phone { parameters[mapping.phone.rawValue] = phone }
            if let password = password { parameters[mapping.password.rawValue] = password }
            if let address = address { parameters[mapping.address.rawValue] = address }
            
            if let deviceToken = deviceToken {
                parameters[mapping.deviceToken.rawValue] = deviceToken
                parameters[mapping.deviceType.rawValue] = MoochAPIRouter.DeviceTypeValue
            }
            
            return ("/users/\(userId)", .put, parameters, true)
        }
    }

    //Allows the router to perform authorized requests
    static func setAuthorizationCredentials(email: String, authorizationToken: String) {
        self.email = email
        self.authorizationToken = authorizationToken
    }
    
    //Clears the authorization credentials for when a user logs out
    static func clearAuthorizationCredentials() {
        email = nil
        authorizationToken = nil
    }
    
    static fileprivate func authorizeOnce(email: String, authorizationToken: String) {
        isAuthorizedOnce = true
        setAuthorizationCredentials(email: email, authorizationToken: authorizationToken)
    }
    
    static fileprivate func deauthorizeIfAuthorizedOnce() {
        guard isAuthorizedOnce else { return }
        isAuthorizedOnce = false
        clearAuthorizationCredentials()
    }
    
    func authorizationHeaders() -> [String : String]? {
        if let email = MoochAPIRouter.email, let authorizationToken = MoochAPIRouter.authorizationToken {
            let authorizationHeaderValue = self.authorizationHeaderValue(email: email, authorizationToken: authorizationToken)
            return [MoochAPIRouter.AuthorizationHeaderKey : authorizationHeaderValue]
        } else {
            return nil
        }
    }
    
    fileprivate func authorizationHeaderValue(email: String, authorizationToken: String) -> String {
        return "Token token=\"\(authorizationToken)\", email=\"\(email)\""
    }
}
