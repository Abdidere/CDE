using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace CDE
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=CDE;Integrated Security=True;";
            int currentDocumentId = 1;
            
            if (Request.QueryString["docId"] != null)
            {
                int.TryParse(Request.QueryString["docId"], out currentDocumentId);
            }

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    string updateDocQuery = "UPDATE Documents SET Content = @Content, UpdatedAt = @UpdatedAt WHERE DocumentID = @DocumentID";
                    using (SqlCommand cmdUpdate = new SqlCommand(updateDocQuery, con))
                    {
                        cmdUpdate.Parameters.AddWithValue("@Content", docEditor.Value);
                        cmdUpdate.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);
                        cmdUpdate.Parameters.AddWithValue("@DocumentID", currentDocumentId);
                        cmdUpdate.ExecuteNonQuery();
                    }

                    int nextVersion = 1;
                    string getMaxVersionQuery = "SELECT ISNULL(MAX(VersionNumber), 0) FROM DocumentVersions WHERE DocumentID = @DocumentID";
                    using (SqlCommand cmdGetVersion = new SqlCommand(getMaxVersionQuery, con))
                    {
                        cmdGetVersion.Parameters.AddWithValue("@DocumentID", currentDocumentId);
                        object result = cmdGetVersion.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            nextVersion = Convert.ToInt32(result) + 1;
                        }
                    }

                    string insertVersionQuery = "INSERT INTO DocumentVersions (DocumentID, VersionNumber, Content, CreatedAt) VALUES (@DocumentID, @VersionNumber, @Content, @CreatedAt)";
                    using (SqlCommand cmdInsert = new SqlCommand(insertVersionQuery, con))
                    {
                        cmdInsert.Parameters.AddWithValue("@DocumentID", currentDocumentId);
                        cmdInsert.Parameters.AddWithValue("@VersionNumber", nextVersion);
                        cmdInsert.Parameters.AddWithValue("@Content", docEditor.Value);
                        cmdInsert.Parameters.AddWithValue("@CreatedAt", DateTime.Now);
                        cmdInsert.ExecuteNonQuery();
                    }

                    lblStatus.Text = "Save successful";
                    lblStatus.ForeColor = System.Drawing.Color.Green;
                }
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Error saving: " + ex.Message;
                lblStatus.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnVersionHistory_Click(object sender, EventArgs e)
        {
            string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=CDE;Integrated Security=True;";
            int currentDocumentId = 1; 
            
            if (Request.QueryString["docId"] != null)
            {
                int.TryParse(Request.QueryString["docId"], out currentDocumentId);
            }

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT VersionNumber, CreatedAt, Content FROM DocumentVersions WHERE DocumentID = @DocumentID ORDER BY VersionNumber DESC";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@DocumentID", currentDocumentId);
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            System.Data.DataTable dt = new System.Data.DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                gvVersions.DataSource = dt;
                                gvVersions.DataBind();
                                lblVersionStatus.Text = "";
                            }
                            else
                            {
                                gvVersions.DataSource = null;
                                gvVersions.DataBind();
                                lblVersionStatus.Text = "No versions found.";
                                lblVersionStatus.ForeColor = System.Drawing.Color.Orange;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblVersionStatus.Text = "Error: " + ex.Message;
                lblVersionStatus.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}
