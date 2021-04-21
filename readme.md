Original App Design Project - README Template
===

# STOCK SIMULATOR

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Stock Simulator that allows users to trade with fake balance. Users can view their portfolio performance, search for stocks, "buy" and "sell" stocks, and view leaderboards and portfolio's of others.

### App Evaluation
- **Category:** Finance
- **Mobile:** Real time data and push notifications
- **Story:** Learning experience for investers who want to understand the market before investing real money
- **Market:** The app is targeted at users who want to get into the stock market but are afraid to lose real money
- **Habit:** Users will be compelled to track the progress over their portfolio. 
- **Scope:** The MVP of the app should be completed by the end of the course. Many if not all of the bonus stories can also be completed by the end of the course. We have identified all the core features of the app that will allow users to practice investing. We have also identified features that will promote interaction between users.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can login
* User can register for new account
* User can view portfolio overview
* User can search
* User can view stock details
* User can view stock's performance over time 
* User can view profile/settings
* User can use fake currency for buying/selling stocks

**Optional Nice-to-have Stories**
* User can view others via the social tab
* User can view other profiles
* User can compete in Leaderboards
* User can follow others
* User can unfollow others
* User can trade Crypto Currencies
* User has access to Learning Resources
* User can trade Options
* User can change profile image/username/password
* User receives push notifications for stock performance

### 2. Screen Archetypes

* Login Screen
    * User can login
    * User can register
* Home Screen/ Portfolio Overview
    * User can see portfolio performance 
* Search 
    * User can search for stocks by ticker or company name
    * User can search for others by Username
* Detail
    * User can see stock details
    * Stock's performance over time is charted 
    * User can "buy" or "sell" stock
* Stream
    * User can see leaderboards they are a part of
    * User can see profiles of people they are following
* Profile/ Settings
    * User can manage fake currency balance 
    * Settings

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home Screen/Portfolio
* Stock Search
* Social
* Profile/Settings

**Flow Navigation** (Screen to Screen)

* Login Screen
   * Home Screen / Portfolio Overview
* Home Screen  
   * Stock Details Screen
* Search Screen
   * Stock Details Screen
* Social Screen
   * User Searching Screen
   * Profile Screen for Other Users
* User Searching Screen
   * Profile Screen for Other Users


## Wireframes

<img src="https://i.imgur.com/WwIvgOZ.jpg" width=600>
<p>Highlighted in yellow are the bonus stories</p>


### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
### Models
#### User

   | Property | Type | Description |
   | -------- | ---- | ----------- |
   | objectId | String | unique id for the user post (default field) |
   | username | String | login name |
   | password | String | Login crediential |
   | balance  | Double    | current balance of fake currency |
   | profile_image | File | image tied to user's account |
   | portfolio | Pointer to Portfolio | portfolio of the user |
   |following  | array | array of pointers to users |
   
#### Portfolio
   | Property | Type | Description |
   | -------- | ---- | ----------- |
   | user     | Pointer to User | owner of the portfolio|
   | ticker   | String | name of the stock |
   | quantity | Int | how many of this stock is bought |
   | date_bought_at | Date | when stock was purchased |
   | price_bought_at | Double | stock's purchase price |
   
   
### Networking
#### List of network requests by screen
   - Home Screen/Portfolio Overview
       - (Read/GET) Query all tickers in portfolio
         ```swift
         let query = PFQuery(className:"Portfolio")
         query.whereKey("user", equalTo: currentUser)
         query.findObjectsInBackground { (tickers: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let tickers = tickers {
               print("Successfully retrieved \(tickers.count) tickers.")
           // TODO: Do something with posts...
            }
         }
         ```
       - (Read/GET) Query balance of user
       - (Read/GET) Query current prices of stocks
   - Stock Detail
      - (Create/POST) Add ticker and date to portfolio when bought
      - (Update/PUT) Increase or decrease quantity of stock
      - (Delete) Delete ticker from portfolio when all is sold
      - (Read/GET) Query information about stock including prices, quantity, changes, etc
   - Profile Screen
      - (Read/GET) Query logged in user object
      - (Read/GET) Query username and balance of user
