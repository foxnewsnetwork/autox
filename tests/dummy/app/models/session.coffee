`import DS from 'ember-data'`
`import Ember from 'ember'`
`import {SessionStateMixin} from 'autox'`

Session = DS.Model.extend Ember.Evented, SessionStateMixin,
  
  email: DS.attr "string"
  
  password: DS.attr "string"
  
  rememberMe: DS.attr "boolean"
  
  rememberToken: DS.attr "string"
  

  
  owner: DS.belongsTo "owner", async: true
  
  user: DS.belongsTo "user", async: true
  

`export default Session`