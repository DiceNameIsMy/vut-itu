
Musi obsahovat:
- rozdělení práce členů týmu na Výsledné implementaci (pouze FE),
- informace o zapracování případných připomínek z Kontrolní prezentace,
- informace o provedení a výsledcích testování (viz Povinné části níže).

# Final Report

# Goal of the project

TODO

## Deviations from initial requirements

TODO

## FE work distribution

TODO

### Nurdaulet's FE features

#### Screen: `Onboarding`

Onboarding screen to give an overview of the application's capabilities. It's shown only once, unless user clears out the application storage.

#### Screen: `List of trips`

A screen to show all trips that a user has. He can:

- Make an inline editaion of its name
- Open a `Trip detail` screen for his trips

#### Screen: `Trip detail`

A screen that includes 2 data representations: On a map with markers, and in form of a list. Change in one of these would result in updating the other. User can:

- Press a button to return to `List of trips` screen
- Press a button to open settings
- Use an interactive map with a route to be taken
    - When user zooms in to a place/city, map changes mode & transforms to `Place/city` screen
- Use search widget to find, browse, and add places/cities to a trip.
- Utilize editable date fields to configure when trip takes place, how many days are to be spent at each place/city, and when trip ends.
- Utilize an editable, extendable, and reorderable list of places/cities to visit

#### Screen: `Place/city`

TODO: Add intro?

- Button to return to `Trip detail` screen
- Button to open settings
- An interactive map with a route to be taken
    - When user zooms out of a place/city, map changes mode & transforms to `Trip detail` screen
    - Map can be configured to show only part of the route (Example: Instead of showing every place to visit, which might become cluttered, show only places to visit in a first day)
- Search widget to find, browse (as list or with a map), and add attractions to a trip
- Widget to add/remove place/city from the current trip
- Editable, extendable, and reorderable list of attractions ordered by days when to be visited. Example:
    - Day1: Attraction1, Attraction2
    - Day2: Attraction3
- Suggestions widget to show a customer best attractions in selected place/city

<div style="page-break-after: always;"></div>

# Feedback on the presentation

TODO

## Feedback on Nurdaulet's part

To address the feedback, which mentioned a lot of room for improvement, I've decided to implement an alternative GUI for managing trips. It adds to **interactive data manipulation** & **increases the amount of work on FE**, which were the main insufficiencies in the presentation of my work.

Alternative GUI implementation involves:
- Drag & Drop interactions
- Inline editing
- Gestures for data manipulation
- TODO: Multiselection (For documents?)
- TODO: Add more

Bellow is the feedback on presentation itself:

- **Implementation of MVC or similar architecture**: OK.
- **User interactivity/Modern interaction**: Significant room for improvement.
- **Integration of GUI components**: Not demonstrated. While not mandatory, adding this feature would improve the project's evaluation.
- **Interactive data manipulation**: Insufficient or minimal in scope; needs further development.
- **Modern frameworks and asynchronous communication**: OK.
- **Distribution of FE work**: Adjustments to task assignments are necessary, as the author does not adequately address the scope of work relevant to the ITU project.
- **Note**: No data interaction is implemented - only displaying. Interaction functionality must be added.


<div style="page-break-after: always;"></div>

# Testing of the application

TODO

## Nurdaulet's testing

**User profile**

- 18 years old
- Male
- Second year student at FEKT
- A foreigner with connections all across Europe & US

### How did the test go

TODO

### Key Takeaways

TODO
