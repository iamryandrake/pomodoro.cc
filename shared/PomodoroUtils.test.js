var expect = require('chai').expect

describe('PomodoroUtils', function () {
  var PomodoroUtils = require('./PomodoroUtils')

  it('calculates the duration of a pomodoro', function () {
    var pomodoro = {
      minutes: 25,
      startedAt: Date.now()
    }
    expect( PomodoroUtils.getDuration(pomodoro) ).to.equal(25*60)
  })
  it('calculates the duration of a cancelled pomodoro', function () {
    var pomodoro = {
      minutes: 25,
      startedAt: Date.now() - 20*60*1000,
      cancelledAt: Date.now()
    }
    expect( PomodoroUtils.getDuration(pomodoro) ).to.equal(20*60)
  })
  it('calculates the duration in minutes', function () {
    var pomodoro = {
      minutes: 25,
      startedAt: Date.now()
    }
    expect( PomodoroUtils.getDurationInMinutes(pomodoro) ).to.equal(25)
  })
  it('calculates the duration in hours', function () {
    var pomodoro = {
      minutes: 25,
      startedAt: Date.now()
    }
    expect( PomodoroUtils.getDurationInHours(pomodoro) ).to.equal( 0.4 )
  })
  it('converts minutes to format in hours', function () {
    var minutes = 25
    var expectedDuration = '00:25'
    expect( PomodoroUtils.minutesToDuration(minutes) ).to.deep.equal( expectedDuration )
  })
  it('refuses to convert invalid minutes', function () {
    var minutes = -1
    var expectedHours = '00:00'
    expect( PomodoroUtils.minutesToDuration(minutes) ).to.deep.equal( expectedHours )
  })
})
