module.exports = {
  limitDecimals: limitDecimals
}

function limitDecimals(number, decimalPlaces){
  decimalPlaces = decimalPlaces || 2
  var pow = Math.pow(10, decimalPlaces)
  return parseInt(number * pow) / pow
}
