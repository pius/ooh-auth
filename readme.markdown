Authentication antipattern got you down?
========================================

Full-fat Auth extends merb-auth-more with a modern, functionally-complete authentication strategy which includes restful login/logout, resource-based secure password resets, registration and API key allocation for third-party client applications, and revokable token-based API authentication for both web-based and non web-based applications.

Full-fat auth gives you:
========================

* RESTful login and logout, totally compatible with merb-auth strategies
* RESTful password resets
* Integration with merb-auth and your application's own User model
* RESTful creation of API keys for client apps
* RESTful creation of frobs/tokens to allow client apps to authenticate on behalf of users
* merb-auth strategies for both web-based and non web-based API authentication.

It depends on:
==============

* merb-slices
* merb-action-args
* merb-auth-core
* merb-auth-more
* nokogiri (tests only)
* Erb **(we need your help to get started on HAML support)**
* datamapper **(we need your help to become ORM-agnostic)**

You should read:
================

* [Full-fat auth on github](http://github.com/danski/merb-auth-slice-fullfat)
* [installing.markdown](http://github.com/danski/merb-auth-slice-fullfat/tree/master/installing.markdown), your guide to installing and configuring Full-fat Auth.
* [authenticating.markdown](http://github.com/danski/merb-auth-slice-fullfat/tree/master/authenticating.markdown), a third-party developer's guide to authenticating using the stragies provided by this slice. This is written in a form suitable for parsing to HTML and including in your own application's public documentation.
* [Full-fat auth's bugtracker on Tails](http://www.bugtails.com/projects/171)

