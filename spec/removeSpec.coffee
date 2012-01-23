helper = require('./helper')
mongolight = helper.mongolight
User = helper.user

describe 'remove', ->

  it "removes the specified documents", ->
    helper.withinDb ->
      User.remove {name: 'leto'}, (err, x) ->
        expect(x).toBeUndefined()
        expect(err).toBeUndefined()
        User.find {}, (err, users) ->
          expect(users.length).toEqual(1)
          expect(users[0].name).toEqual('ghanima')
          helper.done()

  it "returns the number of deleted records", ->
    helper.withinDb ->
      User.remove {}, {safe: true}, (err, x) ->
        expect(err).toBeNull()
        expect(x).toEqual(2)
        helper.done()