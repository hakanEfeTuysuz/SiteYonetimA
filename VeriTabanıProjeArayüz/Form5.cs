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
    public partial class Form5 : Form
    {
        public Form5()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            // PostgreSQL bağlantı dizesi
            string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=Hakan03041;Database=SiteYonetimA";

            // Sorgulanacak ID
            int idToFind;
            if (!int.TryParse(kisiidbox.Text, out idToFind))
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
                    string query = "SELECT * FROM kisi WHERE kisiid = @id";

                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        // Parametreyi ekle
                        command.Parameters.AddWithValue("@id", idToFind);

                        // Sorguyu çalıştır ve verileri oku
                        using (NpgsqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.Read()) // Veri bulundu mu?
                            {
                                // ListBox'u temizle ve yeni verileri ekle
                                listBox1.Items.Clear();

                                listBox1.Items.Add($"ID: {reader["kisiid"]}");
                                listBox1.Items.Add($"Ad: {reader["ad"]}");
                                listBox1.Items.Add($"Soyad: {reader["soyad"]}");
                                listBox1.Items.Add($"E-Mail: {reader["email"]}");
                                listBox1.Items.Add($"TCKN: {reader["tckimlikno"]}");
                                listBox1.Items.Add($"Telefon: {reader["telefon"]}");
                            }
                            else
                            {
                                MessageBox.Show("Belirtilen ID'ye ait kayıt bulunamadı.");
                                listBox1.Items.Clear();
                            }
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

            // Sorgulanacak ID
            int idToFind;
            if (!int.TryParse(aracidbox.Text, out idToFind))
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
                    string query = "SELECT * FROM arac WHERE aracid = @id";

                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        // Parametreyi ekle
                        command.Parameters.AddWithValue("@id", idToFind);

                        // Sorguyu çalıştır ve verileri oku
                        using (NpgsqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.Read()) // Veri bulundu mu?
                            {
                                // ListBox'u temizle ve yeni verileri ekle
                                listBox1.Items.Clear();

                                listBox1.Items.Add($"ID: {reader["aracid"]}");
                                listBox1.Items.Add($"Marka: {reader["marka"]}");
                                listBox1.Items.Add($"Model: {reader["model"]}");
                                listBox1.Items.Add($"Plaka: {reader["plaka"]}");
                                listBox1.Items.Add($"Otopark ID: {reader["otoparkid"]}");
                                listBox1.Items.Add($"Sahip ID: {reader["sahipid"]}");
                            }
                            else
                            {
                                MessageBox.Show("Belirtilen ID'ye ait kayıt bulunamadı.");
                                listBox1.Items.Clear();
                            }
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

            // Sorgulanacak ID
            int idToFind;
            if (!int.TryParse(daireidbox.Text, out idToFind))
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
                    string query = "SELECT * FROM daire WHERE daireid = @id";

                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        // Parametreyi ekle
                        command.Parameters.AddWithValue("@id", idToFind);

                        // Sorguyu çalıştır ve verileri oku
                        using (NpgsqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.Read()) // Veri bulundu mu?
                            {
                                // ListBox'u temizle ve yeni verileri ekle
                                listBox1.Items.Clear();

                                listBox1.Items.Add($"ID: {reader["daireid"]}");
                                listBox1.Items.Add($"Apartman ID: {reader["apartmanid"]}");
                                listBox1.Items.Add($"Daire No: {reader["daireno"]}");
                                listBox1.Items.Add($"Daire tipi: {reader["dairetipi"]}");
                                listBox1.Items.Add($"Kat numarası: {reader["katnumarasi"]}");
                                listBox1.Items.Add($"Metrekare: {reader["metrekare"]}");
                                listBox1.Items.Add($"Oda sayisi: {reader["odasayisi"]}");
                                listBox1.Items.Add($"Salon sayisi: {reader["salonsayisi"]}");
                                listBox1.Items.Add($"Sahip ID: {reader["sahipid"]}");

                            }
                            else
                            {
                                MessageBox.Show("Belirtilen ID'ye ait kayıt bulunamadı.");
                                listBox1.Items.Clear();
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Hata: {ex.Message}");
                }
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            // PostgreSQL bağlantı dizesi
            string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=Hakan03041;Database=SiteYonetimA";

            // Sorgulanacak ID
            int idToFind;
            if (!int.TryParse(yapıbox.Text, out idToFind))
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
                    string query = "SELECT * FROM bina WHERE binaid = @id";

                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        // Parametreyi ekle
                        command.Parameters.AddWithValue("@id", idToFind);

                        // Sorguyu çalıştır ve verileri oku
                        using (NpgsqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.Read()) // Veri bulundu mu?
                            {
                                // ListBox'u temizle ve yeni verileri ekle
                                listBox1.Items.Clear();

                                listBox1.Items.Add($"ID: {reader["binaid"]}");
                                listBox1.Items.Add($"Alan: {reader["alan"]}");
                                listBox1.Items.Add($"Adres: {reader["adres"]}");
                                listBox1.Items.Add($"Bina adı: {reader["binaadi"]}");

                            }
                            else
                            {
                                MessageBox.Show("Belirtilen ID'ye ait kayıt bulunamadı.");
                                listBox1.Items.Clear();
                            }
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
