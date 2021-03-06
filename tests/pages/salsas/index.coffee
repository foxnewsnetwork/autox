`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, clickOnText, collection, fillable, text, isVisible} = PageObject

Page = PageObject.create
  visit: visitable("/salsas")
  salsas: collection
    itemScope: ".autox-collection-for a.list-group-item"
    item:
      id: text(".autox-collection-for__block", at: 0)
      goto: clickable()
  hasSalsas: -> @salsas().count > 0
  salsaCount: -> @salsas().count
  clickSalsa: -> @salsas(0).goto()

`export default Page`