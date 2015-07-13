var moment = require('moment')
module.exports = {
  getDuration: getDuration,
  calculateDurationInMinutes: calculateDurationInMinutes,
  getDurationInHours: getDurationInHours,
  minutesToDuration: minutesToDuration
}

function getDuration(pomodoro){
  if( !pomodoro || pomodoro.startedAt === undefined || pomodoro.minutes === undefined ) {
    return 0
  }
  if( !pomodoro.cancelledAt ){
    return pomodoro.minutes * 60
  }
  if( pomodoro.cancelledAt ) {
    var cancelledAt = moment(pomodoro.cancelledAt).unix()
    var startedAt = moment(pomodoro.startedAt).unix()
    return parseInt(cancelledAt - startedAt, 10)
  }
  return 0
}


function calculateDurationInMinutes(pomodoro){
  return parseInt(getDuration(pomodoro)/60, 10)
}
function getDurationInHours(pomodoro){
  return trimDecimals(calculateDurationInMinutes(pomodoro)/60, 1)
}

function minutesToDuration(minutes){
  if( minutes < 0 || !isInteger(minutes) ){
    return '00:00'
  }

  var convertedHours = 0
  var convertedMinutes = 0

  var remainingMinutes = minutes
  while(remainingMinutes - 60 >= 0){
    convertedHours++
    remainingMinutes -= 60
  }
  convertedMinutes = remainingMinutes

  return padToTimeFormat(convertedHours)+':'+padToTimeFormat(convertedMinutes)
}

function trimDecimals(number,numberOfDecimals){
  var decimals = Math.pow(10,numberOfDecimals)
  return parseInt(number*decimals,10)/decimals
}

function isInteger(number){
  return parseInt(number, 10) === number
}

function padToTimeFormat(number){
    return (number<10) ? ('0'+number) : (''+number)
}
