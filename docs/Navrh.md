# Návrh Projektu ITU 2024/2025
Brno University of Technology - Faculty of Information Technology

---

TODO: Obsah. 

<div style="page-break-after: always;"></div>
---

# 1. The Application (Zadání)
### 1.1 Name & Topic (Název a téma)
#### 1.1.1 YouQuest
We have decided we'd like to look into applications that provide tooling to help people in planning their upcoming trips, be it one or many cities, a new country, or a different continent. Nadzeya came up with this idea because of the many issues she and her friends had with the tooling they were recently using. Some of them being:

#### 1.1.2 Team members
- Albert Popov (xpopov10) <- Captain
- Nadzeya Antsipenka (xantsi00)
- Nurdaulet Turar (xturarn00)

---
### 1.2 Customers research (Uživatelský průzkum a specifikace)
We have found and interviewed relevant 5 customers in total. An offline interview, open-ended Q&A, and an online questionnare were used. Here's what we've learned from them:
#### 1.2.1 Our customers (kdo je konkrétní uživatel)
- People interested in traveling.
- Primarily people who own, or are used to renting a car when traveling.
#### 1.2.2 What they want/need from the application (co přesně od aplikace potřebuje)
- A tool that makes planning of a trip easy.
#### 1.2.3 Customer Requirements (poždavky uživatele)
A summary:
- A streamlined, intuitive interface with minimal clutter.
- Ability to browse attractions with user recommendations on routes, not just destinations. TODO: What does that mean?
- **Recommendations** not only on places to visit, but **on whole routes with attractions to take**.
- Be able to find and research places. With pictures. When they are found and selected, **suggest possible routes to take.**
- Shared accounts for group planning.
- Weather forecasts for planned dates and destinations.
- Storage for travel-related documents (tickets, QR codes, location details).
#### 1.2.4 Underlying Research

