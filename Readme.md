# AniLibrary Sync

AniLibrary an open sourced and native anime library sync for MyAnimeList, Kitsu and AniList toolbar item written in Swift.

Requires latest SDK (10.12), XCode 8 or later. 
## Supporting this Project
The free version will allow two manual syncs per day. The planned paid version will allow unlimited syncs and allow the user to automatically sync the list periodically.

Licence keys from Hachidori, MAL Library or MAL Updater OS X will not work.

## How to Compile

Warning: This won't work if you don't have a Developer ID installed. If you don't have one, obtain one by joining the Apple Developer Program or turn off code signing.

1. Get the Source. Note that you need to retrieve all the submodules or it won't compile.

```
git clone https://github.com/Atelier-Shiori/AniLibrary-Sync.git
cd AniLibrary-Sync
git submodule update --init --recursive
```

2. Type 'xcodebuild' to build

# About Donation Key restrictions
These restrictions only apply on officially distributed versions of AniLibrary Sync. To create an unofficial version without restrictions, change the variable to turn off the license manager. There is no software updates if you build your own as this is an unofficial copy. Do not create issues for self-built copies as they won't be supported. Also, you must use a different Atarashii-API server as the one specified in the application is only for official copies.

## Dependencies
All the frameworks are included. Just build! Here are the frameworks that are used in this app:

* Alamofire
* OAuthSwift
* OAuthSwiftAlamofire

## License
Unless stated, Source code is licensed under New BSD License
