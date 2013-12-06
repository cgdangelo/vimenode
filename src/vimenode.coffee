http = require 'http'
str = require 'string'
req = require 'request'

endpoints =
  simple: 'http://vimeo.com/api/v2/{{resource}}/{{method}}.json'

sendRequest = (routeParams, callback) ->
  req(
    str(endpoints.simple).template(routeParams).s,
    callback
  )

user =
  info: (username, callback) ->
    sendRequest
      resource: 'username'
      method: 'info'
      callback

  videos: (username, callback) ->
    sendRequest
      resource: 'username'
      method: 'videos'
      callback

  likes: (username, callback) ->
    sendRequest
      resource: 'username'
      method: 'likes'
      callback

  appears_in: (username, callback) ->
    sendRequest
      resource: 'username'
      method: 'appears_in'
      callback

  all_videos: (username, callback) ->
    sendRequest
      resource: 'username'
      method: 'all_videos'
      callback

  subscriptions: (username, callback) ->
    sendRequest
      resource: 'username'
      method: 'subscriptions'
      callback

  albums: (username, callback) ->
    sendRequest
      resource: 'username'
      method: 'albums'
      callback

  channels: (username, callback) ->
    sendRequest
      resource: 'username'
      method: 'channels'
      callback

  groups: (username, callback) ->
    sendRequest
      resource: 'username'
      method: 'groups'
      callback

video = (video_id, callback) ->
  sendRequest
    resource: 'video'
    method: video_id,
    callback

module.exports =
  user: user
  video: video
