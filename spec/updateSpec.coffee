helper = require('./helper')
mongolight = helper.mongolight
User = helper.user

describe 'update', ->

  it "updates the document", ->
    helper.withinDb ->
      User.update {name: 'leto'}, {$set: {name: 'leto 2'}}, (err, x) ->
        User.count {name: 'leto 2'}, (err, count) ->
          expect(count).toEqual(1)
          helper.done()

  it "returns the number of updated records", ->
    helper.withinDb ->
      User.update {}, {$set: {family: 'atreides'}}, {multi: true, safe: true}, (err, count) ->
        expect(count).toEqual(2)
        helper.done()