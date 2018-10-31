**On The Map**

**Introduction**

On The Map allows Udacity Nanodegree students to post their locations and a link to a parse server.  The app then reads the posts on the parse server and displays the posts on a map as pins and as entries in a table view.  

**Running On The Map**

Running On The Map can be accomplished by opening the OnTheMap.xcodeproj in Xcode and building and running the project.  

**Using On The Map**

When the app first opens the user will see a login screen where the user can enter their username and password.  Once the user's credentials have been entered the user can login in by pressing 'Login'.  

**MapView**

Once the user has logged in the MapView will be displayed.  The MapView displays pins.  These pins are locations posted by users.  If the user taps one of these pins then a callout bubble is displayed next to the pin.  The callout bubble displays the first and last name of the person who posted the pin as well as the link posted by the user.  

**Tab Bar**

At the bottom of the screen the user will see two tabs.  The first tab is a map icon that has the word 'Map' below it.  The second icon is a list icon that has the word 'List' below it.  If the user taps the 'Map' icon the map view is displayed.  If the 'List' icon is tapped then the list view is displayed.  

**List View**

The list view displays posts by Udacity students in a list.  The list view displays the first and last name of the student who posted each entry.  If an entry is tapped then a browser window opens and the link posted by the student is opened in the browser window.  

**Add Post**

In the top left corner of the app is a button for adding a post.  When pressed the 'Add Location' screen is presented.  The 'Add Location' screen has a text box for the user's location and a text box for a link to be posted by the user.  The 'Add Location' screen also has a submit button and a cancel button.  If the cancel button is pressed the user is taken back to the Map View.  If the submit button is pressed, the user is taken to the 'Verify Location' screen.  

The 'Verify Location' screen displays a map with the location of the pin that will be added.  This screen allows a user to ensure that the app correctly geocoded the location they entered in the location text box on the 'Add Location' screen.  If the user presses 'cancel' the post is cancelled and the user is taken back to the 'Map View' if the user presses submit, then the post is submitted and posted to the parse server.  

**Overwriting a Post**

If the user presses the 'add post' button and the user has already posted a location, an alert controller displays an alert message.  The alert message informs the user that the user has previously posted a location and that the new post will overwrite the user's previous post.  

**Refresh**

In the top bar of the application is a refresh button.  If the user presses this button the app will retrieve an updated list of posts from the parse server.  

**Logout**

If the user presses the logout button in the top right of the app the user will be logged out and taken back to the sign in screen.  

**Conclusion**

Thanks for trying out OnTheMap.  I hope you enjoy the app.
