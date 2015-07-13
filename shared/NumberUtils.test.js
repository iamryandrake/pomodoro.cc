var NumberUtils = require('./NumberUtils')
var expect = require('chai').expect

describe('NumberUtils', function() {
  describe('limitDecimals', function () {
    expect( NumberUtils.limitDecimals(10.0000) ).to.eql( 10.00 )
  })
})
