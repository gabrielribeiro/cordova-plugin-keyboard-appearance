var exec = require('cordova/exec');

exports.setStyle = function (arg0) {
    exec(function () {}, function () {}, 'KeyboardAppearance', 'keyboardStyle', [arg0]);
};
