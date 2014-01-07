http = require 'http'
str = require 'string'
req = require 'request'
oa = require('OAuth').OAuth
qs = require 'querystring'

endpoints =
  simple: 'http://vimeo.com/api/v2/{{resource}}/{{method}}.json?page={{page}}'
  advanced:
    access: 'http://vimeo.com/oauth/access_token'
    api: 'http://vimeo.com/api/rest/v2?method=vimeo.{{resource}}.{{method}}&{{params}}'
    redirect: 'http://vimeo.com/oauth/authorize'
    request: 'http://vimeo.com/oauth/request_token'

simple =
  sendRequest: (routeParams, callback) ->
    routeParams.page ?= 1

    if typeof routeParams.page is 'function'
      callback = routeParams.page
      routeParams.page = 1

    req(
      str(endpoints.simple).template(routeParams).s,
      (err, res, body) ->
        callback JSON.parse(body)
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
      method: method
      page: page,
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

class Advanced
  constructor: (@oauth) ->

  sendRequest: (routeParams, callback) ->
    routeParams.params = qs.stringify routeParams.params
    routeParams.format ?= 'json'
    routeParams.page ?= 1

    if typeof routeParams.page is 'function'
      callback = routeParams.page
      routeParams.page = 1

    @oauth.get(
      str(endpoints.advanced.api).template(routeParams).s,
      @oauth.token,
      @oauth.secret,
      callback
    )

  activity: (method, params, callback) ->
    routeParams =
      resource: 'activity'
      method: method
      params: params

    @sendRequest routeParams, callback

module.exports =
  simple: simple

  advanced: (consumer_key, consumer_secret) ->
    new Advanced new oa(
      endpoints.advanced.request,
      endpoints.advanced.access,
      consumer_key,
      consumer_secret,
      '1.0',
      null,
      'HMAC-SHA1'
    )
