using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace VeriTabanıProjeArayüz
{
    public partial class Form3 : Form
    {
        public Form3()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            // PostgreSQL bağlantı dizesi
            string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=Hakan03041;Database=SiteYonetimA";

            // Silinmek istenen ID
            int idToDelete;
            if (!int.TryParse(kisiidbox.Text, out idToDelete))
            {
                MessageBox.Show("Lütfen geçerli bir ID girin!");
                return;
            }

            // PostgreSQL bağlantısı
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // SQL sorgusu
                    string query = "DELETE FROM kisi WHERE kisiid = @id";

                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        // Parametreyi ekle
                        command.Parameters.AddWithValue("@id", idToDelete);

                        // Sorguyu çalıştır
                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Kayıt başarıyla silindi!");
                        }
                        else
                        {
                            MessageBox.Show("Kayıt bulunamadı.");
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Hata: {ex.Message}");
                }
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            // PostgreSQL bağlantı dizesi
            string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=Hakan03041;Database=SiteYonetimA";

            // Silinmek istenen ID
            int idToDelete;
            if (!int.TryParse(aracidbox.Text, out idToDelete))
            {
                MessageBox.Show("Lütfen geçerli bir ID girin!");
                return;
            }

            // PostgreSQL bağlantısı
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // SQL sorgusu
                    string query = "DELETE FROM arac WHERE aracid = @id";

                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        // Parametreyi ekle
                        command.Parameters.AddWithValue("@id", idToDelete);

                        // Sorguyu çalıştır
                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Kayıt başarıyla silindi!");
                        }
                        else
                        {
                            MessageBox.Show("Kayıt bulunamadı.");
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Hata: {ex.Message}");
                }
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            // PostgreSQL bağlantı dizesi
            string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=Hakan03041;Database=SiteYonetimA";

            // Silinmek istenen ID
            int idToDelete;
            if (!int.TryParse(kisibox.Text, out idToDelete))
            {
                MessageBox.Show("Lütfen geçerli bir ID girin!");
                return;
            }
            int binaidToDelete;
            if (!int.TryParse(binabox.Text, out binaidToDelete))
            {
                MessageBox.Show("Lütfen geçerli bir ID girin!");
                return;
            }

            // PostgreSQL bağlantısı
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // SQL sorgusu
                    string query = "DELETE FROM calisanyapi WHERE kisiid = @id AND binaid = @bina";

                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        // Parametreyi ekle
                        command.Parameters.AddWithValue("@id", idToDelete);
                        command.Parameters.AddWithValue("@bina", binaidToDelete);

                        // Sorguyu çalıştır
                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Kayıt başarıyla silindi!");
                        }
                        else
                        {
                            MessageBox.Show("Kayıt bulunamadı.");
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Hata: {ex.Message}");
                }
            }
        }
    }
}
