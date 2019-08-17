$(function() {
  // ------------------- DOM elements reference variables. -------------------
  var companyNameTextField = $("#company_name_text_field");
  var companySubdomainDisplayArea = $("#company_subdomain_display_area");
  var subdomainTextArea = $("#subdomain_text_area");
  var passwordTextField = $("#password_text_field");
  var passwordConfirmationTextField = $("#password_confirmation_text_field");
  var companySubdomainTextField = $("#company_subdomain_text_field");
  var showPasswordButton = $("#show_password_eye");

  // ------------------- ONLOAD scripts --------------------------------------
  companySubdomainDisplayArea.hide();
  passwordConfirmationTextField.val(passwordTextField.val());


  // ------------------- EVENT Listeners -------------------------------------
  companyNameTextField.focus(companyNameTextFieldOnFocusHandler);
  companyNameTextField.focusout(companyNameTextFieldOnFocusOutHandler);
  companyNameTextField.keyup(companyNameTextFieldOnKeyUpHandler);
  passwordTextField.keyup(passwordTextFieldOnKeyUpHandler);
  showPasswordButton.click(passwordTextFieldLabelOnClickHandler);


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


  // ------------------- HELPER Functions -------------------------------------
  function changeSubdomainValue(company_name) {
    var subdomain = generateSubdomainFromCompanyName(company_name);
    subdomainTextArea.html(subdomain);
    companySubdomainTextField.val(subdomain);
  }

  function generateSubdomainFromCompanyName(company_name) {
    company_name = company_name.replace(/\s+/g, "");
    company_name  = company_name.replace(/[^a-zA-Z0-9]/g, "");
    return company_name
  }
});