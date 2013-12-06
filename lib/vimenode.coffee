http = require 'http'
str = require 'string'
req = require 'request'

vimeoOptions =
  endpoint: 'http://vimeo.com/api/v2/{{username}}/{{method}}.{{format}}'
  responseFormats:
    JSON: 'json'
    JSONP: 'jsonp'
    XML: 'xml'

sendRequest = (routeParams, callback) ->
  req(
    str(vimeoOptions.endpoint).template(routeParams).s,
    callback
  )

vimenode =
  info: (username, callback, format = vimeoOptions.responseFormats.JSON) ->
    sendRequest
      username: username
      method: 'info'
      format: format,

      callback

  videos: (username, callback, format = vimeoOptions.responseFormats.JSON) ->
    sendRequest
      username: username
      method: 'videos'
      format: format,

      callback

  likes: (username, callback, format = vimeoOptions.responseFormats.JSON) ->
    sendRequest
      username: username
      method: 'likes'
      format: format,

      callback

  appears_in: (username, callback, format = vimeoOptions.responseFormats.JSON) ->
    sendRequest
      username: username
      method: 'appears_in'
      format: format,

      callback

  all_videos: (username, callback, format = vimeoOptions.responseFormats.JSON) ->
    sendRequest
      username: username
      method: 'all_videos'
      format: format,

      callback

  subscriptions: (username, callback, format = vimeoOptions.responseFormats.JSON) ->
    sendRequest
      username: username
      method: 'subscriptions'
      format: format,

      callback

  albums: (username, callback, format = vimeoOptions.responseFormats.JSON) ->
    sendRequest
      username: username
      method: 'albums'
      format: format,

      callback

  channels: (username, callback, format = vimeoOptions.responseFormats.JSON) ->
    sendRequest
      username: username
      method: 'channels'
      format: format,

      callback

  groups: (username, callback, format = vimeoOptions.responseFormats.JSON) ->
    sendRequest
      username: username
      method: 'groups'
      format: format,

      callback

module.exports = vimenode
