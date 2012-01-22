helper = require('./helper')
mongolight = helper.mongolight
User = helper.user

describe 'find', ->
  it "returns an empty array if nothing is found", ->
    helper.withinDb ->
      User.find {name: 'vladimir'}, (err, users) ->
        expect(err).toBeNull()
        expect(users).toEqual([])
        helper.done()

  it "returns the cursor when requested", ->
    helper.withinDb ->
      User.find {name: 'vladimir'}, {cursor: true}, (err, cursor) ->
        expect(err).toBeNull()
        cursor.toArray (err, users) ->
          expect(users).toEqual([])
          helper.done()

  it "returns literal objects", ->
    helper.withinDb ->
      User.find {}, {literal: true}, (err, users) ->
        Helper.assertLeto(users[0], false)
        Helper.assertGhanima(users[1], false)
        helper.done()

  it "returns literal objects with fields", ->
    helper.withinDb ->
      User.find {}, {literal: true, fields: {name: true, _id: false}}, (err, users) ->
        expect(users[0]).toEqual({name: 'leto'})
        helper.done()

  it "returns class instances", ->
    helper.withinDb ->
      User.find {}, (err, users) ->
        Helper.assertLeto(users[0], true)
        Helper.assertGhanima(users[1], true)
        helper.done()
  
  it "returns a single instance", ->
    helper.withinDb ->
      User.findOne {name: 'ghanima'}, (err, user) ->
        Helper.assertGhanima(user, true)
        helper.done()

  it "returns a single literal", ->
    helper.withinDb ->
      User.findOne {age: 9001}, {literal: true}, (err, user) ->
        Helper.assertLeto(user, false)
        helper.done()
    
  it "returns a single null", ->
    helper.withinDb ->
      User.findOne {age: 9002}, {literal: true}, (err, user) ->
        expect(err).toBeNull()
        expect(user).toBeNull()
        helper.done()

  it "returns null for invalid id", ->
    helper.withinDb ->
      User.findById "123", (err, user) ->
        expect(err).toBeNull()
        expect(user).toBeNull()
        helper.done()

  it "returns the found user by id", ->
    helper.withinDb (inserts) ->
      User.findById inserts[0]._id, (err, user) ->
        Helper.assertLeto(user, true)
        helper.done()


  it "returns the found user by string id", ->
    helper.withinDb (inserts) ->
      User.findById inserts[1]._id.toString(), {literal: true}, (err, user) ->
        Helper.assertGhanima(user, false)
        helper.done()

  it "finds and modified", ->
    helper.withinDb (inserts) ->
      User.findAndModify {age: {$lt: 10000}}, [['age', 1]], {messed: true}, {literal: true}, (err, user) ->
        Helper.assertGhanima(user)
        User.findById inserts[1]._id, (err, user) ->
          expect(user._id).toEqual(inserts[1]._id)
          expect(user.messed).toEqual(true)
          helper.done()


        
class Helper
  @assertLeto: (user, asObject) ->
    expect(user.name).toEqual('leto')
    expect(user.age).toEqual(9001)
    expect(user.likes).toEqual(['sand', 'spice'])
    expect(user.doesLike('spice')).toEqual(true) if asObject

  @assertGhanima: (user, asObject) ->
    expect(user.name).toEqual('ghanima')
    expect(user.age).toEqual(15)
    expect(user.likes).toEqual(['leto'])
    expect(user.doesLike('sand')).toEqual(false) if asObject
