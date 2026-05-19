using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace CDE
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["docId"] != null)
                {
                    int docId;
                    if (int.TryParse(Request.QueryString["docId"], out docId))
                    {
                        LoadDocument(docId);
                    }
                }
            }
        }

        private void LoadDocument(int docId)
        {
            string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=CDE;Integrated Security=True;";
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT Title, Content FROM Documents WHERE DocumentID = @DocumentID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@DocumentID", docId);
                        con.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                docTitle.InnerText = reader["Title"].ToString();
                                docEditor.Value = reader["Content"].ToString();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Error loading document: " + ex.Message;
                lblStatus.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            txtSaveTitle.Text = docTitle.InnerText;
            lblSaveModalStatus.Text = "";
            saveFilesModal.Style["display"] = "flex";
        }

        protected void btnConfirmSave_Click(object sender, EventArgs e)
        {
            string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=CDE;Integrated Security=True;";
            int currentDocumentId = 0;
            
            if (Request.QueryString["docId"] != null)
            {
                int.TryParse(Request.QueryString["docId"], out currentDocumentId);
            }

            string newTitle = txtSaveTitle.Text.Trim();
            if (string.IsNullOrEmpty(newTitle))
            {
                lblSaveModalStatus.Text = "Document name cannot be empty.";
                saveFilesModal.Style["display"] = "flex";
                return;
            }

            int ownerId = 1;
            if (Session["UserID"] != null)
            {
                ownerId = Convert.ToInt32(Session["UserID"]);
            }

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    if (currentDocumentId > 0)
                    {
                        string updateDocQuery = "UPDATE Documents SET Title = @Title, Content = @Content, UpdatedAt = @UpdatedAt WHERE DocumentID = @DocumentID";
                        using (SqlCommand cmdUpdate = new SqlCommand(updateDocQuery, con))
                        {
                            cmdUpdate.Parameters.AddWithValue("@Title", newTitle);
                            cmdUpdate.Parameters.AddWithValue("@Content", docEditor.Value);
                            cmdUpdate.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);
                            cmdUpdate.Parameters.AddWithValue("@DocumentID", currentDocumentId);
                            cmdUpdate.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string insertDocQuery = "INSERT INTO Documents (OwnerID, Title, Content, CreatedAt, UpdatedAt) VALUES (@OwnerID, @Title, @Content, @CreatedAt, @UpdatedAt); SELECT SCOPE_IDENTITY();";
                        using (SqlCommand cmdInsert = new SqlCommand(insertDocQuery, con))
                        {
                            cmdInsert.Parameters.AddWithValue("@OwnerID", ownerId);
                            cmdInsert.Parameters.AddWithValue("@Title", newTitle);
                            cmdInsert.Parameters.AddWithValue("@Content", docEditor.Value);
                            cmdInsert.Parameters.AddWithValue("@CreatedAt", DateTime.Now);
                            cmdInsert.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);
                            currentDocumentId = Convert.ToInt32(cmdInsert.ExecuteScalar());
                        }
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
                    using (SqlCommand cmdInsertVersion = new SqlCommand(insertVersionQuery, con))
                    {
                        cmdInsertVersion.Parameters.AddWithValue("@DocumentID", currentDocumentId);
                        cmdInsertVersion.Parameters.AddWithValue("@VersionNumber", nextVersion);
                        cmdInsertVersion.Parameters.AddWithValue("@Content", docEditor.Value);
                        cmdInsertVersion.Parameters.AddWithValue("@CreatedAt", DateTime.Now);
                        cmdInsertVersion.ExecuteNonQuery();
                    }

                    docTitle.InnerText = newTitle;
                    lblStatus.Text = "Save successful";
                    lblStatus.ForeColor = System.Drawing.Color.Green;
                    saveFilesModal.Style["display"] = "none";
                    
                    if (Request.QueryString["docId"] == null)
                    {
                        Response.Redirect("~/Default.aspx?docId=" + currentDocumentId);
                    }
                }
            }
            catch (Exception ex)
            {
                lblSaveModalStatus.Text = "Error saving: " + ex.Message;
                saveFilesModal.Style["display"] = "flex";
            }
        }

        protected void btnCancelSave_Click(object sender, EventArgs e)
        {
            saveFilesModal.Style["display"] = "none";
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

        protected void btnOpen_Click(object sender, EventArgs e)
        {
            string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=CDE;Integrated Security=True;";
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT DocumentID, Title, UpdatedAt FROM Documents ORDER BY UpdatedAt DESC";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            System.Data.DataTable dt = new System.Data.DataTable();
                            da.Fill(dt);
                            gvDocuments.DataSource = dt;
                            gvDocuments.DataBind();
                            
                            openFilesModal.Style["display"] = "flex";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Error fetching documents: " + ex.Message;
                lblStatus.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            openFilesModal.Style["display"] = "none";
        }

        protected void gvDocuments_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "OpenDoc")
            {
                string docId = e.CommandArgument.ToString();
                Response.Redirect("~/Default.aspx?docId=" + docId);
            }
        }
    }
}
