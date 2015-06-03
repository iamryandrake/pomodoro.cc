var expect = require('chai').expect
var PomodoroValidator = require('./PomodoroValidator')

describe('PomodoroValidator', function () {
  it('validates a Pomodoro', function () {
    var isValid = PomodoroValidator.isValid()
    expect( isValid ).to.be.false
  })

  it('returns errors for empty Pomodoro', function () {
    var errors = PomodoroValidator.validate({})
    expect(errors).to.deep.equal({
      minutes: 'required',
      type: 'required',
      startedAt: 'required',
    })
  })

  it('returns errors for invalid Pomodoro', function () {
    var errors = PomodoroValidator.validate({
      type: 'this_is_invalid'
    })
    expect(errors).to.deep.equal({
      type: '"this_is_invalid" is not valid'
    })
  })

})
