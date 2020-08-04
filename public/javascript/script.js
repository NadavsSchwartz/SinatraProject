// spinner icon after email input
function email(destroyFeedback) {
    setTimeout(function() { destroyFeedback(true); }, 1500);
}

// initialize stepper
const loginStepper = document.querySelector('.stepper');
const stepper = new MStepper(loginStepper);