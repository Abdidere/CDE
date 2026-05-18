using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CDE
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void LoginButton_Click(object sender, EventArgs e)
        {
            string email = emailInput.Text.Trim();
            string password = passwordInput.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ShowError("Please enter both email and password");
                return;
            }

            if (!IsValidEmail(email))
            {
                ShowError("Please enter a valid email address");
                return;
            }

            Response.Redirect("Default.aspx");
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
            errorMessage.InnerText = message;
            errorMessage.Attributes["class"] = "error-message active";
        }
    }
}
