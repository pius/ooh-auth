There's Auth, there's OAuth, and there's OohAuth.
=================================================

OohAuth extends merb-auth-more with a functionally-complete approach to OAuth, turning your merb-auth applications into full OAuth providers.

OAuth at a glance:
==================

* Your users won't have to give their names and passwords to client applications
* Your users can revoke or limit access from a particular client at any time
* Your users do not have to give client applications everything they need to steal their account
* Your developer community can authenticate using a solid authentication schema endorsed by [industry giants](http://google.com)
* Resilient to both man-in-the-middle and signature replay attacks.

OohAuth gives you:
========================

* Integration with merb-auth and your application's own User model
* RESTful creation of API keys for client apps
* RESTful creation of request and access tokens to allow client apps to authenticate on behalf of users
* merb-auth strategies for both web-based and non web-based API authentication.

It depends on:
==============

* merb-slices
* merb-action-args
* merb-auth-core
* merb-auth-more
* nokogiri (tests only)
* ruby-hmac
* Erb **(we need your help to get started on HAML support)**
* datamapper **(we need your help to become ORM-agnostic)**

You should read:
================

* [Why we wrote it](http://singlecell.angryamoeba.co.uk/post/62022487/the-api-antipattern-twitter-and-the-fail-whales-new)
* [OohAuth on github](http://github.com/danski/ooh-auth)
* [OAuth 1.0 specification](http://oauth.net/core/1.0) a hefty spec document containing instructions for authenticating with OAuth apps and more.
* [securing.markdown](http://github.com/danski/ooh-auth/tree/master/securing.markdown), your guide to properly securing an application using OohAuth.
* [OohAuth's bugtracker on Tails](http://www.bugtails.com/projects/171)

