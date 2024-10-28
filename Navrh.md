
# The Application (Zadání)
### Name & Topic (Název a téma)
**Name: TODO**
**Team members:**
- Albert Popov ()
- Pupilla ()
- Nurdaulet Turar (xturarn00) <- Leader

---
### Customers research (Uživatelský průzkum a specifikace)

**Our customers (kdo je konkrétní uživatel):**
- People that love traveling. 
- Travel someplace every once in a while as a hobby. 
- Primarily those that have a car or are used to renting it.

**What they want/need from the application (co přesně od aplikace potřebuje):**
- A tool to simplify planning of the tourism activity

**Customer Requirements (požadavky uživatele):**

**Their experience**:
Albert's research:
- Google forms (TODO: add a link?)
- 2 respondents
- TODO: Summarize their replies?

Pupilla's research:
- Made a list of questions that were asked during a conversation with respondents
- 2 respondents
- TODO: Summarize their replies?

Nur's research
- Made a list of questions that were asked during a conversation with a respondent
- 1 respondent
- TODO: Summarize their replies?

To summarize, our customer's wishes are:
- Not overcrowded with features, intuitive interface.
- Browse attractions to visit.
- **Recommendations from real users** not only on places to visit, but **on whole routes to take.**
- Be able to find and research places. With pictures. When they are found and selected, **suggest possible routes to take.**
- Some customers mentioned a shared account so that everyone could participate in the planning.
- Weather forecast for the upcoming dates & places. 
- Place to store relevant info: Airplane tickets, QR codes to enter museums, theaters, etc., locations related to a trip.

---
### Research of existing solutions (Průzkum existujících řešení)

**TripAdvisor (Albert)**
Helps travelers find, review, and plan visits to attractions, restaurants, and events worldwide. It provides user-generated reviews, ratings, and booking options to assist with informed travel decisions.

Strengths:
- Large information database on attractions, restaurants, and hotels with reviews and ratings from users.
- Booking options directly through the app, simplifying travel planning.
- Integration with maps and navigation services.
Weaknesses:
- Limited trip planning flexibility, especially regarding detailed scheduling and route tracking.
- Complex and unintuitive trip organization interface.
- Ads and commercial influence on search results.

**Tripit (Albert)**
TripIt is a travel management application designed to streamline the organization of travel plans by consolidating all trip details in one place. It automatically creates a detailed timeline from booking confirmations for flights, hotels, car rentals, and other services by forwarding confirmation emails to a dedicated address.

Strengths:
- Intuitive, easy to navigate, visually appealing timeline of your trip.
- Related info about an upcoming trip can be stored in one place. Booking confirmations, vouchers, tickets, etc.
- The timeline can be shared, and modified by many people.
Weaknesses:
- Overwhelming amount of fields to fill when adding an event to visit, which does not benefit the UX.
- Absense of a recommendation system. Users must research and manually add places of interest.
- Only up to 3 documents can be uploaded in the free version. Paid version is only available for an annual billing cycle.

**Wanderlog (Pupilla)**
Wanderlog is a comprehensive tool for organizing trips from start to finish.
Strengths:  
1. Has a wide range of features. Has almost everything you need to plan a trip: organize itineraries, plan routes, store reservations, accommodation and track expenses.  
2. Allows for online collaboration with other people coming on a trip.
3. Includes lists of attractions that can help users find new entertainment ideas.  
Disadvantages:
1. Has a cluttered, unintuitive interface that can put off new users.  
2. Users are unable to add customised pins or markers on a map.
3. Does not include real-time updates for weather or traffic.
4. Does not include user reviews of destinations or attractions and other guidelines or advice from other travelers.
6. Absense of filtering and sorting options when searching for attractions.
7. Offline maps are only for the paid Pro version.

**Sygic Travel (Pupilla)****
Strengths:
1. Simpler interface compared to Wanderlog.
2. Integrates reviews from external platforms such as TripAdvisor.
3. More advanced filtering options than Wanderlog.
4. Detailed guides for cities and destinations worldwide.  
5. A wide range of features. Users can organise itineraries, routes, reservations, accommodation and expenses.  
6. Users can fill their journey with places to visit using a map with icons of attractions
Disadvantages:
1. The interface is unintuitive and people with trypanophobia would find it unpleasant.  
2. No collaboration between travelers.
3. Maps customisation in Google Maps is noticeably better.
4. Offline maps are only for the paid Pro version. 
5. Does not include user reviews of destinations or attractions and other guidelines or advice from other travelers.

**Stippl (Nur)**
Strengths:
1. Detailed guides to some cities and destinations for inspiration.  
2. Allows users to collaborate with fellow travelers.  
3. Trip info can be easily shared.
Disadvantages  
1. Interaction with a map is confusing and very "lacking" in features
2. Doesn't have a help guide. TODO: What does that mean?
3. Some users find the interface to be too complicated.
5. Does not include user reviews of destinations or attractions.

**MakeMyTrip (Nur)**
TODO

**Conclusion**
None of the applications fulfill all the main wishes of our respondents we've identified. Some excel at their own thing (TripAdvisor, TripIt), some tried to include everything on one place but failed to consider what's the most important for users (Wanderlog). Sygic seems to be the best all-in-one app to manage your trips we've reviewed. Lacking in with ... though.

Keypoints:
- It's very important to keep in mind our customer's first interaction when designing a multi-purpose, all-around app, because the first impression is the biggest factor in user retention.
- TODO: Add something about none of the apps providing routes from real users, or them being badly implemented. We can to better.
- TODO: ...

### App Requirements (Zadání)
TODO: Translate

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
# App proposal (Navrh)

### GUI (Návrh GUI)
TODO: Screenshots & an explanation how does it fulfill the user requirements.
TODO: How to separate our work?

### Tech stack choice (Výběr technologií)
TODO

### BE API (Návrh API k BE)
TODO: Describe BE. It's core functionality. What library(-s) was(were) used.
TODO: Describe how GUI communicates with a BE. +API Documentation.

---
# Funkční základ aplikace

**BE Implementation (Implementace BE)**
TODO: Describe it & attach some screenshots?

**Klicove casti FE**
TODO: Describe it & attach some screenshots?