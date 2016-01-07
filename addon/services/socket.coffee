`import Ember from 'ember'`

{Service, Evented, inject, RSVP} = Ember

errMsg = """
You tried to create a channel synchronously, 
but the socket hasn't connected yet.

This is likely because you called the `channelSync`
method before the user has successfully logged in his account.
"""
SocketService = Service.extend Evented,
  session: inject.service("session")
  state: "disconnected"
  init: ->
    @_super arguments...
    @set "deferredSocket", RSVP.defer()
  channelSync: (topic) ->
    if @socket?
      @socket.channel topic
    else
      throw new Error errMsg
  channel: (topic) ->
    @get "deferredSocket.promise"
    .then (socket) ->
      socket.channel topic

  onConnect: Ember.on "connect", ->
    @set "state", "connected"
    @get("deferredSocket").resolve(@socket)

  onDisconnect: Ember.on "disconnect", ->
    @set "state", "disconnected"

  onError: Ember.on "error", ->
    if @get("state") is "disconnected"
      @get("deferredSocket").reject(socket)
    else
      @set "state", "error"
    
  instanceInit: (Socket, socketNamespace) ->
    session = @get "session"
    session.on "logout", =>
      @socket?.disconnect => @trigger "disconnect"
    session.on "login", =>
      id = session.get("id")
      @socket = new Socket socketNamespace, params: user_id: id
      @socket.connect()
      @socket.onOpen => @trigger "connect"
      @socket.onClose => @trigger "disconnect"
      @socket.onError => @trigger "error"

`export default SocketService`
