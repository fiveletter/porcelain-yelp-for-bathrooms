# Yelp For Bathrooms: May your poop be ever in your favor
This is an application made for iOS platform. 

# DEVELOPMENT LIBRARIES AND TOOLS

* Swift 	    - Framework
* CocoaPods		- Dependency Manager
* Synx          - File manager
* Balsamiq		- Mockup Program

## Purpose and Installation Instructions
### CocoaPods
This tool is used to download and manage dependencies used within the application. It uses a PodFile that can be modified to add more dependencies if needed. Thesee dependencies and CocoaPod related files are version controlled to get rid of the need of having to download the dependencies yourself on each computer.
#### First time installation Instructions:
	$ sudo gem install cocoapods
#### Use Instructions:
	$ pod install
Run in your project directory after modifying Podfile to include dependencies that are wanted.
### First time Synx
This tool is used to match the project folder to the xcode groups represented in the project nagivator. By default the file structure shown in the project explorer in Xcode does not modify the actual file structure stored in your drive. Use this whenever adding/modifying files in the project BEFORE merging into GIT. 
URL: https://github.com/venmo/synx
#### Installation Instructions:
    $ gem install synx
If you run into permission error run as superuser (sudo)
#### Use Instructions:
    $ synx ../<project name>.xcodeproj
Run synx on the project.xcodeproj file to reformat the file structure to the project nagivator structure.
### Balsamiq
This tool is used to download and manage dependencies used within the application. It uses a PodFile that can be modified to add more dependencies if needed. Thesee dependencies and CocoaPod related files are version controlled to get rid of the need of having to download the dependencies yourself on each computer.


# DEVELOPMENT PROGRESS
- empty

# Requirements for Yelp for Bathrooms (Name to be determined)

## User Credentials
1. Users can navigate through the app regardless of login credentials
2. Users can not post any type of rating for a bathroom while not logged in
3. Users will have the option to login from a SETTINGS page (USer profile button), the settings page link should be available all the time.
4. Users will have to sign in using their Yelp credentials.
5. Users will be able to rate bathrooms when they are signed in.
6. Users will be able to create new bathroom locations when they are signed in.

## Creating new bathroom entries
1. Users will be able to create new bathroom locations.
2. Users can only create new bathrooms if they allow access to their GPS data.
3. Bathroom names shall be decided by the user per the following steps:
	- User clicks on NAME field
	- App brings them back to map and highlights businesses and landmarks associated with bathroom
	- User selects associated business or bathroom
	- If none the user wishes, user clicks OTHER and types in a name

## Searching bathrooms
1. Users shall be able to search an area for a bathroom
2. Users may provide an address for which to view bathrooms in the surrounding area
3. Users may view list of bathrooms around them. 
4. Users may view markers of bathrooms around them on a map. 
5. Users may filter searches for bathrooms based on flags. 

## Modifying Bathrooms
1. Users shall be able to flag a bathroom as non existing.
2. Users shall be able to flag a bathroom as hard to find.
3. Users shall be able to flag a bathroom as paid.
4. Users shall be able to flag a bathroom as public. 
5. Users shall be able to rate a bathroom with a star rating
6. Users shall be able to comment on a bathroom if they provide a star rating for it. 

## Viewing Bathrooms
1. Users shall be able to see full details about a bathroom in one screen. 
2. Users shall be able to see the location of a bathroom.
3. Users shall be able to see the rating of a bathroom.
4. Users shall be able to see the flags of a bathroom. 

## Non-user Requirements
1. A bathroom listing with a ratio of non existing flags to reviews  > 2 shall be marked as non-existent.
2. A bathroom listing with a ratio of hard to find flags to reviews > 1 shall be marked as hard-to-find.
3. A bathroom listing with a ratio of paid flags to reviews > .5 shall be marked as paid.
4. A bathroom is by default flagged as public. 
