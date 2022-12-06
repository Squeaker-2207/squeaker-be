
# <img src="app/assets/images/squeakr-logo.jpg" style="width: 150px;"> 
## Squeakr-Be - Turing Capstone Project 

![ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white) ![ror](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white) ![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white) ![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white) ![GraphQL](https://img.shields.io/badge/-GraphQL-E10098?style=for-the-badge&logo=graphql&logoColor=white)

#### Contributors: [Gavin Carew](https://github.com/gjcarew) | [Jedeo Manirikumwenatwe](https://github.com/Jedeo) | [Noah van Ekdom](https://github.com/noahvanekdom) | [Colby Pearce](https://github.com/Crpearce) | [Anna Marie Sterling](https://github.com/AMSterling) | [Catalyst](https://github.com/Catalyst4Change) | [Ken Lenhart](https://github.com/Penitent0)

## Description

A rails backend API for Squeakr, a short-form messaging service built around healthy conversations and robust moderation.

Squeakr uses a service-oriented architecture with a React frontend. 

[Check out the the front-end repo](https://github.com/Squeaker-2207/squeaker-fe)

## <a name="contents"></a> Table of contents
- [Architecture](#architecture)
- [Database setup](#database-setup)
  - [Required API keys](#required-keys)
- [Endpoints](#endpoints)
  - [Get recipes from a country](#get-recipes)
  - [Get learning resources from a country](#get-resources)
  - [Register a new user](#register)
  - [User login](#login)
  - [User logout](#logout)
  - [Add a new favorite recipe](#new-favorite)
  - [Get a user's favorites](#favorites)
  - [Delete a user's favorites](#delete-favorite)

## <a name="architecture"></a>Architecture


## <a name="database-setup"></a>Database Setup

Live endpoints can be found by sending a `POST` request to `https://squeakr-be.fly.dev/graphql/`. 

Instructions to set up a local version of the Squeakr backend: 

Fork and clone the project, then install the required gems with `bundle`. A full list of gems that will be installed can be found in the [gemfile](gemfile). 

```sh
bundle install
```

Reset and seed the database: 

```sh
rake db:{drop,create,migrate,seed}
```
### <a name="required-keys"></a> Required keys

Squeakr uses Google's Perspective API to assist with content moderation. It also uses a custom Nyckel ML API that you will need to set up separately. 

Once you have your keys, set up your environment with 
```sh
bundle exec figaro install
```
 Then add your keys to `config/application.yml`:
```ruby
MODERATION_ID: <YOUR_NYCKEL_KEY>

PERSPECTIVE_KEY: <YOUR_PERSPECTIVE_KEY>
```
Start a rails server, and you're ready to query 
```sh
rails s
```

# <a name="endpoints"></a>Endpoints

## <a name="get-recipes"></a> GET /api/v1/recipes
[Back to top](#contents)

Gets recipes from a single country.

   | Parameter      | Description | Parameter type      | Data type |
   | ----------- | ----------- | ----------- | ----------- |
   | **country** | Optional - specify a country       | query   | String        |

   *If no country parameter is included, recipes for a random country will be returned* 

**Sample response (status 200)**
 ```json
 {
    "data": [
        {
            "id": null,
            "type": "recipe",
            "attributes": {
                "title": "Andy Ricker's Naam Cheuam Naam Taan Piip (Palm Sugar Simple Syrup)",
                "url": "https://www.seriouseats.com/recipes/2013/11/andy-rickers-naam-cheuam-naam-taan-piip-palm-sugar-simple-syrup.html",
                "country": "thailand",
                "image": "https://edamam-product-images.s3.amazonaws.com/web-img/611/611..."
            }
        },
        {
            "id": null,
            "type": "recipe",
            "attributes": {
                "title": "THAI COCONUT CREMES",
                "url": "https://food52.com/recipes/37220-thai-coconut-cremes",
                "country": "thailand",
                "image": "https://edamam-product-images.s3.amazonaws.com/web-img/8cd/8c..."
            }
        },
        {
            "id": null,
            "type": "recipe",
            "attributes": {
                "title": "Sriracha",
                "url": "http://www.jamieoliver.com/recipes/vegetables-recipes/sriracha/",
                "country": "thailand",
                "image": "https://edamam-product-images.s3.amazonaws.com/web-img/cb5..."
            }
        }
    ]
 }
 ```
---
