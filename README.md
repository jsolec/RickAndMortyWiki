# RickAndMortyWiki

## Introduction
This project is using Apollo framework for being able to generate GraphQL requests (https://www.apollographql.com). I went for this solution because is the most maintained framework as mentioned in here (A strongly-typed, caching GraphQL client for iOS, written in Swift)

Main issue about Apollo, as per their definition is
> A strongly-typed with Codegen, caching GraphQL client for iOS, written in Swift

This fact causes that code isn't good to be tested on Network side, on the future I would go for a custom solution that allows me this flexibility. That's the main reason there are some tests missing

The models with `Decodable` are because if I want to move back to URLSession approach on the future, thats why I kept `URLSession` related classes

###### Init project
- Go to base folder
- execute `pod install`

###### Next steps
- Move baseURL to Cocoapod keys, is not strictly necessary but security wise would be interesting
- Migrate to some client that allows test easier
- Refactor test code 
- Create UI test
- Create more Unit test
