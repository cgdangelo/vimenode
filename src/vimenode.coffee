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

user = (method, username, callback) ->
  sendRequest
    resource: username
    method: method,
    callback

video = (video_id, callback) ->
  sendRequest
    resource: 'video'
    method: video_id,
    callback

activity = (method, username, callback) ->
  sendRequest
    resource: 'activity/' + username
    method: method,
    callback

module.exports =
  user: user
  video: video
  activity: activity