##### 1.2.4.1 Albert's customer research:
- Created a Google Form (https://forms.gle/QXqrSPgtp4VPS8CR9)
- Surveyed 2 respondents


1. **Have you travelled or are you planning to travel? Or has someone planned it for you?**
- Yes
- Yes, I have travelled

2. **How did you plan it? How did you choose the places, cities to visit? What criteria did you use to choose?**
- Proximity to each member of the expedition, relatively cheap accommodation and flights.
- Internet guides. Hashtags on Instagram. Reviews on Google maps

3. **Do you use apps when planning your trip, if so, which ones?**

- No
- Help notes on mobile

4. **What was your experience? What did you like about it? What could have been done better? (if you haven't used the app, you can skip it)**

- I like the ease of use. Easy to change the schedule. Ease of sharing notes.
- (Not using any apps)

5. **Do you factor in events (fairs, carnivals, festivals) in the places you visit?**

- No
- Yes

6. **Do you go for the sights of a city or for the events in that city?**

- The first option
- Both sights and events

7. **What is your usual budget? Floating or specific?**

- I usually don't have a segmented amount and i often spend more than expected
- Floating

8. **When you visit a city, are you interested in seeing the sights around that city? (Out of town)**

- Yes, thats why i love traveling by car
- Yes, as long as it is easily accessible by public transportation.

9. **Do you prefer to visit only one city or several cities?**

- I prefer to visit several cities and even several countries within my trip
- Depends on the number of days and the size of the city. 3 days for a small city (Znojmo), 10 days for a big city (Paris).

10. **When traveling from one city to another, would you like to see sights along the way?**

- Yes
- Rather no than yes. Only if a private car

11. **Are there any wishes for the apps you use?**

- Easy to use, so that I wouldn't be too lazy to use it after a couple of uses
- No

12. **What do you miss when planning your travels? What would help you with that?**

- Maybe it would be great to have an app where i can store all QR codes, PINs, addresses, and telephone numbers related to this trip (flights, accommodation etc).
- Automatic weather updates. For example, two days before departure/leave get an alert: “It will rain in $city_name for the next two days. Don't forget to take an umbrella” etc.

Survey Conclusion

    Trip Planning: Both respondents had travelled before and planned their trips themselves. They chose destinations based on accessibility, accommodation and transport costs, as well as online reviews and social media such as Instagram and Google Maps.

    Use of apps: Both respondents indicated that they do not use specialised planning apps, relying on notes on mobile devices. They appreciate the ease and convenience of editing schedules and sharing notes.

    Travel interests: One respondent prefers to visit attractions, while the other is interested in both attractions and events such as fairs and festivals.

    Budget: Learners indicated that their budget is usually ‘floating’ and they often spend more than they had planned. This indicates a flexible approach to finances.

Thus, it can be concluded that users are interested in an app that would integrate route planning, trip information storage and weather alerts to facilitate trip organisation and improve travel comfort.

##### 1.2.4.2 Nadzeya's customer research:
- Developed a list of questions for in-person respondent interviews.
- Surveyed 2 respondents.

To summarize, our potential customers want a travel app to have:
- a basic interface initially that grows in complexity only as needed.
- a clean, minimalistic design with color accents for important menu items.
- an easy-to-create wish list of destinations marked on a map without requiring daily or hourly scheduling.
- automatic distance calculation between wish-listed spots, with suggestions for nearby attractions.
- minor, lesser-known locations (e.g., cemeteries, small landmarks, abandoned buildings) with photos and descriptions, even if these places aren't typically classified as "mainstream" attractions.
- a simple list of local, free events without cluttering the primary experience.
- filters or tags to prioritize affordable food, accommodation, and travel options.
- user-provided guides about places to eat, stay, visit, and other minor areas of interest.
##### 1.2.4.3 Nurdaulet's customer research
- Developed a list of questions for in-person respondent interviews.
- Using that, has interviewed 1 relevant customer.

My interviewee does not have extensive experience with other trip-planning apps. I conducted an interview to learn more about his travel experiences, focusing on why he enjoys traveling, how he approaches trip planning, and how some of his past trips have went.

He is open to exploring new apps to find a better fit for his needs. Specifically, he would like an app that can assist with trip planning while suggesting activities and places to visit. A key use case he mentioned is when driving to a new city - using a navigation app to display interesting attractions and sightseeing opportunities along the route.

I aimed to find spots in his process, that we could optimize to improve his experience. To learn about that, I've started by asking open-ended questions, but then went more directly. Below is a summary of the most relevant questions and responses:
1. Have you ever planned a trip to a completely new location? (It would make no sense to continue if an answer was a no)
    - Yes
2. How did you plan it? How did you choose places or cities to visit? What were your selection criteria?
    - My mother wanted to travel, so we searched on Google and used 34Travel along with friends’ recommendations. The main criteria were sightseeing opportunities, financial accessibility, and if possible, a location within the EU for visa purposes.
3. What applications did you use during the planning process?
    - Beach spots: photos and reviews on the web
    - Other attractions: reviews and articles on the web (reviews are more relevant than articles)
4. How was your experience? What did you enjoy, and what could be improved?
    - It would be convenient to have a tool for simultaneously planning places to visit (find & browse attractions, decide on whether they are interesting see reviews, photos, etc.) and organizing a route (decide on how to visit places chosen, see if all works out timetable).
5. Do you consider events happening at your travel destinations?
    -  No
6. Are you interested in seeing nearby attractions?**
    -  Yes
7. While traveling from one location to another (they use carsharing), do you explore places, attractions along the way?
    -  Yes

### 1.3 Research of existing solutions (Průzkum existujících řešení)

#### 1.3.1 Tripit (Albert)
TripIt is a travel management application designed to streamline the organization of travel plans by consolidating all trip details in one place. It automatically creates a detailed timeline from booking confirmations for flights, hotels, car rentals, and other services by forwarding confirmation emails to a dedicated address.

Pros:
1. Intuitive, easy to navigate, visually appealing timeline of trip details.
2. Centralizes booking info like confirmations and tickets.
3. Allows shared, multi-user trip editing.
Cons:
1. Overwhelming field options for adding events, hindering user experience.
2. No recommendation system, requiring manual addition of destinations.
3. Limited document uploads in the free version; paid version billed annually.

#### 1.3.2 MakeMyTrip (Albert)
MakeMyTrip integrates booking options for flights, hotels, and packages in one app, simplifying travel planning.

Pros:
1. Integrated bookings for flights, hotels, transport, and packages in one app, streamlining travel planning.
2. Loyalty System: Regular users enjoy bonuses and discounts.
3. Travel Community Forum and Blog: Users can read and post reviews, sharing experiences and tips, which assists in planning.
Cons:
1. Cluttered Interface: The app's interface is overloaded and suggests services like hotel bookings before destination selection, complicating navigation, especially for undecided users.
2. Tailored mainly for Indian users, limiting feature access for international travelers.
3. Trip Planning Post-Purchase: Itineraries auto-populate only after booking, inconvenient for users who prefer route planning before purchase.
4. You trip plan is available only on online

#### 1.3.3 Wanderlog (Nadzeya)
A comprehensive tool for organizing trips from start to finish.

Pros:  
1. Has a wide range of features. Has almost everything you need to plan a trip: organize itineraries, plan routes, store reservations, accommodation and track expenses.  
2. Allows for online collaboration with other people coming on a trip.
3. Includes lists of attractions that can help users find new entertainment ideas.  
Cons:
1. Has a cluttered, unintuitive interface that can put off new users.  
2. Users are unable to add customised pins or markers on a map.
3. Does not include real-time updates for weather or traffic.
4. Does not include user reviews of destinations or attractions and other guidelines or advice from other travelers.
5. Absense of filtering and sorting options when searching for attractions.
6. Offline maps are only for the paid Pro version.

#### 1.3.4 Stippl (Nadzeya)
Pros:
1. Detailed guides to some cities and destinations for inspiration.  
2. Allows users to collaborate with fellow travelers.  
3. Trip info can be easily shared.
Cons:
1. Interaction with a map is confusing and very "lacking" in features
2. Doesn't have a app using tutorial.
3. Some users find the interface to be too complicated.
4. Does not include user reviews of destinations or attractions.

#### 1.3.5 Sygic Travel (Nur)
Pros:
1. Offline maps, which is useful in areas with poor coverage.
2. Integrates reviews from external platforms such as TripAdvisor.
3. Detailed guides for cities and destinations worldwide.  
4. A wide range of features. Users can organise itineraries, routes, reservations, accommodation and expenses.
5. An appealing interactive map for planning activities within a city
Cons:
1. Absense of collaboration features.
2. Offline maps are only for the paid Pro version. 
3. Does not include user reviews of destinations or attractions and other guidelines or advices from other travelers.

#### 1.3.6 TripAdvisor (Nur)
Helps travelers find, review, and plan visits to attractions, restaurants, and events worldwide. It provides user-generated reviews, ratings, and booking options to assist with informed travel decisions.

Pros:
- Large information database on attractions, restaurants, and hotels with reviews and ratings from users.
- Booking options directly through the app, simplifying travel planning.
- Integration with maps and navigation services.
Cons:
- Limited trip planning flexibility, especially regarding detailed scheduling and route tracking.
- Complex and unintuitive trip organization interface.
- Ads and commercial influence on search results.
**User Expectations and Desires**

- **Collaboration Features**: There is a strong demand for better collaboration tools that allow users to share itineraries easily with friends and family.
- **Simplified Planning Tools**: Users want straightforward tools that allow them to plan itineraries without unnecessary complexity. They prefer apps that can integrate their travel information seamlessly without overwhelming them with ads or upselling.
- **Integration with Other Services**: Suggestions were made for integrating travel planning apps with credit card services to enhance functionality, as many users already utilize these cards for travel-related benefits.
#### 1.3.7 Conclusion
None of the applications fulfill all the main wishes of our respondents we've identified. Some excel at their own thing (TripAdvisor, TripIt), some tried to include everything on one place but failed to consider what's the most important for users (Wanderlog). //TODO: Add smth about Sygic & MakeMyTrip?

Keypoints:
- It's very important to keep in mind our customer's first interaction when designing a multi-purpose, all-around app, because the first impression is the biggest factor in user retention.
- //TODO: Add something about none of the apps providing routes from real users, or them being badly implemented. We can to better.
- //TODO: ...
- Driving in a car can get boring. They wanted like to have a way to discover & visit nearby attractions while on their way to their main destination.
- //TODO Написать о том что мы при планировании поездок мы используем множетсво ресурсов в рамках одного приложения
- //TODO 
### 1.4 App Requirements (Zadání)

#### 1.4.1 User Capabilities
Our app will allow users to:
- **Crowdsourcing** is the core of our app. What makes us different from out competitiors. We want to bring users to a platform where they can share experiences, provide guidance to others.
- **Browse cities and attractions** using an interactive map of the whole globe. Add them to a wishlist.
- **Create routes between cities and attractions**
    1. Automatically using the built-in navigation software. Be able to tweak it if deemed necessary.
    2. Choose from routes created by other users.
- View and save **routes from the community** to their wishlist.
- View weather forecasts for dates associated with their chosen routes.
- Make reviews of places they've visited.
- Share information about ongoing activities, festivals, parties.
- Create and share routes they've taken with other users.
- Share routes via social media or using a link.
- Add new locations to the map.
#### 1.4.2 Core Front-End Components
- **Onboarding** screens that skip several steps of the default use flow to introduce new users to the app. By doing so we aim to have the first-time interaction as frictionless as possible.
- **Inspirations** screen for browsing ideas for trips to take, places to visit.
- **Interactive map** for browsing and saving/selecting locations and/or attractions.
- **Organizing** screen for creating or selecting routes, setting visit dates, and viewing weather forecasts for the trip.

---

### 1.5 FE Work distribution (Rozdělení práce týmu na FE)

TODO: IT'S A SAMPLE. CAN BE CHANGED.
#### 1.5.1 Albert's FE
- Wishlist screen
- Route selection screen
#### 1.5.2 Nadzeya's FE
- Main screen
- Options (Settings)
#### 1.5.3 Nurdaulet's FE
- Onboarding
- Documents viewing & uploading

<div style="page-break-after: always;"></div>
# 2. App proposal (Návrh)

### 2.1 GUI (Návrh GUI)
#### 2.1.1 Albert's GUI
- Wishlist screen
- Route selection screen
- TODO: Screenshot from Figma of work done
#### 2.1.2  Nadzeya's GUI
- Main screen
- TODO: Screenshot from Figma of work done
#### 2.1.3 Nurdaulet's GUI
- Onboarding
- Documents viewing & uploading
- TODO: Screenshot from Figma of work done
### 2.2 Tech stack choice (Výběr technologií)
The following sections detail our choices for the platform and framework, along with the reasoning behind each decision.
#### 2.2.1 Chosen FE Platform
We have decided to make a mobile application. Our users are always carrying their phones with them (everyone do). Since we provide **offline navigation**, storing of tickets, passes, mobile platform fits best for our use case.
#### 2.2.2 Chosen FE Framework
We have chosen Flutter as out mobile framework, since it is the best fit for our application. When considering the choice of technology stack, we've been considering **Time To Market**, being how fast an application can be built & released, **performance**, since displaying a customized map is a moderatly intensive task. **We did not care about the application size**, since it's safe to say that these days most phones can easily allocate ~100 MB of storage. Here's a table of comparison:

| Platform         | Development Time                                              | Team Experience                             | Performance             | Application Size |
| ---------------- | ------------------------------------------------------------- | ------------------------------------------- | ----------------------- | ---------------- |
| **Native**       | Longest development time                                      | No experience with native development       | Highest performance     | Minimal          |
| **React Native** | Shorter time to market                                        | Limited prior experience                    | Below average           | Relatively small |
| **Xamarin**      | Moderate time to market; may need platform-specific expertise | Strong in C# and .NET                       | Average                 | Moderate         |
| **Flutter**      | Shorter time to market                                        | Dart is similar to C#; solid OOP background | Near-native performance | Relatively large |
#### 2.2.3 Chosen BE Framework
We've chosen .NET to develop an API for our application. Reasoning behind this:
- We all have experience with .NET Framework -> it's the fastest way for us to create a BE.
- It's both performant in development time and execution time.
- Huge and very mature developers community.
### 2.3 BE API (Návrh API k BE, v rámci týmu)
#### 2.3.1 Architecture: MVVM at FE

![FE Architecture](Pasted%20image%2020241107230844.png)
	#### 2.3.2 Data model
Below our current sketch of our data model is presented. Cities are added when a place within that city is added. User can plan to visit several places within one city.

![Data Model](Pasted%20image%2020241107231140.png)
#### 2.3.3 Backend
Most of the functionality is going to be provided via http API.

Our API will provide the following:
- 🌍 Querying of **Points of Interest (PoI)** within some location range. It can be a city, a town, a museum, a mall, or whatever else.
- 🌄 Querying of Trips for inspiration. If user likes something, provide an action to copy it to his list of trips. 
	- On BE, a recommendation system would be added (out of scope, won't implement). It would pick out trip ideas from a database of trips of other users, that would then be shown to users that are looking for some inspiration.
- 🏛️ Adding a **Place** he wants to visit which is linked to a **PoI**.
- ☁️ Get a weather forecast for the **Cities** or **Places** he wants to visit for the dates range. It can be within his planned visiting dates, or a wider range to pick better dates.
- ✈️ CRUD of his **Trips**, an entity that holds the places he wants to visit during the trip.
- 🏛️ CRUD of his places.
- 📄 CRUD of his **Documents**, files that are useful to have in hand during the trip.
- ⭐ Create a review for a **Place** he had visited.
During development, more actions may be added as we spot what we might've missed.

<div style="page-break-after: always;"></div>
# 3. Funkční základ aplikace

### 3.1 BE Implementation (Implementace BE)
For the Proof Of Concept (PoC), we'll be storing almost everything locally. Time spent on local storage is not wasted, since our applicaiton must be accessible offline anyways. The only data that is loaded via web are:
- A map. It will be downloadable, but to not waste too much storage, offline maps will be downloaded only after explicit confirmation.
- Weather forecasts. Via external API. Cacheable
- Croudsourced data (Mocked for PoC): Attractions, reviews, events, routes.

Then, part of the data would be extracted to a BE server (Likely a .NET API).
- User information to enable synchronization with other devices.
- Trip information to enable sharing it with other people.
- TODO: Add other things we'd like to have in BE.

TODO: Attach some screenshots?
### 3.2 Klicove casti FE
TODO: Describe it & attach some screenshots?	


$$
	
$$