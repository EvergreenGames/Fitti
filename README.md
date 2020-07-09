Original App Design Project - README
===

# Fitti

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Fitti is a social app that allows users to leave posts in the real world. Users can post at their current location, and other users can view posts made around them. Fitti builds connections and organizes content that is relevant to users as they travel, and it promotes real-time and asynchronous communication about the world.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Social Networking
- **Mobile:** Fitti is built for those on the go. The mobile GPS is one of the core features of the app. Also, users can use their camera to quickly post pictures of anything they see around them.
- **Story:** This app adds a fun new layer to everyday life. Users can check posts at any location to find fun new content that is directly connected to their surroundings. Landmarks can become hubs of activity, and users are motivated to post because of this visibility.
- **Market:** This app targets average social media users. It has familiar features such as posting and feeds. Anyone who goes outside can benefit from this app.
- **Habit:** Users would be motivated to check Fitti at any new location they went to. Going to a new landmark would be a chance to discover new, interesting content. Users would also want to make posts when they encountered something relevant to the location.
- **Scope:** The core requirements around this app, in addition to basic login features, are GPS/Maps integration, and post uploading/viewing. After this, there are several places to expand, including live feeds, commenting, user profiles, and post leaderboards.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Users can create an account
* Users can login
* Users can log out
* Users can view their location on a map interface
* Users can view posts made at their location
* Users can make text posts to their current location
* Users can upload image posts with their camera

**Optional Nice-to-have Stories**

* Users can "like" posts
* Post feed can embed media
* Users can tap a post to see a detail view
* Users can browse and post comments
* Profile page where users can set a profile picture and a text bio
* Users can view an informal, live feed of chat and images for their current location
* Post viewing can be sorted in various ways, including a leaderboard of most-liked posts for an area
* Settings page
* Users can report content

### 2. Screen Archetypes

* Login
   * Users can login
* Register
   * Users can create an account
* Stream
    * Users can view their location on a map interface
    * Users can view posts made at their location
* Creation
    * Users can make text posts to their current location
    * Users can upload image posts with their camera

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Stream
* Creation

**Flow Navigation** (Screen to Screen)

* Login
   * Register
   * Stream
* Register
   * Stream
* Stream
    * Login
    * Creation
* Creation
    * Stream

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://i.imgur.com/vU7IShS.jpg" width=600>

## Schema 

### Models

#### Post
| Property     | Type         | Description |
| ------------ | ------------ | -------- |
| objectID     | String       | Unique id for the post |
| latitude     | Number       | location the post was made |
| longitude    | Number       | location the post was made |
| author       | Pointer:User | author of the post |
| title        | Text         | title of the post |
| image        | File         | image content (optional) |
| text         | Text         | text content (optional) |
| commentCount | Number       | number of comments |
| likeCount    | Number       | number of likes |
| createdAt    | DateTime     | date when the post was created |
| updatedAt    | DateTime     | date when the post was last updated |

#### Comment
| Property  | Type         | Description |
| --------- | ------------ | -------- |
| objectID  | String       | Unique id for the post |
| author    | Pointer:User | author of the comment |
| text      | String       | contents of the comment |
| createdAt | DateTime     | date when the comment was created |
| updatedAt | DateTime     | date when the comment was last updated |

### Networking
- Login
    - (GET) Authenticate user
    - (POST) Create new user
- Feed
    - (GET) Get posts for user's location
    - (POST) Add like to post
- Detail
    - (POST) Add like to post
    - (GET) Comments for post
    - (POST) Create comment
- Compose
    - (POST) Create new post
- Profile
    - (UPDATE) Update user data


[HackMD](https://hackmd.io/RKwKp1IjTAONKxIKAe_uPg)
