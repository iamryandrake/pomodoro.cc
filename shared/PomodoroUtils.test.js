var expect = require('chai').expect

describe('PomodoroUtils', function () {
  var PomodoroUtils = require('./PomodoroUtils')

  it('calculates the duration of a pomodoro', function () {
    var pomodoro = {
      minutes: 25,
      startedAt: new Date
    }
    expect( PomodoroUtils.getDuration(pomodoro) ).to.equal(25*60)
  })
  it('calculates the duration of a cancelled pomodoro', function () {
    var startedAt = new Date
    startedAt.setMinutes(startedAt.getMinutes()-20)
    var pomodoro = {
      minutes: 25,
      startedAt: startedAt,
      cancelledAt: new Date
    }
    expect( PomodoroUtils.getDuration(pomodoro) ).to.equal(20*60)
  })
  it('calculates the duration in minutes', function () {
    var pomodoro = {
      minutes: 25,
      startedAt: new Date
    }
    expect( PomodoroUtils.calculateDurationInMinutes(pomodoro) ).to.equal(25)
  })
  it('calculates the duration in hours', function () {
    var pomodoro = {
      minutes: 25,
      startedAt: new Date
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
