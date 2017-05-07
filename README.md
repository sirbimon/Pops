## Pops: Gamifying Pomodoro and Productivity!

This project was created with the goal to help users manage phone addiction and later we decided to do that by refreshing the pomodoro technique. We created 3 characters each with unique personalities and different features to make being productive fun.


## Motivation

This project was the final project in our time at flatiron school. We had 3 weeks to create an app from idea to submitting to the appstore.

## Project overview

# Design decisions

The main design aspect of the app was the user not touching his/her phone during the productive session, using that main idea our group came up with several design solutions to implement and reinforce this idea that the user must leave the phone alone. These are the first design decisions we made:
  1.  The user chooses how long they want to be productive.
  1.  The user enters a productive session, in this session, the user is encouraged not to use the phone.
  2.  To reinforce the idea, the user is given points(or as we called them, props) for every second the user is in the productive session.
  3.  When the productive session ends, the user enters a break session.
  4.  After the break session has ended, the user enters another productive session

The decisions listed above lended to new sets of problems and user cases that we needed to solve, how can we make not only putting down the phone rewarding mentally by giving the user points, but also we needed a way to make the user put down the phone and mentally signify that the user needs to leave the phone and not use it for a period of time. We came up with the solution to force the user to put the phone screen side down, so it signifies the start of productive time, and also we will not award points if the users phone is face up. If the user picks up the phone, we deduct props from the users total props.

# Problems and Solutions
The first problem we ran into was regarding the appearance of the app, we wanted to create uniquely designed views. Because storyboards were fidgety if we devise from the apple template, to avoid future headaches, we forgo using storyboards and interface builder and created all the UI elements and View Controllers progammatically. This provided the solution to unique UI but this also led to problems with the navigation of the app, we decided to do a pseudo navigation controller using one main view controller to handle presenting the different view controllers. That just leaves the coding of the UI, and managing all the custom views and view controllers. That consolidates the navigation and leaves room for future improvements.

We wanted to separate the logic and the views, so we adopted the MVVM design pattern, logic was contained inside a ViewModel file that was instantiated by the view controller, the ViewModel then talks to the VC to display data that needs to be displayed using delegates and protocols, the delegates itself were declared weak so it did not increased the reference count and evaded the possibilities of memory leaks.

The next problem was to create the timers and covering user scenarios where the user exits the app, what would happen to the timers. Creating and implementing the timers was simple enough, we had countdown counters in the corresponding view controllers and we also created an overarching session timer that persisted as long as a user session was active. for the persistent timers, we devised logic that saved the time when the app enters background, and when the app enters the foreground again, we used that data to reduce the timer counter based on the time that passed while the user was out of the app.

The main feature of the app, the flipping of the phone physically needed a bit of trial and error, we tried to access the camera, but Jeff came up with the idea that using the accelerometer to gauge where gravity was pulling was the way to go.

# Characters

Creating the characters were the core of the app's "charm", we decided that pops needed two more friends in the quest to bring joy into productivity.
