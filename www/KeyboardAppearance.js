var exec = require('cordova/exec');

exports.setKeyboardAppearance = function (arg0) {
    exec(function () {}, function () {}, 'KeyboardAppearance', 'setKeyboardAppearance', [arg0]);
};
