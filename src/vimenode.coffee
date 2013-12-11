http = require 'http'
str = require 'string'
req = require 'request'

endpoints =
  simple: 'http://vimeo.com/api/v2/{{resource}}/{{method}}.json?page={{page}}'

simple =
  sendRequest: (routeParams, callback) ->
    routeParams.page ?= 1

    if typeof routeParams.page is 'function'
      callback = routeParams.page
      routeParams.page = 1

    req(
      str(endpoints.simple).template(routeParams).s,
      callback
    )

  user: (method, username, page, callback) ->
    @sendRequest
      resource: username
      method: method
      page: page,
      callback

  video: (video_id, callback) ->
    @sendRequest
      resource: 'video'
      method: video_id
      page: page,
      callback

  activity: (method, username, page, callback) ->
    @sendRequest
      resource: 'activity/' + username
      method: method,
      callback

  group: (method, groupname, page, callback) ->
    @sendRequest
      resource: 'group/' + groupname
      method: method
      page: page,
      callback

  channel: (method, channelname, page, callback) ->
    @sendRequest
      resource: 'channel/' + channelname
      method: method
      page: page,
      callback

  album: (method, album_id, page, callback) ->
    @sendRequest
      resource: 'album/' + album_id
      method: method
      page: page,
      callback

module.exports =
  simple: simple
