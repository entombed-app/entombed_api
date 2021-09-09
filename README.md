# Elegy-Api [![entombed-app](https://circleci.com/gh/entombed-app/entombed_api.svg?style=svg)]

## Our Devs
Back-End:

* Jermaine Braumuller [linkedin](https://www.linkedin.com/in/j-braum) [github](https://github.com/Jaybraum/)
* Noah Zinter [linkedin](https://www.linkedin.com/in/noahzinter) [github](https://github.com/noahzinter/)


Front-End:
Â
* Taylor Galloway [linkedin](https://www.linkedin.com/in/taylor-galloway) [github](https://github.com/tylrs/)

* Ashley O'Brien [linkedin](https://www.linkedin.com/in/ashley-o-brien-30456a51) [github](https://github.com/AshleyOh-bit/)

---
### Table of Contents
- [Overview](#overview)
- [Installation](#installation)
- [Endpoints](#endpoints)
- [Users Endpoints](#users-endpoints)
- [Images Endpoints](#images-endpoints)
- [Executors Endpoints](#executors-endpoints)
- [Recipients Endpoints](#recipients-endpoints)
- [Notifications Endpoints](#notifications-endpoints)
---

## Overview

The elegy-api app is a REST API which serves the frontend elegy app. This api allows for CRUD functionality on Users and stores images associated with a user using Active Storage in combination with AWS S3 cloud storage.

This app was built using `Ruby 2.7.2` and `Rails 5.2.6`. The app is deployed on Heroku, and request can be made to the url
`https://elegy-backend.herokuapp.com/api/v1`

---
## Installation

  To run your own version of this app, clone this app and run `bundle install` to install dependencies. To link to Active Storage on AWS S3 you'll need to set up an [AWS Account](https://aws.amazon.com/), choose S3 for the storage type, then store the access_key_id and secret_key as hidden environment variables.


---

# Endpoints

## Users Endpoints
 * Create User
  ```
  POST /api/v1/users
```
  Users can be created with following params:
  ```
  {
    email: 'ex@ample.com',
    date_of_birth: '2001/02/03',
    name: 'Jane Doe',
    obituary: 'Tedious and brief',
    password: 'password123'
  }
  ```
  Note the date format `yyyy/mm/dd`

 * Get User

``` GET  /api/v1/users/:id ```

Example JSON response: 

```
{
    "data": {
        "id": "5",
        "type": "user",
        "attributes": {
            "email": "ex@ample.com",
            "name": "Elder Bobby",
            "date_of_birth": "1999-01-02",
            "obituary": "banana",
            "profile_picture_url": "http://elegy-backend.herokuapp.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBZdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--d6be02dad2998304c9557d8a2af51f84e2b1470f/william.png",
            "images_urls": [
                "http://elegy-backend.herokuapp.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBaQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--af1eaf199b0916b1856ac9d1bb367d2ad3817179/william.png",
                "http://elegy-backend.herokuapp.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBaUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--732e9658bad7bf2f8dc0fe6b5da0a77c86e8552e/william.png"
            ],
            "etd": "2119-06-22"
        },
        "relationships": {
            "executors": {
                "data": [
                    {
                        "id": "2",
                        "type": "executor"
                    }
                ]
            },
            "recipients": {
                "data": [
                    {
                        "id": "8",
                        "type": "recipient"
                    },
                    {
                        "id": "9",
                        "type": "recipient"
                    },
                    {
                        "id": "10",
                        "type": "recipient"
                    },
                    {
                        "id": "11",
                        "type": "recipient"
                    },
                    {
                        "id": "12",
                        "type": "recipient"
                    }
                ]
            }
        }
    }
}

```

* Edit User

` PATCH /api/v1/users/:id`

User params which can be edited include:

```
    email:
    date_of_birth: 
    name:
    obituary:
    password:
```
* Edit User Profile Picture

` PATCH /api/v1/users/:user_id/profile_picture`

This route is a seperate editing route for changing a user's profile picture, which is stored with ActiveStorage. To edit a user's profile picture, send

```
{ profile_picture: <uploaded_image> }
```
with no headers, and the value set to an uploaded image. Be careful not to send the image url as a string or you'll encounter an error.

---
## Images Endpoints

* Attach Image to User

`POST /api/v1/users/:user_id/images`

Same as updating a profile picture, attach images by sending
```
{
  image: <image_file>
}
```
With no headers and image set to a value of an uploaded image. Accepted image formats are `.png, .jpeg, .jpg`

* Delete Attached Image

` DELETE /api/v1/users/:user_id/images/:id`

Finding the id of the image from the front-end app is currently tricky, a future refactor will be to allow the front end app to send this delete request with a value of the url of the desired image to be deleted.

---

## Executors Endpoints

Users of the elegy app can assign executors to their account to distribute their memorial page after their passing.

* Create Executor

`POST /api/v1/users/:user_id/executors `

Executors can be created with these params:


```
{
  email: <email as a string>,
  name: <name as a string>,
  phone: <phone number as a string>
}
```

* Edit Executor

`PATCH /api/v1/users/:user_id/executors/:id`

* Delete Executor

`DELETE /api/v1/users/:user_id/executors/:id`

---

## Recipients Endpoints

Users can also curate a list of people who will see their memorial page upon death. These will be notified using the api's mailer templates.

* Create Recipient

` POST /api/v1/users/:user_id/recipients `

Recipients are created with just a name and email, accepting these params:

```
{
  email: <email as a string>,
  name: <name as a string>
}
```

* Edit Recipient

` PATCH /api/v1/users/:user_id/recipients/:id `

* Delete Recipient

` DELETE /api/v1/users/:user_id/recipients/:id `

---

## Notifications Endpoints

An executor should be able to click a button and notify any of a user's attached recipients of the user's death. This route goes to a create action for a mailer

* Create Notification

```
POST /api/v1/users/:user_id/email
```

This email endpoint accepts the following params:

```
{
  user_url: <user memorial profile url>
}
```

The user's id is sufficient to populate the list of recipients, but the url of the desired page must be included in the params. 