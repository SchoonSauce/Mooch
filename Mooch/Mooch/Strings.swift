//
//  Strings.swift
//  Mooch
//
//  Created by adam on 9/5/16.
//  Copyright © 2016 cse498. All rights reserved.
//

//Enumeration for string literals used in the app
enum Strings {
    //case InvalidCategoryId = "Bad Category Id"
    
    enum Alert: String {
        case defaultSingleActionTitle = "Okay"
        case funGetMoochingSingleActionTitle = "Get Mooching"
        case singleActionTryAgainTitle = "Try again"
    }
    
    enum SharedErrors: String {
        case invalidCategory = "Invalid Category"
    }
    
    enum EditListing: String {
        case cancelButtonTitle = "Cancel"
        
        case defaultCreatingTitle = "Create Listing"
        case defaultEditingTitle = "Edit Listing"
        
        case fieldTypePhotoTextDescription = "Photo"
        case fieldTypeTitleTextDescription = "Title"
        case fieldTypeDescriptionTextDescription = "Description"
        case fieldTypePriceTextDescription = "Price"
        case fieldTypeQuantityTextDescription = "Quantity"
        case fieldTypeCategoryTextDescription = "Category"
        
        case invalidCreationErrorAlertTitle = "Problem creating listing"
        case invalidCreationErrorAlertMessageFirstPart = "Please complete filling out the information for the "
        case invalidCreationErrorAlertMessageSecondPart = " field"
        
        case uploadingNewLoadingOverlay = "Uploading Listing"
        case uploadingNewErrorAlertTitle = "Problem Uploading Listing"
        case uploadingNewErrorAlertMessage = "Please try uploading the listing again"
        
        case unselectedCategory = "Unselected"
    }
    
    enum EditProfile: String {
        case cancelButtonTitle = "Cancel"
        
        case defaultCreatingTitle = "Create Profile"
        case defaultEditingTitle = "Edit Profile"
        
        case fieldTypePhotoTextDescription = "Photo"
        case fieldTypeNameTextDescription = "Name"
        case fieldTypeEmailTextDescription = "Email"
        case fieldTypePhoneTextDescription = "Phone"
        case fieldTypeAddressTextDescription = "Address"
        case fieldTypePassword1TextDescription = "Password"
        case fieldTypePassword2TextDescription = "Confirm Password"
        
        case invalidCreationErrorAlertTitle = "Problem creating listing"
        case invalidCreationErrorAlertMessageUnfilledInfoFirstPart = "Please complete filling out the information for the "
        case invalidCreationErrorAlertMessageUnfilledInfoSecondPart = " field"
        case invalidCreationErrorAlertMessageEmail = "Please enter a valid email address"
        case invalidCreationErrorAlertMessagePhone = "Please enter a valid phone number"
        case invalidCreationErrorAlertMessagePassword = "Please enter a valid password. Passwords must be 6-30 characters"
        case invalidCreationErrorAlertMessagePasswordMatch = "Please check that the passwords match"
        
        case uploadingNewLoadingOverlay = "Uploading Profile"
        case uploadingNewErrorAlertTitle = "Problem Uploading Profile"
        case uploadingNewErrorAlertMessage = "Please try uploading the profile again"
        
        case unselectedCategory = "Unselected"
    }
    
    enum InitialLoading: String {
        case couldNotDownloadInitialDataAlertTitle = "Problem Connecting to Mooch"
        case couldNotDownloadInitialDataAlertMessage = "We were unable to download the data needed to launch"
    }
    
    enum Login: String {
        case accountCreatedAlertTitle = "Account Created"
        case accountCreatedAlertMessageFirstPart = "Welcome to Mooch, "
        case accountCreatedAlertMessageSecondPart = "!"
        
        case loginOverlay = "Uploading Listing"
        case loginErrorAlertTitle = "Problem Uploading Listing"
        case loginErrorAlertMessage = "Please try uploading the listing again"
    }
    
    enum LoginTextField: String {
        case emailPlaceholder = "Email"
        case passwordPlaceholder = "Password"
    }
    
    enum ListingCategoryPicker: String {
        case title = "Categories"
    }
    
    enum ListingDetails: String {
        case title = "Listing Details"
        
        case fieldTypeAddAnotherListingActionString = "Add New Listing"
        case fieldTypeContactSellerActionString = "Claim"
        case fieldTypeDeleteListingActionString = "Delete Listing"
        case fieldTypeEditListingActionString = "Edit Listing"
        case fieldTypeViewSellerProfileActionString = "View Seller Profile"
        
        case listingCellPriceLabelFirstPart = "Price: "
        case listingCellQuantityLabelFirstPart = "Quantity: "
    }
    
    enum Listings: String {
        
        case title = "Listings"
        
        case buttonTitleLogin = "Login"
        case buttonTitleProfile = "Profile"
        
        case listingCreatedAlertTitle = "Listing Created"
        case listingCreatedAlertMessageFirstPart = "Your listing \""
        case listingCreatedAlertMessageSecondPart = "\" is now visible to all users in your community!"
        
        case loadingListingsOverlay = "Loading Listings"
        case loadingListingsErrorAlertTitle = "Problem Loading Listings"
        case loadingListingsErrorAlertMessage = "Please try pulling to refresh to reload the listings"
    }
    
    enum MoochAPI: String {
        case listingImageFilename = "listing_image.jpeg"
        case userImageFilename = "user_image.jpeg"
    }
    
    enum MoochAPIRouter: String {
        case baseURL = "https://mooch-rails-api.appspot.com/api/v1"
    }
    
    enum Profile: String {
        case buttonTitleBack = "Back"
        case buttonTitleEdit = "Edit"
        
        case title = "Profile"
    }
}


//
// How to markdown a complex object:
//

// MARK: Public variables

// MARK: Private variables

// MARK: Actions

// MARK: Public methods

// MARK: Private methods
