$(function() {
  // ------------------- DOM elements reference variables. -------------------
  var companyNameTextField                = $("#company_name_text_field");
  var companySubdomainDisplayArea         = $("#company_subdomain_display_area");
  var subdomainTextArea                   = $("#subdomain_text_area");
  var passwordTextField                   = $("#password_text_field");
  var passwordConfirmationTextField       = $("#password_confirmation_text_field");
  var companySubdomainTextField           = $("#company_subdomain_text_field");
  var showPasswordButton                  = $("#show_password_eye");
  var subdomainVerficationIconContainer   = $("#subdomain_verification_icon");


  // ------------------- SCRIPT GLOBAL variables ------------------------------
  var isSubdomainValid = false;
  var thresholdOfDelayBetweenKeys = 2000;


  // ------------------- EVENT Listeners -------------------------------------
  companyNameTextField.focus(companyNameTextFieldOnFocusHandler);
  companyNameTextField.focusout(companyNameTextFieldOnFocusOutHandler);
  companyNameTextField.keyup(companyNameTextFieldOnKeyUpHandler);
  passwordTextField.keyup(passwordTextFieldOnKeyUpHandler);
  showPasswordButton.click(passwordTextFieldLabelOnClickHandler);
  $('#sign_up_form').submit(signUpFormSubmitHandler);


  // ------------------- ONLOAD scripts --------------------------------------
  companySubdomainDisplayArea.hide();
  passwordConfirmationTextField.val(passwordTextField.val());
  changeSubdomainValue(companyNameTextField.val(), true); // Force company name to be validated on page reload.


  // ------------------- EVENT Handlers --------------------------------------
  function companyNameTextFieldOnFocusHandler() {
    companySubdomainDisplayArea.slideDown(500);
  }

  function companyNameTextFieldOnFocusOutHandler() {
    companySubdomainDisplayArea.slideUp(500);
  }

  function companyNameTextFieldOnKeyUpHandler() {
    changeSubdomainValue(companyNameTextField.val());
  }

  function passwordTextFieldOnKeyUpHandler() {
    passwordConfirmationTextField.val(passwordTextField.val());
  }

  function passwordTextFieldLabelOnClickHandler() {
    if (passwordTextField.attr('type') === "password") {
      passwordTextField.attr('type', 'text');
      $(this).removeClass('fa-eye-slash');
      $(this).addClass('fa-eye');
    } else {
      passwordTextField.attr('type', 'password');
      $(this).removeClass('fa-eye');
      $(this).addClass('fa-eye-slash');
    }
  }

  function signUpFormSubmitHandler() {
    if (!isSubdomainValid) { 
      alert("Please verify the subdomain before continuing.");
      return false; //Cancel the form submission if subdomain is not valid.
    }
    return true;
  }

  // ------------------- HELPER Functions -------------------------------------
  function changeSubdomainValue(companyName) {
    var subdomain = generateSubdomainFromCompanyName(companyName);
    subdomainTextArea.html(subdomain);
    companySubdomainTextField.val(subdomain);

    // Remove all text related classes when user types something.
    subdomainTextArea.parent().addClass('text-dark');

    // Add spinner html only when it already not present.
    if (subdomain && !subdomainVerficationIconContainer.html()) {
      subdomainVerficationIconContainer.html('<div class="lds-ellipsis"><div></div><div></div><div></div><div></div></div>');
    }

    subdomainTextArea.parent().removeClass('text-danger text-success');
    subdomainVerficationIconContainer.removeClass('fa-check-circle text-success fa-close text-danger');

    // The following syntax of jquery is for giving a delay of some milliseconds after the key is pressed. 
    // If the delay between 2 consecutive key presses increases from the amount of time we specifiy in "thresholdOfDelayBetweenKeys"
    // variable then the ajax request is sent otherwise the timer is reset.
    clearTimeout($.data(this, 'timer'));
    var delayTimer = setTimeout(function () { 
      if (subdomain) prepareAndSendRequestForSubdomainAvailability(subdomain);
      else subdomainVerficationIconContainer.html('');
    }, thresholdOfDelayBetweenKeys);
    $(this).data('timer', delayTimer);
  }

  function generateSubdomainFromCompanyName(companyName) {
    companyName = companyName.replace(/\s+/g, "");
    companyName  = companyName.replace(/[^a-zA-Z0-9]/g, "");
    return companyName;
  }

  function performAjax(url, type, data, successCallback, failureCallback, beforeSendCallback = null, completeCallback = null ) {
    $.ajax({
      async: true,
      url: url,
      type: type,
      data: data,
      dataType: 'json',
      error: failureCallback,
      success: successCallback,
      beforeSend: beforeSendCallback,
      complete: completeCallback
    });
  }

  function prepareAndSendRequestForSubdomainAvailability(subdomain) {
    // URL
    var url = '/users/sign_up/verify_subdomain_availability?subdomain=' + subdomain;

    var successCallback = function(result, status, xhr) {
      subdomainTextArea.parent().removeClass('text-dark');
      if (result.data.is_found) {
        subdomainTextArea.parent().addClass('text-danger');
        subdomainVerficationIconContainer.addClass('fa-close text-danger');

        isSubdomainValid = false;
      } else {
        subdomainTextArea.parent().addClass('text-success');
        subdomainVerficationIconContainer.addClass('fa-check-circle text-success');

        isSubdomainValid = true;
      }
    }

    var failureCallback = function(xhr, txtStatus, errorThrown) {
      alert("Subdomain verification failed due to an Error of '"+ txtStatus +"' with status code of '"+ xhr.status +"'");
    }

    var completeCallback = function (xhr, txtStatus) {
      subdomainVerficationIconContainer.html('');
    }

    performAjax(url, 'GET', {}, successCallback, failureCallback, null, completeCallback);
  }
});