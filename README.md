# Tip Calculator

This is a sample tip calculator for basic services that accept tips.

Time spent: About 7 hours spent from start to finish

Completed user stories:

 * [x] Required: User can insert bill amount and get total amount to pay, as well as just the tip amount.
 * [x] Required: User can change some settings that will persist across user sessions.
 * [x] Optional: Ability to round the total, and then calculate the proper amount to tip.
 * [x] Optional: User can use a very simple icon based approach to picking a service and happiness level to have the tip calculated.
 
Notes:

I thought about what I really would personally want out of a tip calculator, and 95% of my tip situations can be categorized into food delivery, restaurant service, or at a bar.  To make everything super simple, and only deal with entering the bill amount, I wanted to use very clear icons to select the type of venue, as well has how pleased or displeased I was with the service.

Also, rather than have the customizations be on the tip amount itself, I played around with UIPickers to create the default venue/service quality.  Most of the time I go out to eat at restaurants, so I would want that to be the default selected, but I figured it should also be something easily customizable for anybody to set.

Lastly, I always try to figure out the proper tip amount that would get to the nearest whole number, and decided to add that as a setting as well.  But, rather than just seeing the correct total and tip, I also wanted to make sure that the percentage being calculated was a fair number, so having the full calculation there was useful.

Walkthrough of all user stories:

![Video Walkthrough](http://i.imgur.com/pCDo3rn.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).
