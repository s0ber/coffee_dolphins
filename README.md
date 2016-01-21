# AStreams Architecture

After some time of working with single-page applications, we've found out, that REST API is not the most effective way of communicating with server.

So, welcome AStream. AStream is a simple architecture for building complex API's. It helps to solve following problems:

- inefficient queries
- access permissions
- included resources requests
- filtering resources based on the access rights

## The Initial Flow

AStream API allows you to fetch more than one type of resources by one request. It also allows to compose different resources. Actually, why do we have "Actions" part in the title? Idea is like this — interface is a wrapper for some business actions. It is not about resources, it is about actions. And different actions can provide different required data. You can take a look at the interface and split it into actions. There are actions for reading and updating system state.

"Streams" part of the title says literally, that actions data can be represented as a stream. And we can compose such streams! It means, that one action response can be a request for another question. It allows us to have less DB requests, and it allows us to pass data from one action to another.

## Base Action Example

Okay, let's go from very simple examples to more complicated. Let's say we have a resource in a database. And we want to fetch it and render. We can request it like this:

```
$.getJSON('/api', {get: 'current_user#show'}})
```

As you see, our application will have the only endpoint (`/api`), and we will request all data from this endpoint. We are specifying get action here. And we see that this is `show` action from `current_user` namespace. Literally we'll request data for the current user.