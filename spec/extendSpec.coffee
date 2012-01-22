helper = require('./helper')
mongolight = helper.mongolight

describe 'extend', ->

  it "uses the specified name", ->
    test = class Test
      mongolight.extend(this, {name: 'simple_tests'})
    expect(test._mongolight.collectionName).toEqual('simple_tests')

  it "uses infers the name", ->
    test = class Test
      mongolight.extend(this)
    expect(test._mongolight.collectionName).toEqual('tests')

