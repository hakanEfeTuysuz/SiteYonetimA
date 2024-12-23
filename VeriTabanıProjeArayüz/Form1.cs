namespace VeriTabanıProjeArayüz
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            Form2 form = new Form2();
            form.Show();

            this.Hide();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            Form3 form = new Form3();
            form.Show();

            this.Hide();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            Form4 form = new Form4();
            form.Show();

            this.Hide();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Form5 form = new Form5(); 
            form.Show();

            this.Hide();
        }
    }
}
