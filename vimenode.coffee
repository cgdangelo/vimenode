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
    sendRequest(
      username: username
      method: 'info'
      format: format,

      callback
    )

module.exports = vimenode
