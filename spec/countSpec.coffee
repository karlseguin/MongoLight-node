helper = require('./helper')
mongolight = helper.mongolight
User = helper.user

describe 'count', ->

  it "counts all documents", ->
    helper.withinDb ->
      User.count (err, count) ->
        expect(err).toBeNull();
        expect(count).toEqual(2)
        helper.done()

  it "counts the specified documents", ->
    helper.withinDb ->
      User.count {name: 'vladimi'}, (err, count) ->
        expect(err).toBeNull()
        expect(count).toEqual(0)
        helper.done()