`import Ember from 'ember'`
`import {_computed} from './xdash'`
`import {Macros} from 'ember-cpm'`
`import _ from 'lodash/lodash'`

{Object, computed, isPresent, A, isArray, isBlank, RSVP} = Ember
{match, apply, access} = _computed
{alias, empty, or: ifAny} = computed
{conditional, join} = Macros
{noop, isFunction, tap} = _

isPromise = (x) -> isFunction(x?.then)

TextType = /^string&(comment|note|body|description)/
DateType = /(date|moment|datetime)/
Field = Object.extend
  lookup: alias "ctx.lookup"
  action: alias "ctx.action"
  contDisplay: apply "meta.options.display", "action", (xs, x) -> A(xs).contains x
  canDisplay: ifAny "canModify", "contDisplay"
  canModify: apply "meta.options.modify", "action", (xs, x) -> A(xs).contains x
  isBasic: empty "choices"
  type: alias "meta.type"
  among: alias "meta.options.among"
  defaultValue: alias "meta.options.defaultValue"
  label: ifAny "meta.options.label", "name"
  typeName: join "type", "name", "&"
  prefix: match "typeName",
    ["string&email", -> "fa-at"],
    [TextType, -> "fa-comment-o"],
    [/^string&password/, -> "fa-lock"],
    [/^string/, -> "fa-pencil"],
    [/money$/, -> "fa-money"],
    [DateType, -> "fa-calendar"],
    [/phone$/, -> "fa-mobile-phone"]
    [_, noop]
  componentName: match "typeName",
    [/^number/, -> "em-number-field"],
    ["string&email", -> "em-email-field"],
    [/^string&password/, -> "em-password-field"],
    [/^string&timezone/, -> "em-timezone-field"],
    [TextType, -> "em-textarea-field"],
    [DateType, -> "em-datetime-field"],
    [/^string/, -> "em-text-field"],
    [_, noop]
  selectChoice: conditional "userChose", "userSelectChoice", "autoxSelectChoice"
  userChose: apply "lookup", "userSelectChoice", (lookup, name) -> isPresent lookup.component(name)
  autoxSelectChoice: "autox-select-choice"
  userSelectChoice: apply "type", (type) -> "#{type}-select-choice"
  description: alias "meta.options.description"
  presenter: alias "meta.options.presenter"
  isRelationship: alias "meta.isRelationship"

  preload: (router, store, model) ->
    RSVP.hash
      defaults: @preloadDefaults(router, store, model)
      choices: @preloadChoices(router, store, model)
    .then => @
  preloadDefaults: (router, store, model) ->
    defaultValue = @get "defaultValue"
    name = @get "name"
    if (@get("action") isnt "new") or isBlank(defaultValue)
      return RSVP.resolve(@)
    if isFunction(defaultValue)
      defaultValue = defaultValue(router, store, model)
    if isPromise(defaultValue)
      defaultValue.then (value) =>
        model.set name, value
    else
      model.set name, defaultValue
      RSVP.resolve(@)
  preloadChoices: (router, store, model) ->
    among = @get "among"
    cantModify = not @get("canModify")
    if cantModify or isBlank(among)
      return RSVP.resolve(@)
    if isFunction(among)
      among = among(router, store, model)
    if isPromise(among)
      return among.then (choices) => @set "choices", choices
    if isArray(among)
      @set "choices", among
    RSVP.resolve(@)

class SchemaUtils
  @aboutMeDefault = (factory) ->
    label: "#{factory.modelName} id"
    description: "#{factory.modelName} objects are resourceful representations of data"
    display: ["show", "index"]

  @getIdField = ({factory, ctx}) ->
    aboutMe = factory.aboutMe ? @aboutMeDefault(factory)
    meta =
      type: "string"
      options: aboutMe
    Field.create {meta, ctx, name: "id"}
  @getAttributeFields = ({factory, ctx}) ->
    tap A(), (fields) ->
      factory.eachAttribute (name, meta) ->
        fields.pushObject Field.create {name, meta, ctx}

  @getRelationshipFields = ({factory, ctx}) ->
    tap A(), (fields) ->
      factory.eachRelationship (name, meta) ->
        fields.pushObject Field.create {name, meta, ctx}
  @getFields = (params) ->
    A()
    .pushObjects [@getIdField params]
    .pushObjects @getAttributeFields params
    .pushObjects @getRelationshipFields params

`export default SchemaUtils`