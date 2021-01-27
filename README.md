<p align="center">*This repository was created during our time as students at Code Chrysalis.</p><br>
<p align="right"><img src="https://img.shields.io/badge/license-MIT-green" height=15px>
</p>

Thank you very much for coming to see our repository. We spent a month to create our app to solve real world problem in Tokyo. I hope you enjoy exploring here and our app.
<br>
<br>

<p align="center"><img src="assets/readMe/VACANSEAT_icon_250.png" width="200px"></p>

<br>
<h1 align="center">VACANSEAT</h1>

<p align="center"><strong>Mobile application to find and book real time vacant seat among cafes, restaurants, and bars.</strong></p>
<br>


## 0. Index
---
* [Introduction](#1.-Introduction)
* [Technology](#2.-Technology-/-Framework)
* [User Guide](#3.-User-Guide)
* [Authors](#4.-Authors)


## 1. Introduction
--- 

VACANSEAT is designed to connect venues (restaurants/bars/cafes) that have immediate capacity with patrons for impromptu bookings.

Walking door to door with a group of people or calling venues found using simple search methods on a smartphone, requires a lot of effort and produces arbitrary results.  With VACANSEAT users are presented with a range of available options within their direct vicinity that they can filter based upon meaningful requirements such as distance, venue type and most important of all party size.

Merchants are supplied with a new sales channel, useful whether the restaurant is unexpectedly empty or when they simply wish to maximise occupancy.  The signup is simple and the system itself is designed to easily integrate with their existing booking management system.


## 2. Technology / Framework
---

<br>
<p align="center"><img src="assets/readMe/vacanseat_tech_stack.png" width= "400"></p><br>


The application uses a variety of technologies described below with relevant links.

### *Front End*

The front end application was developed using [Dart](https://dart.dev/) Language and the [Flutter](https://flutter.dev/) framework.<br>

### *Back end*

[Amazon Amplify](https://aws.amazon.com/getting-started/hands-on/build-flutter-app-amplify/) was used to provide a serverless backend via [Amazon DynamoDB](https://aws.amazon.com/dynamodb/), [Amazon API Gateway](https://aws.amazon.com/api-gateway/), and [AWS Lambda](https://aws.amazon.com/lambda/). Using Amplify meant that other AWS features could be accessed such as [S3](https://aws.amazon.com/s3/) for photo storage and [Cognito](https://aws.amazon.com/cognito/) for user signup and login. [Websockets](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api.html) is used to send & receive real time data to-from the database.

### *API*


The application utilises the [Google Map API](https://developers.google.com/maps) to show the map with current location and routes to distanation. Also, the [Stripe API](https://stripe.com/docs/api) is integrated for payments from customers to merchants via Stripe Connect.

⚠️ Currently Stripe Connect account is in test mode, so the real transaction will not happen through Vacanseat.


## 3. User Guide
---


**1) User Sign Up**


When a user first loads the app they are greeted with a login/signup page that is Identical for merchants and customers.

In order to create an account within VACANSEAT users will need an Email address to verify their registration and for the purposes of password recovery.


During the signup process the user will be asked to indicate whether they are initialising a “Merchant” or “Customer” account.

<br>
<p align="center">
<img src="assets/readMe/logInScreen.jpg" width= "150"> &nbsp;&nbsp;&nbsp;
<img src="assets/readMe/verification page.jpg" width= "150"> &nbsp;&nbsp;&nbsp;
<img src="assets/readMe/user_category_screen.jpg" width= "150">
 &nbsp;&nbsp;&nbsp;
</p>
<br>

*For Merchants*
<br>Merchant sign up requires additional details relating to their establishment, its location, contact details and other relevant information. Merchant's can also setup a Stripe account through the Menu once logged in.



**2) Customer Flow**

### *A) Finding Vacant Seats* 🔎

Upon entry to the application as a customer, the user is presented with a map view displaying participating restaurants within range.   There are a selection of filter options that can be accessed via the button at the bottom of the page. Filters include party size, distance and venue type.


Available venues on the map can be directly inspected by tapping upon them or by scrolling through the gallery feature in the bottom portion of the display.

<br>
<p align="center">
<img src="assets/readMe/map_initial_view.jpg" width= "150"> &nbsp;&nbsp;&nbsp;
<img src="assets/readMe/filter_view.jpg" width= "150"> 
</p>
<br>

### *B) Booking Vacant Seats* ✅ 
Tapping on the information bubble above a pin or directly upon the photo in the gallery will take the user through to the venue detail page where the user is able to inspect further information relating to the venue and make a booking if desired.


In order to complete a booking the user must select (tap) one of the listed vacant seat and enter a reservation name. If there is a seating deposit specified the user is prompted to make a one time payment via credit card.

<br>
<p align="center">
<img src="assets/readMe/store_detail.jpg" width= "150"> &nbsp;&nbsp;&nbsp;
<img src="assets/readMe/booking_name.jpg" width= "150">
</p>
<br>

### *C) Go to Venue* 🏃‍♂️⏳
After the booking process is complete the user is taken to a timer page. Additionally, an email receipt related to the booking is sent to the users registered email address for reference.

The timer page contains:  

- A map with a route to the selected venue.
- ⚠️ A countdown timer of 30 minutes. 
- A QR code Scanning function for Check In at the venue.
Phone contacts of the venue


<p align="center">
<img src="assets/readMe/timer_page.jpg" width= "150">
</p>
<p align="center">⚠️ If customer do not check-in at the venue by the 30 minutes time frame, venues can cancel reservation and deposit will not return to the customer</p>

<br>

**3) Merchant flow**

### *A) Control Vacancy Status* 🕹️
When a user enters the application from a merchant account they are greeted with the main control panel. From here they can make available various table configurations for customers to book. If they should desire they can assign a deposit fee related to that table.


<p align="center"><img src="assets/readMe/merchant_control_panel.jpg" width= "200"></p>
<br>



### *B) Receive Booking Notification* ⚙️ 

When a customer makes a booking at the store the merchant is sent a notification and the relevant seating configuration is toggled off. The merchant is prompted to review the reservation and must make a decision based upon their own circumstances as to whether to manually reoffer the seating configuration to the app again.

<p align="center"><img src="assets/readMe/booking_notification.jpg" width= "200"></p>
<br>


### *C) Open Menu* ⚙️ 

The settings page has a sliding drawer style menu giving access to other important pages such as store details, booking history, stripe payment registration and the QR code check in page.

<p align="center"><img src="assets/readMe/menu.jpg" width= "200"></p>
<br>

### *D) Checkin Customers* ⚙️ 

Once the customer has arrived at the location the Merchant can manually check the user in by clicking the button on the booking transaction page. Alternatively, they can require the customer to scan either the QR code within the application or a QR code placed conveniently with the store.

<p align="center"><img src="assets/readMe/booking_list.jpg" width= "200"> &nbsp;&nbsp;&nbsp;
<img src="assets/readMe/qr_code.jpg" width= "200">
</p>
<br>


## 4. Authors
---


VACANSEAT was developed by Code Chrysalis cohort 16 graduates,  
<br>

### TEAM YARN:

#### Yoshinori Wakabayashi [@Bayezid1989](https://github.com/Bayezid1989)  
#### Naoto Maeda [@naoto-1119](https://github.com/naoto-1119)  
#### Alexander Stevenson [@AVStevenson](https://github.com/AVStevenson)  
#### Ryusei Takezono [@ryu-take](https://github.com/ryu-take)  


<br>

## 5. Acknowledgments:
---
We are indebted to the genuine support and insighful advice by...

#### R.Viana

#### E.Kidera,

#### Y.Yamada,

#### T.Kondo.

<br>

## 6. License
---
- MIT
