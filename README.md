# Quarantine Workout - Udacity iOS Nanodegree Project 6
Implementation of my own final projet for iOS - Udacity Nanodegree Program.

# App Description

## Workout with us

App provides user the weekly workout challange, tracking and personal statistics. 
It uses Core Data for storage management, Firebase Auth for authentification and network request downloading of weekly challanges.

# Feature list

* Sign up - Create new user profile using email and password using Firebase Auth
* Login - Log in previously created user
* Logout - Logs out from Firebase Auth and return user back to initial screen
* Weekly Challange - Downloads current JSON challange data from API, shows list of exercises
* Workout - Tracking exercises one by one from the challange, warm-up -> exercise <-> rest -> cool-down, storing progress to Core Data
* Workout Results - Results of the previous workout
* My Results - User stats - agregated results from Core Data
* Workout Plans - List of predefined and user's workout plans
* Plan Detail - Shows exercises list of the plan

# Planned features (NOT IMPLEMENTED)

Not currently implemented - classes moved to another branch (feature/planned-features).

* Create Plan - Allows user to create it's own workout plan from scratch or from other plan and weekly challange
* Calendar - Tracks user's exercises in time
* Online sync - Sync workouts from Firebase Realtime Database, save user's stats

# Architecture

App acts as my experiment to architecture of iOS apps. It uses partially custom MVVM-C architecture. Coordinator experimentally uses Storyboard and Segue, but requires delegation from ViewControllers.

## Architecture flaws

* ViewController has reference to (one) FlowCoordinator
* FlowCoordinator is not universal - Injection for ViewController has to be done manually for some ViewControllers (UITabViewController)
* DI - ugly manual creation of ViewModel dependencies in FlowCoordinator

## Inspiration

Inspiration for architecture -

* Clean Architecture and MVVM on iOS - https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3
* Coordinators with Storyboards - http://www.apokrupto.com/blog-1/2016/3/17/coordinators-with
* iOS Coordinators: A Storyboard Aproach - https://thoughtbot.com/blog/ios-coordinators-a-storyboard-approach
* How to use Coordinator pattern in iOS apps - https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps

# Udacity

## You should not use any of my code inside your Udacity project submission
It would violate the terms of the Udacity and could lead to your ejection from the classes without any refund - read the terms carefully

https://www.udacity.com/legal/community-guidelines

## It's completely fine to use this code as inspiration and/or to help you with any issues you run into with your own project

## Good luck and have fun
