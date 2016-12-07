# Ultimaker meeting room display

We ([@jankeesvw](https://github.com/jankeesvw), [@davycardinaal](https://github.com/davycardinaal) and 
[@rowanzajkowski](https://github.com/rowanzajkowski)) created this project as part of our research sprint in december 2016.

We wanted to build a small app to prevent the interruption of meetings, you hear these questions a lot:

* Did you book this room?
* When are you leaving this room?

The application can be seen on: 
[um-meeting-room-display.herokuapp.com](https://um-meeting-room-display.herokuapp.com/).
 
## What is this?
 
 This repository contains a small Rails application that can display the current occupation of a meeting room. 
 It's connected to the Google Calendar of Ultimaker and looks like this:
 
![The application in use](docs/photo.jpg)

## FAQ:

Q: It does not show the calendars of the meeting rooms
> A: We use a personal Google Account to access the data of the calendars, we ask Google for the calendars that a user can see, 
we only get the calendar a user has in the sidebar, so make sure all the meeting rooms are visible in the sidebar of [https://calendar.google.com](calendar.google.com). 
Personal calendars will not be listed.

Q: How is this hosted?
> A: We are currently hosting this project on Heroku, which is free (for our limited use). The account we used is
`jankees@youmagine.com`.

Q: What technology is used?
> * [Ruby 2.3.1](https://www.ruby-lang.org/) 
> * [Ruby Rails](https://github.com/rails/rails)
> * [Redis](https://redis.io/)
> * [Google Auth Library for Ruby](https://github.com/google/google-auth-library-ruby)

Q: What tablet did you use?
> A: For the prototype we bought the cheapest Android tablet we could find: [Lenovo Tab 3 7 Essential 8 GB at Coolblue (€79,00)](http://www.tabletcenter.nl/product/703462/category-193340/lenovo-tab-3-7-essential-8-gb.html)

Q: Can you make feature X?
> A: We would love to make this application better, if you have any ideas please open an issue.

Q: I've found a bug.
> A: We would love to make this application better, if you found a bug please open an issue.
