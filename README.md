# Entain Demo App - Technical Task


## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#Installation)
- [Architecture](#architecture)
- [Testing](#Testing)
- [Notes](#Notes)
- [Contact](#contact)

---

## Introduction

**Entain Demo App** is an example showing "Next to Go" races fetched and displaying a list upcoming races from an API.

---

## Installation

### Prerequisites

- **Xcode:** Version 16.0 or later.
- **iOS:** 17.6.
- **Swift:** Swift 6.0

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/tuppaware/Entain-Demo-App.git
   ```
2. **Open the Project in Xcode:**

   ```bash
   EntainDemoApp.xcodeproj
   ```
Making sure that Swift Package Manager resolves the external dependencies.
   
## Architecture

It follows the **MVVM (Model-View-ViewModel)** architecture to ensure a clean separation of concerns and maintainable codebase. This architecture facilitates scalability, testability, and ease of collaboration among developers.

### Core Architecture Components

- **Models:** Define the data structures and business logic.
- **Views:** SwiftUI views that present the UI components.
- **ViewModels:** Handle data manipulation and provide data to the views.
- **Interactors:** Manage the interaction between the ViewModels and the NetworkingManager, encapsulating the business logic and data processing.
- **DisplayModels:** Responsible for preparing and formatting data for the views, such as filtering data and managing countdown timers.

There are `Common UI` elements within the project itself, that build on reusable UI from `SharedUI` Local Package.

### Package Breakdown of Major Pieces

1. **Local Package : NetworkingManager**

    - **Purpose:** Encapsulates all networking-related functionalities, ensuring that networking logic is decoupled from the rest of the app. This promotes reusability and easier maintenance.
    - **Components:**
        - **NetworkingManager:** Class responsible for making API requests and handling responses.
        - **APIEndpoints:** Enum or struct defining all API endpoints used within the app.
        - **NetworkError:** Defines various networking errors for robust error handling.

2. **Local Package : SharedUI**

    - **Purpose:** Houses all reusable UI components, custom controls, promoting consistency and reducing code duplication across the app.
    - **Components:**
        - **CustomSegmentedControl:** A customizable segmented control for filter options.
        - **RaceItemView:** A reusable view representing a single race item.
        - **InfoStateView:** A reusable informational view used to show empty and error driven states.

3. **NextToGoInteractor**

    - **Purpose:** Serve as intermediary between the ViewModel and the NetworkingManager, encapsulating business logic and data processing. This separation ensures that ViewModels remain lightweight and focused on preparing data for the views.

4. **NextToGoViewModel**

    - **Purpose:** Manages the data and business logic specific to the `NextToGoView`, also creates and manages `NextToGoDisplayModel`. It interacts with the `NextToGoInteractor` to recieve the published races.
    - **Components:**
        - **NextToGoViewModel:** prepares data for the `NextToGoDisplayModel`.
    
5. **NextToGoDisplayModel**

    - **Purpose:** Responsible for preparing and formatting data specifically for the views. This includes tasks like filtering data and managing countdown timers to be displayed in the `NextToGoView`.
    - **Components:**
        - **NextToGoDisplayModel:** Manages the filtered list of races and their countdown timers for the `NextToGoView`.
        
### Libraries and Frameworks

- **SwiftUI:** For building the user interface.
- **Combine:** For handling asynchronous events and data binding.
- **NetworkingManager:** Custom local package for networking tasks.
- **SharedUI:** Custom local package for reusable UI components.

#### External Dependencies
- **FlagKit:** Just flag image package to improve the visual appeal of the list view.
- **SwiftLint:** Swift formating and linting
- **SwiftGen:** Provides type safe strings for localisation. 

### Data Flow

1. **Data Fetching:**
    - `NextToGoViewModel` uses `NextToGoInteractor` to fetch race data via the `NetworkingManager`.

2. **Interactor Processing:**
    - `NextToGoInteractor` communicates with the `NetworkingManager` to retrieve data and publish it to a Combine publisher.

3. **ViewModel Updates:**
    - Upon receiving data from the `NextToGoInteractor`, `NextToGoViewModel` updates its `races` property, which is observed by `NextToGoDisplayModel`.
    - `NextToGoDisplayModel` uses the `races` property to filter races and manage countdown timers.

4. **View Rendering:**
    - `NextToGoView` observe changes in the respective ViewModels and updates the UI accordingly.

5. **User Interaction:**
    - Users interact with UI components from `SharedUI` (e.g., `CustomSegmentedControl`) to filter between different race types.
    - Actions triggered by user interactions update the relevant ViewModels, leading to UI updates.

## Testing

- Several unit tests have been implemented to test the major operations of the app.
  - A basic example of a UI test is included; in a real-world application, broader test coverage would be needed to account for all functionality.
  
- Basic accessibility testing was conducted:
  - Tested with Xcode Accessibility Inspector.
  - VoiceOver was enabled and tested for basic functionality.
  
## Notes

- The display is set to always show at least 5 races, even if a category does not return 5 races in the API call.
  - This is achieved by populating the remaining slots with races from other categories.

- The API feed refreshes every 60 seconds.
  - Data persistence and restoring a filtered state on app resume were left out of scope.
  - These features could be implemented using various data persistence methods if needed.
  
- UI features include:
  - Pull to refresh.
  - Animated Loading Skeleton screen
  - Error state screen with retry button.
 
## Screen Shots 
Error State 

![Simulator Screenshot - iPhone 16 Pro - 2024-11-11 at 10 34 56 Medium](https://github.com/user-attachments/assets/3bf8e482-5ca1-4c63-944c-4e9b5d1d588d)

Loading State 

![Simulator Screenshot - iPhone 16 Pro - 2024-11-11 at 10 35 14 Medium](https://github.com/user-attachments/assets/a2a65476-2b66-4268-a8c4-5de7503e0f5b)

Races Loaded 

![Simulator Screenshot - iPhone 16 Pro - 2024-11-11 at 10 35 18 Medium](https://github.com/user-attachments/assets/1e560cc1-b142-4eb1-b036-af5f9edc627a)

## Contact

**Adam Ware** – [tuppaware@gmail.com](mailto:tuppaware@gmail.com)

---
