`import Ember from 'ember'`

IndexController = Ember.Controller.extend
  session: Ember.inject.service("session")

`export default IndexController`