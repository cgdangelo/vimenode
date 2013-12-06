http = require 'http'
str = require 'string'
req = require 'request'

endpoints =
  simple: 'http://vimeo.com/api/v2/{{resource}}/{{method}}.json?page={{page}}'

sendRequest = (routeParams, callback) ->
  routeParams.page ?= 1
  req(
    str(endpoints.simple).template(routeParams).s,
    callback
  )

simple =
  user: (method, username, page, callback) ->
    if typeof page isnt 'number' and typeof page is 'function'
      callback = page
      page = 1

    sendRequest
      resource: username
      method: method
      page: page,
      callback

  video: (video_id, callback) ->
    sendRequest
      resource: 'video'
      method: video_id
      page: page,
      callback

  activity: (method, username, page, callback) ->
    if typeof page isnt 'number' and typeof page is 'function'
      callback = page
      page = 1

    sendRequest
      resource: 'activity/' + username
      method: method,
      callback

  group: (method, groupname, page, callback) ->
    if typeof page isnt 'number' and typeof page is 'function'
      callback = page
      page = 1

    sendRequest
      resource: 'group/' + groupname
      method: method
      page: page,
      callback

module.exports =
  simple: simple
