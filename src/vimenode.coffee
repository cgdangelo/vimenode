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
          cb if err then err else JSON.parse body
      )

class Advanced
  endpoints:
    access: 'https://vimeo.com/oauth/access_token'
    api: 'https://vimeo.com/api/rest/v2?method=vimeo.{{resource}}.{{method}}&{{params}}'
    redirect: 'https://vimeo.com/oauth/authorize?oauth_token={{token}}&permission={{permission}}'
    request: 'https://vimeo.com/oauth/request_token'

  resources: ['activity', 'albums', 'categories', 'channels', 'contacts',
              'groups', 'groups.forums', 'oauth', 'people', 'test', 'videos',
              'videos.comments', 'videos.embed', 'videos.upload']

  constructor: (consumer_key, consumer_secret) ->
    @consumer = new oa(
      @endpoints.request,
      @endpoints.access,
      consumer_key,
      consumer_secret,
      '1.0',
      null,
      'HMAC-SHA1'
    )

    for request_type in @resources
      @[request_type] = @createFunction(request_type)

  createFunction: (resource) ->
    (method, params, cb) ->
      params.format ?= 'json'
      params.page ?= 1

      routeParams =
        method: method
        resource: resource
        params: qs.stringify params

      @consumer.get(
        str(@endpoints.api).template(routeParams).s,
        @consumer.token,
        @consumer.secret,
        (err, body, res) ->
          cb if err then err else JSON.parse body
      )

module.exports =
  simple: new Simple

  advanced: (consumer_key, consumer_secret) -> new Advanced consumer_key, consumer_secret
