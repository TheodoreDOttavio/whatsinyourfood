#Whats in your Food?

This application is a work in progress sample of code that is (hopefully) more fun to review than typical blog sites, scheduling, or financial planning apps.

https://whatsinyourfood.herokuapp.com

#TODO recursive selection of questions creates an occasional crash when product datum is under 200 records (stack too deep)

As an exercise in using JSON requests
- match dissimilar datum
- generate a quiz question about the food ingredients
#TODO regex cleanup of product size/volume to reduce redundant products
#TODO Refactor to compare with local hash pairs vs repeated database lookups

As an exercise in user accounts
- runs and records progress without login by using cookies
- prompts for login on leveling up
#TODO purge users with no login if the account was built a few days ago

As an exercise in CSS for desktop vs mobile browsers
- simplified views on mobile devices
#TODO CSS for mobile is incomplete...
