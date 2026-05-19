using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CDE
{
    public partial class Signup : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void SignupButton_Click(object sender, EventArgs e)
        {
            string name = nameInput.Text.Trim();
            string email = emailInput.Text.Trim();
            string password = passwordInput.Text.Trim();

            if (string.IsNullOrEmpty(name))
            {
                ShowError("Name is required");
                return;
            }

            if (string.IsNullOrEmpty(email))
            {
                ShowError("Email is required");
                return;
            }

            if (!IsValidEmail(email))
            {
                ShowError("Please enter a valid email address");
                return;
            }

            if (string.IsNullOrEmpty(password))
            {
                ShowError("Password is required");
                return;
            }

            if (password.Length < 6)
            {
                ShowError("Password must be at least 6 characters long");
                return;
            }

            ShowSuccess("Account created successfully! Redirecting to login...");
            nameInput.Text = "";
            emailInput.Text = "";
            passwordInput.Text = "";

            System.Threading.Thread.Sleep(2000);
            Response.Redirect("Login.aspx");
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }

        private void ShowError(string message)
        {
            statusMessage.InnerText = message;
            statusMessage.Attributes["class"] = "status-message error";
        }

        private void ShowSuccess(string message)
        {
            statusMessage.InnerText = message;
            statusMessage.Attributes["class"] = "status-message success";
        }
    }
}
