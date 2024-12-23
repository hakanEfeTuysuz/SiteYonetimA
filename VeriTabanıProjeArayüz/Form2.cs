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
using static System.Windows.Forms.VisualStyles.VisualStyleElement;
using System.Xml.Linq;

namespace VeriTabanıProjeArayüz
{
    public partial class Form2 : Form
    {
        public Form2()
        {
            InitializeComponent();
        }


        private void button1_Click(object sender, EventArgs e)
        {
            string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=Hakan03041;Database=SiteYonetimA";

            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    string query = "INSERT INTO kisi (ad, soyad , tckimlikno , telefon ,email) VALUES (@name, @lastname , @tckn , @telno ,@mailno)";
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        // Parametreleri ekle
                        command.Parameters.AddWithValue("@name", NameBox.Text);
                        command.Parameters.AddWithValue("@lastname", LastNameBox.Text);
                        command.Parameters.AddWithValue("@tckn", TCBox.Text);
                        command.Parameters.AddWithValue("@telno", TelBox.Text);
                        command.Parameters.AddWithValue("@mailno", MailBox.Text);

                        // Sorguyu çalıştır
                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Kayıt başarıyla eklendi!");
                        }
                        else
                        {
                            MessageBox.Show("Kayıt eklenemedi.");
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
            string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=Hakan03041;Database=SiteYonetimA";

            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    string query = "INSERT INTO arac (marka, model , plaka , sahipid ,otoparkid) VALUES (@name, @lastname , @tckn , @telno ,@mailno)";
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        // Parametreleri ekle
                        command.Parameters.AddWithValue("@name", markabox.Text);
                        command.Parameters.AddWithValue("@lastname", modelbox.Text);
                        command.Parameters.AddWithValue("@tckn", plakabox.Text);
                        command.Parameters.AddWithValue("@telno", Convert.ToInt32(sahipbox.Text));

                        if (otoparkbox.Text.Length > 0)
                        {
                            command.Parameters.AddWithValue("@mailno", Convert.ToInt32(otoparkbox.Text));
                        }
                        else
                        {
                            command.Parameters.AddWithValue("@mailno", DBNull.Value);
                        }


                        // Sorguyu çalıştır
                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Kayıt başarıyla eklendi!");
                        }
                        else
                        {
                            MessageBox.Show("Kayıt eklenemedi.");
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
            string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=Hakan03041;Database=SiteYonetimA";

            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    string query = "INSERT INTO bina (binaadi, adres , alan) VALUES (@name, @adres , @alan)";
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        // Parametreleri ekle
                        command.Parameters.AddWithValue("@name", binaadbox.Text);
                        command.Parameters.AddWithValue("@adres", adresbox.Text);
                        command.Parameters.AddWithValue("@alan", Convert.ToInt32(alanbox.Text));


                        // Sorguyu çalıştır
                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Kayıt başarıyla eklendi!");
                        }
                        else
                        {
                            MessageBox.Show("Kayıt eklenemedi.");
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
