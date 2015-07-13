var NumberUtils = require('./NumberUtils')
var expect = require('chai').expect

describe('NumberUtils', function() {
  describe('limitDecimals', function () {
    expect( NumberUtils.limitDecimals(10.0000) ).to.eql( 10.00 )
    expect( NumberUtils.limitDecimals(10.0000, 2) ).to.eql( 10.00 )
    expect( NumberUtils.limitDecimals(-10.123) ).to.eql( -10.12 )
    expect( NumberUtils.limitDecimals(-10.123, 2) ).to.eql( -10.12 )
    expect( NumberUtils.limitDecimals(-10) ).to.eql( -10 )
  })
})
