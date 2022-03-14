# AppLectorRSS

This is a simple app that displays a RSS feed provided by The Verge.

## Architecture & Design patterns

The app was creating using the MVP (Model-View-Presenter) pattern. This pattern deals with the massive view controller (jokingly referred to as MVC sometimes) problem. This problem arises when resorting to the MVC pattern (Model-View-Controller) for complex applications in which there's a lot of logic. The resulting view controllers end up being way too big, which makes them unwieldy to work with, as well as non-SOLID. The aforementioned view controllers don't follow the SOLID principles because they don't separate concerns, to begin with.

While the app is pretty basic, we can see how using presenters instead of view controllers render the views more basic and, to some extent, dumb. At the end of the day, what we want is for our views to remain as separated from the logic as possible, so as to reuse them and not having to change them whenever the model or the logic change.

Other than that, a singleton pattern is used to manage the Core Data stack, since we want to make sure only one such object is used throughout the app.

## Features

- List of feed's entries.
- Detail of each entry.
- Open-in-browser functionality.
- Filtering by entry's title.
- Offline behavior.
- Pull-to-refresh gesture to refresh the data without killing the app.

## Appearance

### iPhone

<img src="https://user-images.githubusercontent.com/26648516/158256917-b0fa81a6-61cf-4504-bd7c-208d69af6847.png" width="400"/>
<img src="https://user-images.githubusercontent.com/26648516/158256945-e7ee2457-65f7-49f2-b871-e01c7249c701.png" width="400"/>
<img src="https://user-images.githubusercontent.com/26648516/158256954-92bbaf16-8824-468b-b627-996add6877bf.png" width="400"/>

### iPad

<img src="https://user-images.githubusercontent.com/26648516/158256931-7e48156f-1426-46fa-8d4a-0ae19c5b2845.png" width="400"/>
<img src="https://user-images.githubusercontent.com/26648516/158256956-6fb49341-9240-4815-869e-14526f22be66.png" width="400"/>
