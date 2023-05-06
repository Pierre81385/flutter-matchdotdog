# matchdotdog

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# dependencies

- firebase_core: ^2.4.1
- firebase_auth: ^4.2.5
- cloud_firestore: ^4.3.1
- firebase_storage: ^11.0.10
- image_picker: ^0.8.6+1
- geolocator: ^9.0.2
- geocoding: ^2.1.0

# summary

SNIFFER

Register and login, add a dog or two to your profile, and find a playmate!

Find a playmate for your puppy near you, and chat with friends to make the arrangments.

# notes

## login/register page

- the \_currentOwner object is created here

- enter information about your dog 1 form at a time

  - all information is saved to a new Dog object

  * UI needs to convert slider values to custom values
  * image upload needs processing animation for image upload await
  * registration form needs a Dog description field
  * dog summary needs UI
  * validate all fields
  * needs a forgot password option
  * if submit fails, needs error message

  - on submit the dog object is complete and sent to FirebaseFirestore
  - ---> move user to 'home' screen

- enter email address and password for login

* needs gmail option at the very least
  - on submit processing animation begins, Auth is verified by FirebaseAuth
  - get current position function runs
  - on FirebaseAuth success, owner doc retrieved from FirebaseFirestore and is converted to new Owner object
  - new Owner object is updated with current long and lat values
  - FirebaseFirestore doc is updated with current long and lat values to save
  * needs user facing error message if owner document doesn't exist!
  - processing animation ends
  - ---> move user to 'redirect' check

## Redirect page

- requires \_currentOwner object

- a check here to verify the user has registered at least 1 dog is performed by getting all dogs where owner is equal to the dogs owner value
- if this returns nothing, ---> move user to 'Register Dog' screen
- if this returns at least 1 dog, ---> move user to 'Home' screen

## Home Page

- requires \_currentOwner object

- this page is primarily a viewer for
  - dog list: a list of all your dogs
  - map view: a map showing other dogs nearby
  - chat view: a list of all current chats
