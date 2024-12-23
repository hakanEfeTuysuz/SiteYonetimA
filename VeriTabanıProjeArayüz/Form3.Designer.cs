namespace VeriTabanıProjeArayüz
{
    partial class Form3
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
            label2 = new Label();
            kisibox = new TextBox();
            button3 = new Button();
            binabox = new TextBox();
            label3 = new Label();
            label4 = new Label();
            SuspendLayout();
            // 
            // label10
            // 
            label10.AutoSize = true;
            label10.Location = new Point(52, 186);
            label10.Name = "label10";
            label10.Size = new Size(168, 20);
            label10.TabIndex = 22;
            label10.Text = "SİLİNECEK ARACIN ID'Sİ";
            // 
            // aracidbox
            // 
            aracidbox.Location = new Point(65, 222);
            aracidbox.Name = "aracidbox";
            aracidbox.Size = new Size(125, 27);
            aracidbox.TabIndex = 21;
            // 
            // button2
            // 
            button2.Location = new Point(65, 271);
            button2.Name = "button2";
            button2.Size = new Size(114, 29);
            button2.TabIndex = 20;
            button2.Text = "ARAÇ SİL";
            button2.UseVisualStyleBackColor = true;
            button2.Click += button2_Click;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(52, 24);
            label1.Name = "label1";
            label1.Size = new Size(166, 20);
            label1.TabIndex = 19;
            label1.Text = "SİLİNECEK KİŞİNİN ID'Sİ";
            // 
            // kisiidbox
            // 
            kisiidbox.Location = new Point(63, 56);
            kisiidbox.Name = "kisiidbox";
            kisiidbox.Size = new Size(127, 27);
            kisiidbox.TabIndex = 18;
            // 
            // button1
            // 
            button1.Location = new Point(63, 102);
            button1.Name = "button1";
            button1.Size = new Size(114, 29);
            button1.TabIndex = 17;
            button1.Text = "KİŞİ SİL";
            button1.UseVisualStyleBackColor = true;
            button1.Click += button1_Click;
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(473, 74);
            label2.Name = "label2";
            label2.Size = new Size(155, 20);
            label2.TabIndex = 23;
            label2.Text = "SONA ERDİRİLECEK İŞ";
            // 
            // kisibox
            // 
            kisibox.Location = new Point(402, 138);
            kisibox.Name = "kisibox";
            kisibox.Size = new Size(125, 27);
            kisibox.TabIndex = 25;
            // 
            // button3
            // 
            button3.Location = new Point(459, 197);
            button3.Name = "button3";
            button3.Size = new Size(180, 29);
            button3.TabIndex = 24;
            button3.Text = "GÖREVİ SONA ERDİR";
            button3.UseVisualStyleBackColor = true;
            button3.Click += button3_Click;
            // 
            // binabox
            // 
            binabox.Location = new Point(576, 139);
            binabox.Name = "binabox";
            binabox.Size = new Size(125, 27);
            binabox.TabIndex = 26;
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(596, 115);
            label3.Name = "label3";
            label3.Size = new Size(62, 20);
            label3.TabIndex = 27;
            label3.Text = "BİNA ID";
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Location = new Point(445, 115);
            label4.Name = "label4";
            label4.Size = new Size(53, 20);
            label4.TabIndex = 28;
            label4.Text = "KİŞİ ID";
            // 
            // Form3
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(762, 350);
            Controls.Add(label4);
            Controls.Add(label3);
            Controls.Add(binabox);
            Controls.Add(kisibox);
            Controls.Add(button3);
            Controls.Add(label2);
            Controls.Add(label10);
            Controls.Add(aracidbox);
            Controls.Add(button2);
            Controls.Add(label1);
            Controls.Add(kisiidbox);
            Controls.Add(button1);
            Name = "Form3";
            Text = "SİLME SAYFASI";
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
        private Label label2;
        private TextBox kisibox;
        private Button button3;
        private TextBox binabox;
        private Label label3;
        private Label label4;
    }
}