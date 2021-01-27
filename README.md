# cafe-express

 Vacanseat


<span style="text-decoration:underline;">VACANSEAT </span>

VacanSeat is designed to connect venues (restaurants/bars/cafes) that have immediate capacity with patrons for impromptu bookings.

Walking door to door with a group of people or calling venues found using simple search methods on a smartphone, requires a lot of effort and produces arbitrary results.  With VacantSeat users are presented with a range of available options within their direct vicinity that they can filter based upon meaningful requirements such as distance, venue type and most important of all party size.

Merchants are supplied with a new sales channel, useful whether the restaurant is unexpectedly empty or when they simply wish to maximise occupancy.  The signup is simple and the system itself is designed to easily integrate with their existing booking management system.

<span style="text-decoration:underline;">Tech/Framework</span>



<p id="gdcalert1" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image1.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert2">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image1.png "image_tooltip")


The application uses a variety of technologies described below with relevant links.

The front end application was developed using Dart Language and the Flutter framework. For more information on Dart and Flutter:

[https://dart.dev/](https://dart.dev/)

[https://flutter.dev/](https://flutter.dev/)

For more information on the various third party packages used:

[https://pub.dev/](https://pub.dev/)

Amazon Amplify was used to provide a serverless backend via DynamoDB and AWS Lambda. Using Amplify meant that other AWS features could be accessed such as S3 for photo storage and Cognito for user signup and login. 

[https://aws.amazon.com/getting-started/hands-on/build-flutter-app-amplify/](https://aws.amazon.com/getting-started/hands-on/build-flutter-app-amplify/)

[https://aws.amazon.com/dynamodb/](https://aws.amazon.com/dynamodb/)

[https://aws.amazon.com/lambda/](https://aws.amazon.com/lambda/)

[https://aws.amazon.com/s3/](https://aws.amazon.com/s3/)

[https://aws.amazon.com/cognito/](https://aws.amazon.com/cognito/)

The application utilises the google map and routes APIs and the Stripe API for payments from customers to merchants via Stripe Connect.

[https://developers.google.com/maps](https://developers.google.com/maps)

[https://stripe.com/docs/api](https://stripe.com/docs/api)

<span style="text-decoration:underline;">Functional example</span>

When a user first loads the app they are greeted with a login/signup page that is Identical for merchants and customers.

In order to create an account within VacantSeat users will need an Email address to verify their registration and for the purposes of password recovery.

During the signup process the user will be asked to indicate whether they are initialising a “Merchant” or “Customer” account.

Merchant sign up requires additional details relating to their establishment, its location, contact details and other relevant information.

Merchants who would like to take advantage of the deposit fee option will need to register for a stripe account. There is a weblink within that application to facilitate the stripe signup process, however initialising a stripe account requires a number of pages of data entry so it is recommended to do this separately on a computer.

Customer flow:

Upon entry to the application as a customer, the user is presented with a map view displaying participating restaurants within range.   There are a selection of filter options that can be accessed via the button at the bottom of the page. Filters include party size, distance and venue type. 

Available venues on the map can be directly inspected by tapping upon them or by scrolling through the gallery feature in the bottom portion of the display.

Tapping on the information bubble above a pin or directly upon the photo in the gallery will take the user through to the venue detail page where the user is able to inspect further information relating to the venue and make a booking if desired.

In order to complete a booking the user must enter a reservation name. If there is a seating deposit specified the user is prompted to make a one time payment via credit card. 

After the booking process is complete the user is taken to a timer page. Additionally, an email receipt related to the booking is sent to the users registered email address for reference.

     The timer page contains:  



*   A map with a route to the selected venue.
*   A countdown timer of 30 minutes.
*   A QR code Scanning function for Check In at the venue.
*   Phone and email contacts for the venue

Merchant flow:

When a user enters the application from a merchant account they are greeted with the main control panel. From here they can make available various table configurations for customers to book. If they should desire they can assign a deposit fee related to that table.

The settings page has a sliding drawer style menu giving access to other important pages such as store details, booking history, stripe payment registration and the QR code check in page.

When a customer makes a booking at the store the merchant is sent a notification and the relevant seating configuration is toggled off. The merchant is prompted to review the reservation and must make a decision based upon their own circumstances as to whether to manually reoffer the seating configuration to the app again.

Once the customer has arrived at the location the Merchant can manually check the user in by clicking the button on the booking transaction page. Alternatively, they can require the customer to scan either the QR code within the application or a QR code placed conveniently with the store.

<span style="text-decoration:underline;">Credits</span>

VacantSeat was developed by Code Chrysalis chort 16 graduates,  

TEAM YARN:

Y.Wakabayashi - Tech Lead and Full Stack,

A.Stevenson - Front End,

R.Takezono - Front End,

N.Maeda - Full Stack.

Special Thanks to: 

R.Viana, 

E.Kidera,

Y.Yamada,

T.Kondo.
