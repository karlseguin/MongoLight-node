lingo = require('lingo').en
objectId = require('mongodb').BSONPure.ObjectID

class MongoLight
  @configure: (@db) ->

  @extend: (entity, creator, options) ->
    entity['_mongolight'] =
      db: @db
      creator: creator
      collectionName: options?.name || lingo.pluralize(entity.name.toLowerCase())

    for key, value of this when key not in ['configure', 'extend', 'db']
      entity[key] = value unless entity[key]?

  @findById: (id, options, callback) ->
    id = Helper.toId(id)
    [options, callback] = Helper.optionalOptions(options, callback)
    return callback(null, null) unless id?
    this.findOne({_id: id}, options, callback)
    
  @findOne: (selector, options, callback) ->
    entity = this
    [options, callback] = Helper.optionalOptions(options, callback)
    this.collection (err, collection) -> 
      return callback(err, null) if err?
      collection.findOne selector, options.fields, options, (err, literal) ->
        Helper.handleSingleLiteral(err, literal, options, entity, callback)
  
  @find: (selector, options, callback) ->
    entity = this
    [options, callback] = Helper.optionalOptions(options, callback)
    this.collection (err, collection) -> 
      return callback(err, null) if err?
      collection.find selector, options.fields, options, (err, cursor) ->
        return callback(err, cursor) if err? || options['cursor']

        values = []
        cursor.each (err, literal) ->
          return callback(err, values) if err? || !literal?
          value = if options['literal'] then literal else Helper.createInstance(entity, literal)
          values.push(value)

    
  @findAndModify: (query, sort, doc, options, callback) ->
    entity = this
    [options, callback] = Helper.optionalOptions(options, callback)
    this.collection (err, collection) ->
      return callback(err, null) if err?
      collection.findAndModify query, sort, doc, options, callback, (err, literal) ->
        Helper.handleSingleLiteral(err, literal, options, entity, callback)

  @remove: (selector, options, callback) ->

  @insert: (document, options, callback) ->

  @update: (selector, document, options, callback) ->

  @count: (selector, callback) ->

  @collection: (callback) ->
    this._mongolight.db.collection this._mongolight.collectionName, callback


class Helper
  @objectIdPattern = /^[0-9a-fA-F]{24}$/

  @createInstance: (entity, literal) ->
    instance = entity._mongolight.creator()
    for key, value of literal
      instance[key] = value
    return instance

  @optionalOptions: (options, callback) ->
    if callback? then [options, callback] else [{}, options]

  @toId: (id) ->
    return null unless id?
    return id if id._bsontype == 'ObjectID'
    return if @objectIdPattern.test(id) then objectId.createFromHexString(id) else null

  @handleSingleLiteral: (err, literal, options, entity, callback) ->
    return callback(err, literal) if err? || !literal?
    value = if options['literal'] then literal else Helper.createInstance(entity, literal)
    callback(null, value)

module.exports = MongoLight