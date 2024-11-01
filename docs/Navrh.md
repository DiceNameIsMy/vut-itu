# Návrh Projektu ITU 2024/2025
Brno University of Technology - Faculty of Information Technology

---

TODO: Obsah. 

<div style="page-break-after: always;"></div>
---

# 1. The Application (Zadání)
### 1.1 Name & Topic (Název a téma)
**Name: YouQuest**
**Team members:**
- Albert Popov () <- Captain
- Nadzeya Antsipenka (xantsi00)
- Nurdaulet Turar (xturarn00)

---
### 1.2 Customers research (Uživatelský průzkum a specifikace)

**Our customers (kdo je konkrétní uživatel):**
- Individuals passionate about travel, traveling occasionally as a hobby.
- Primarily users who own or frequently rent a car when travelling.

**What they want/need from the application (co přesně od aplikace potřebuje):**
- A tool that simplifies planning of their trips.

**Customer Requirements (požadavky uživatele):**

**Their experience**:

Albert's research:
- Created a Google Form (TODO: add a link?)
- Surveyed 2 respondents
- TODO: Summarize their replies?

---

Nadzeya's research:
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

---

Nur's research
- Developed a list of questions for in-person respondent interviews.
- Made research in reddit

Nikita Krivenko:
I have had interviewed him about his traveling experience. Why he likes traveling, how a trip planning process starts, how did some of his trips go. Tried to find some ideas what he might be missing in this process that he'd appreciate without asking directly, and then asked directly nonetheless. To summarize it, here are most relevant questions and answers:
1. **Have you ever planned a trip to a completely new location?** (It would make no sense to continue if an answer was a no)
    - Yes
2. **How did you plan it? How did you choose places or cities to visit? What were your selection criteria?**
    - My mother wanted to travel, so we searched on Google and used 34Travel along with friends’ recommendations. The main criteria were sightseeing opportunities, financial accessibility, and if possible, a location within the EU for visa purposes.
3. **What applications did you use during the planning process?**
    - Beach spots: photos and reviews on the web
    - Other attractions: reviews and articles on the web (reviews are more relevant than articles)
4. **How was your experience? What did you enjoy, and what could be improved?**
    - It would be convenient to have a tool for simultaneously planning places to visit (find & browse attractions, decide on whether they are interesting see reviews, photos, etc.) and organizing a route (decide on how to visit places chosen, see if all works out timetable).
5. **Do you consider events happening at your travel destinations?**
    -  No
6. **When you arrive in a city, are you interested in seeing nearby attractions?**
    -  Yes
7. **While traveling from one location to another, do you explore sights along the way?**
    -  Yes

---

To summarize, our customers wishes are:
- A streamlined, intuitive interface with minimal clutter.
- Ability to browse attractions with user recommendations on routes, not just destinations. TODO: What does that mean?
- **Recommendations** not only on places to visit, but **on whole routes with attractions to take**.
- Be able to find and research places. With pictures. When they are found and selected, **suggest possible routes to take.**
- Shared accounts for group planning.
- Weather forecasts for planned dates and destinations.
- Storage for travel-related documents (tickets, QR codes, location details).

---
### 1.3 Research of existing solutions (Průzkum existujících řešení)

**Tripit (Albert)**
TripIt is a travel management application designed to streamline the organization of travel plans by consolidating all trip details in one place. It automatically creates a detailed timeline from booking confirmations for flights, hotels, car rentals, and other services by forwarding confirmation emails to a dedicated address.

Pros:
- Intuitive, easy to navigate, visually appealing timeline of trip details.
- Centralizes booking info like confirmations and tickets.
- Allows shared, multi-user trip editing.
Cons:
- Overwhelming field options for adding events, hindering user experience.
- No recommendation system, requiring manual addition of destinations.
- Limited document uploads in the free version; paid version billed annually.

**MakeMyTrip (Albert)**
MakeMyTrip integrates booking options for flights, hotels, and packages in one app, simplifying travel planning.

Pros:
1. Integrated bookings for flights, hotels, transport, and packages in one app, streamlining travel planning.
2. Loyalty System: Regular users enjoy bonuses and discounts.
3. Travel Community Forum and Blog: Users can read and post reviews, sharing experiences and tips, which assists in planning.
Cons:
1. Cluttered Interface: The app's interface is overloaded and suggests services like hotel bookings before destination selection, complicating navigation, especially for undecided users.
2. Tailored mainly for Indian users, limiting feature access for international travelers.
3. Trip Planning Post-Purchase: Itineraries auto-populate only after booking, inconvenient for users who prefer route planning before purchase.

