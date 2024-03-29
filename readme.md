# THIS IS NOT DONE
This is about 50% complete. No package nor the /lib/*.js files will be available until it is

# MongoLight for node.js
A lightweight MongoDB mapper for node.js

## Why
Creates the thinnest possible layer between the MongoDB driver and your objects.

## Configuration
First you have to configure mongolight with your MongoDB connection:

	mongo = require('mongodb')
	mongolight = require('mongolight')
	new mongo.Db('DB_NAME', new mongo.Server('127.0.0.1', 27017, {})).open (err, db) ->
		mongolight.configure(db)
		# your main application loop here

Define your classes:

	class User
		mongolight.extend @

An optional 2nd options parameter can be specified:

	class User
		mongolight.extend @, {name: 'people'}

The supported values for options are:
  
* name: what to name this collection (by default it'll be inferred from the class name)

## Usage
The mapper tries to stay as close to the underlying mongodb driver as possible. When you expect an object to be returned, you can specify `{literal: true}` in the options parameter to get back an object literal rather than an instance of the object.

Also, the `find` method has been simplified. There are two options (versus 7):

	User.find {...}, (err, users) ->
	# or
	User.find {...}, {options}, (err, users) ->

Use the options to specify specific fields to retrieve (as well as other options, like `sort` and `limit`). For example: `{fields: {...}, literal: true.}`

By default `find` will load all found documents into memory. To retrieve the MongoDB cursor instead, specify `{cursor: true}` in the options.