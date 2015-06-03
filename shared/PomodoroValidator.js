module.exports = {
  isValid: isValid,
  validate: validate
}

function isValid(pomodoro){
  var errors = validate(pomodoro)
  if( Object.keys(errors).length > 0 )
    return false
  return true
}

function validate(pomodoro){
  var errors = {}
  if( !pomodoro ){
    errors.minutes = 'required'
    errors.type = 'required'
    errors.startedAt = 'required'
    return errors
  }
  if( !isValidType(pomodoro) ){
    errors.type = '"'+ pomodoro.type +'" is not a valid type'
  }
  if( !isValidMinutes(pomodoro) ){
    errors.minutes = '"'+ pomodoro.type +'" are not valid minutes'
  }
  if( !pomodoro.minutes ){
    errors.minutes = 'required'
  }
  if( !pomodoro.type ){
    errors.type = 'required'
  }
  if( !pomodoro.startedAt ){
    errors.startedAt = 'required'
  }
  return errors
}

function isValidType(pomodoro){
  return /(pomodoro|break)/.test(pomodoro.type)
}
function isValidMinutes(pomodoro){
  var minutes = parseInt(pomodoro.minutes,10)
  return minutes !== NaN && minutes > 0 && minutes <= 25
}
