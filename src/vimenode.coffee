str = require 'string'
req = require 'request'
oa = require('OAuth').OAuth
qs = require 'querystring'

class Simple
  endpoint: 'http://vimeo.com/api/v2/{{resource}}/{{method}}.json?page={{page}}'

  resources:
    user:
      resource: '{{id}}'

    video:
      resource: 'video'
      method: '{{id}}'

    activity:
      resource: 'activity/{{id}}'

    group:
      resource: 'group/{{id}}'

    channel:
      resource: 'channel/{{id}}'

    album:
      resource: 'album/{{id}}'

  constructor: ->
    for request_type, request_config of @resources
      @[request_type] = @createFunction(request_type)

  createFunction: (resource) ->
    (method, id, page, cb) ->
      if resource is 'video'
        cb = page
        page = id
        id = method
        method = ''

      if typeof page is 'function'
        cb = page
        page = 1

      params = id: id, method: method, page: page

      ep = str(@endpoint).template(@resources[resource]).s

      req(
        str(ep).template(params).s,
        (err, res, body) ->
          cb JSON.parse body
      )

endpoints =
  advanced:
    access: 'http://vimeo.com/oauth/access_token'
    api: 'http://vimeo.com/api/rest/v2?method=vimeo.{{resource}}.{{method}}&{{params}}'
    redirect: 'http://vimeo.com/oauth/authorize'
    request: 'http://vimeo.com/oauth/request_token'

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
  simple: new Simple

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