**Wanderlog (Nadzeya)**
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
6. Absense of filtering and sorting options when searching for attractions.
7. Offline maps are only for the paid Pro version.

**Stippl (Nadzeya)**
Pros:
1. Detailed guides to some cities and destinations for inspiration.  
2. Allows users to collaborate with fellow travelers.  
3. Trip info can be easily shared.
Cons:
1. Interaction with a map is confusing and very "lacking" in features
2. Doesn't have a help guide. TODO: What does that mean?
3. Some users find the interface to be too complicated.
5. Does not include user reviews of destinations or attractions.

**Sygic Travel (Nur)**
Pros:
1. Integrates reviews from external platforms such as TripAdvisor.
3. Detailed guides for cities and destinations worldwide.  
4. A wide range of features. Users can organise itineraries, routes, reservations, accommodation and expenses.  
5. Users can fill their journey with places to visit using a map with icons of attractions
Cons:
1. The interface is unintuitive.
2. No collaboration between travelers.
3. Maps customisation in Google Maps is noticeably better.
4. Offline maps are only for the paid Pro version. 
5. Does not include user reviews of destinations or attractions and other guidelines or advice from other travelers.

**TripAdvisor (Nur)**
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

**Willingness to Pay**

While some users are open to paying for premium features, the consensus is that the current pricing models are often seen as excessive. Many indicated they would consider paying around $20 per year for an app that meets their needs but find $60 unjustifiable given the limited frequency of their travel.Overall, while there is enthusiasm for tools like Wanderlog and TripIt, significant concerns about usability, pricing strategies, and feature sets have led many users to revert to simpler solutions or a mix of existing tools like Google Maps and spreadsheets.

**Conclusion**
None of the applications fulfill all the main wishes of our respondents we've identified. Some excel at their own thing (TripAdvisor, TripIt), some tried to include everything on one place but failed to consider what's the most important for users (Wanderlog). Sygic seems to be the best all-in-one app to manage your trips we've reviewed. Lacking in with ... though.

Keypoints:
- It's very important to keep in mind our customer's first interaction when designing a multi-purpose, all-around app, because the first impression is the biggest factor in user retention.
- TODO: Add something about none of the apps providing routes from real users, or them being badly implemented. We can to better.
- TODO: ...

### 1.4 App Requirements (Zadání)
TODO: Translate & describe the app itself, what can be done there, etc.

Мы хотим сделать croud sourced приложение для путешественников.
- Маршруты от других людей
- Отзывы о локациях
- Возникает вопрос: А наши пользователи стали бы этим заниматься?

Главная киллер фича приложения: крауд сорсинг.
- отзывы на места
- добавление мест на карте
- создание маршрутов для других пользователей

Второстепенная: Система рекомендаций для создания мaршрутов.
- Сделаем простую имплементацию (генерацию рекомендаций мб сделаем позже)

Пользователь может:
- Смотреть на карте места, точки интереса
- Добавить точку интереса/город в вишлист
- Проложить маршрут
	1) Вручную, автоматически (можно преложить ещё точки интереса)
	2) Выбрать среди уже проложенных другими пользователями маршрут
- Просмотр маршрутов ранее добывленными пользователями
- Добавить маршрут в вишлист
- Добавить точку интереса на карте
- Поделиться маршрутом в сети
- Поделиться маршрутом друзьям
- Во время просмотра его маршрута целиком мб показывать погоду на те даты

**Key FE Components (Klicove casti BE)**
- Onboarding
- A screen to search, view and select locations (& attractions?)
- A screen to make a plan to visit selected locations (Make or choose a route. Set dates when to visit. See a weather forecast?)

---

### 1.5 FE Work distribution (Rozdělení práce týmu na FE)
TODO

<div style="page-break-after: always;"></div>
# 2. App proposal (Návrh)

### GUI (Návrh GUI)
TODO: Screenshots & an explanation how does it fulfill the user requirements.
TODO: How to separate our work?

### Tech stack choice (Výběr technologií)
TODO

### BE API (Návrh API k BE)
TODO: Describe BE. It's core functionality. What library(-s) was(were) used.
TODO: Describe how GUI communicates with a BE. +API Documentation.

---
### 2.1 Návrh GUI
### 2.2 Výběr technologií
### 2.3 Návrh API k BE (v rámci týmu)
<div style="page-break-after: always;"></div>
# 3. Funkční základ aplikace

### 3.1 BE Implementation (Implementace BE)
TODO: Describe it & attach some screenshots?
### 3.2 Klicove casti FE
TODO: Describe it & attach some screenshots?	