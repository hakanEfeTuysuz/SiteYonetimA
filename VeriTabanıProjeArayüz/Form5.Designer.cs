namespace VeriTabanıProjeArayüz
{
    partial class Form5
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            label10 = new Label();
            aracidbox = new TextBox();
            button2 = new Button();
            label1 = new Label();
            kisiidbox = new TextBox();
            button1 = new Button();
            listBox1 = new ListBox();
            label2 = new Label();
            daireidbox = new TextBox();
            button3 = new Button();
            label3 = new Label();
            yapıbox = new TextBox();
            button4 = new Button();
            label4 = new Label();
            SuspendLayout();
            // 
            // label10
            // 
            label10.AutoSize = true;
            label10.Location = new Point(61, 175);
            label10.Name = "label10";
            label10.Size = new Size(178, 20);
            label10.TabIndex = 28;
            label10.Text = "ARANACAK ARACIN ID'Sİ";
            // 
            // aracidbox
            // 
            aracidbox.Location = new Point(74, 210);
            aracidbox.Name = "aracidbox";
            aracidbox.Size = new Size(125, 27);
            aracidbox.TabIndex = 27;
            // 
            // button2
            // 
            button2.Location = new Point(74, 243);
            button2.Name = "button2";
            button2.Size = new Size(114, 29);
            button2.TabIndex = 26;
            button2.Text = "ARAÇ ARA";
            button2.UseVisualStyleBackColor = true;
            button2.Click += button2_Click;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(61, 40);
            label1.Name = "label1";
            label1.Size = new Size(180, 20);
            label1.TabIndex = 25;
            label1.Text = " ARANACAK KİŞİNİN ID'Sİ";
            // 
            // kisiidbox
            // 
            kisiidbox.Location = new Point(74, 74);
            kisiidbox.Name = "kisiidbox";
            kisiidbox.Size = new Size(125, 27);
            kisiidbox.TabIndex = 24;
            // 
            // button1
            // 
            button1.Location = new Point(72, 118);
            button1.Name = "button1";
            button1.Size = new Size(114, 29);
            button1.TabIndex = 23;
            button1.Text = "KİŞİ ARA";
            button1.UseVisualStyleBackColor = true;
            button1.Click += button1_Click;
            // 
            // listBox1
            // 
            listBox1.FormattingEnabled = true;
            listBox1.Location = new Point(344, 105);
            listBox1.Name = "listBox1";
            listBox1.Size = new Size(363, 364);
            listBox1.TabIndex = 29;
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(61, 307);
            label2.Name = "label2";
            label2.Size = new Size(193, 20);
            label2.TabIndex = 32;
            label2.Text = "ARANACAK DAİRENİN ID'Sİ";
            // 
            // daireidbox
            // 
            daireidbox.Location = new Point(74, 342);
            daireidbox.Name = "daireidbox";
            daireidbox.Size = new Size(125, 27);
            daireidbox.TabIndex = 31;
            // 
            // button3
            // 
            button3.Location = new Point(74, 375);
            button3.Name = "button3";
            button3.Size = new Size(114, 29);
            button3.TabIndex = 30;
            button3.Text = "DAİRE ARA";
            button3.UseVisualStyleBackColor = true;
            button3.Click += button3_Click;
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(61, 429);
            label3.Name = "label3";
            label3.Size = new Size(180, 20);
            label3.TabIndex = 35;
            label3.Text = "ARANACAK YAPININ ID'Sİ";
            // 
            // yapıbox
            // 
            yapıbox.Location = new Point(74, 464);
            yapıbox.Name = "yapıbox";
            yapıbox.Size = new Size(125, 27);
            yapıbox.TabIndex = 34;
            // 
            // button4
            // 
            button4.Location = new Point(74, 497);
            button4.Name = "button4";
            button4.Size = new Size(114, 29);
            button4.TabIndex = 33;
            button4.Text = "YAPI ARA";
            button4.UseVisualStyleBackColor = true;
            button4.Click += button4_Click;
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Location = new Point(500, 74);
            label4.Name = "label4";
            label4.Size = new Size(67, 20);
            label4.TabIndex = 36;
            label4.Text = "BİLGİLER";
            // 
            // Form5
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(793, 563);
            Controls.Add(label4);
            Controls.Add(label3);
            Controls.Add(yapıbox);
            Controls.Add(button4);
            Controls.Add(label2);
            Controls.Add(daireidbox);
            Controls.Add(button3);
            Controls.Add(listBox1);
            Controls.Add(label10);
            Controls.Add(aracidbox);
            Controls.Add(button2);
            Controls.Add(label1);
            Controls.Add(kisiidbox);
            Controls.Add(button1);
            Name = "Form5";
            Text = "ARAMA YAPISI";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Label label10;
        private TextBox aracidbox;
        private Button button2;
        private Label label1;
        private TextBox kisiidbox;
        private Button button1;
        private ListBox listBox1;
        private Label label2;
        private TextBox daireidbox;
        private Button button3;
        private Label label3;
        private TextBox yapıbox;
        private Button button4;
        private Label label4;
    }
}