var expect = require('chai').expect
var PomodoroValidator = require('./PomodoroValidator')

describe('PomodoroValidator', function () {
  it('validates a Pomodoro', function () {
    var isValid = PomodoroValidator.isValid()
    expect( isValid ).to.be.false
  })
  it('returns errors for Pomodoro', function () {
    var errors = PomodoroValidator.validate({})
    expect(errors).to.deep.equal({
      minutes: 'required',
      type: 'required',
      startedAt: 'required',
    })
  })
})
