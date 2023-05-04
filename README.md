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

- login with email/password combination
- on sucessful login, Firestore DB is

- register and login with Firebase Auth
- add dogs handled by Firebase Firestore, image upload with 'image_picker'
- how should Location be handled?
  - during registration, ask for location services to be allowed
  - record ZipCode during registration
  - if location services is on, determine distance between your current location and dogs home zipcode
  - if location services is off, determine distance between your zipcode and dogs zipcode
