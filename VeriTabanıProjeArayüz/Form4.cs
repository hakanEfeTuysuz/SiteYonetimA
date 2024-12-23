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
using System.Xml.Linq;

namespace VeriTabanıProjeArayüz
{
    public partial class Form4 : Form
    {
        public Form4()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            // PostgreSQL bağlantı dizesi
            string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=Hakan03041;Database=SiteYonetimA";

            // Güncellenmek istenen ID
            int idToUpdate;
            if (!int.TryParse(kisiidbox.Text, out idToUpdate))
            {
                MessageBox.Show("Lütfen geçerli bir ID girin!");
                return;
            }

            // Yeni ad ve yaş bilgileri
            string newName = NameBox.Text;
            string lnameText = LastNameBox.Text;
            string teltext = TelBox.Text;
            string mailtext = MailBox.Text;


            // PostgreSQL bağlantısı
            using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // SQL sorgusu
                    string query = "UPDATE kisi SET ad = @name, soyad = @lastname , telefon = @tel , email = @mail WHERE kisiid = @id";

                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        // Parametreleri ekle
                        command.Parameters.AddWithValue("@id", idToUpdate);
                        command.Parameters.AddWithValue("@name", newName);
                        command.Parameters.AddWithValue("@lastname", lnameText);
                        command.Parameters.AddWithValue("@tel", teltext);
                        command.Parameters.AddWithValue("@mail", mailtext);

                        // Sorguyu çalıştır
                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Kayıt başarıyla güncellendi!");
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

            // Güncellenmek istenen ID
            int idToUpdate;
            if (!int.TryParse(calisanidbox.Text, out idToUpdate))
            {
                MessageBox.Show("Lütfen geçerli bir ID girin!");
                return;
            }
            int newName;
            if (!int.TryParse(eskiyapiidbox.Text, out newName))
            {
                MessageBox.Show("Lütfen geçerli bir ID girin!");
                return;
            }
            int lnameText;
            if (!int.TryParse(yeniyapiidbox.Text, out lnameText))
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
                    string query = "UPDATE calisanyapi SET binaid = @yenibinaid,isbaslangic=CURRENT_DATE WHERE kisiid = @id AND binaid = @eskibinaid";

                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        // Parametreleri ekle
                        command.Parameters.AddWithValue("@id", idToUpdate);
                        command.Parameters.AddWithValue("@yenibinaid", lnameText);
                        command.Parameters.AddWithValue("@eskibinaid", newName);
                       

                        // Sorguyu çalıştır
                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Kayıt başarıyla güncellendi!");
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
