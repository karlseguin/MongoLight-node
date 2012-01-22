mongolight = require('../src/mongolight')
mongo = require('mongodb')

db = new mongo.Db('mongolight_tests', new mongo.Server('127.0.0.1', 27017, {}))
mongolight.configure(db)

class User
  mongolight.extend @, -> new User()

  doesLike: (value) ->
    for like in @likes
      return true if value == like
    return false

module.exports.db = db
module.exports.mongolight = mongolight
module.exports.user = User
module.exports.close = -> db.close()

module.exports.withinDb = (callback) ->
  setTimeout ( ->
    db.open (err, db) ->
      db.collection 'users', (err, collection) ->
        collection.remove ->
          records = [{name: 'leto', likes: ['sand', 'spice'], age: 9001}, {name: 'ghanima', likes: ['leto'], age: 15}]
          collection.insert records, ->
            callback(records)
  ), 1
  setTimeout ( -> db.close()), 2000 #this is getting uglier and uglier
  jasmine.asyncSpecWait -> db.close()

module.exports.done = jasmine.asyncSpecDone = ->
  db.close()
  jasmine.asyncSpecWait.done = true

jasmine.asyncSpecWait = (onError) ->
  wait = jasmine.asyncSpecWait
  wait.start = new Date().getTime()
  wait.done = false
  innerWait = ->
    waits(10)
    runs ->
      if wait.start + 2000 < new Date().getTime()
        onError() if onError?
        expect('timeout waiting for spec').toBeNull()
      else if (wait.done)
        wait.done = false
      else
        innerWait()
  innerWait()
