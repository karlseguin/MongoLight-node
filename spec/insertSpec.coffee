helper = require('./helper')
mongolight = helper.mongolight
User = helper.user

describe 'insert', ->

  it "inserts a document", ->
    helper.withinDb ->
      User.insert {test: '123'}, (err, document) ->
        User.count {test: '123'}, (err, count) ->
          expect(count).toEqual(1)
          helper.done()