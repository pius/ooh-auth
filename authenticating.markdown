Authenticating with the API
===========================

Lawyer's terms:
* The "host" application is your application, which has the API and data being accessed.
* The "client" application is a third-party application, which is going to make calls to the host app on behalf of a certain user.
* The "user" is someone who has login credentials for the host application.
* The "API" is a set of URLs provided by the host app which can be used to read or alter data and return the results in a machine-readable format.  

A popular (notorious?) API antipattern is just giving clients your username and password. This pattern is crap because:

1.  Trust issues. Your username and password can be used to change your password and lock you out of your account.
2.  Maintenance issues. If you change your password (and you DO regularly change your password, right?) then all your desktop and web-based client software breaks and your delicately-prepared ecosystem of api clients comes crumbling down around your ears.
3.  Control issues. There is no way for me to give limited access to one Twitter client, while giving full access to my account to another.
  
So we don't use that pattern. Because it is crap. Instead, we build a more secure, flexible pattern that doesn't cause these problems.

1. API Keys
===========
First up, every client application should be pre-register with the host application in order to receive an API key. This is an automated process and no, if you're distributing desktop software you don't need an API key for each individual installation of your app - you just need one for each app you develop.

How to get an API key for your application
------------------------------------------
#TODO

2. Authenticating for a user
============================
Alright, so you've written an awesome mobile Portionator app called Mobilator. User 
downloads it. You need to authenticate