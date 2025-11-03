using QuanLyDoiBong.DataAccess;

namespace QuanLyDoiBong.Forms
{
    /// <summary>
    /// Form truy vấn 1: Cầu thủ thuộc một câu lạc bộ
    /// </summary>
    public partial class frmQuery1 : Form
    {
        private QueryDAO queryDAO = new QueryDAO();
        private DoiBongDAO doiBongDAO = new DoiBongDAO();
        private ComboBox cboCLB;
        private DataGridView dgvResult;
        private Button btnTimKiem;

        public frmQuery1()
        {
            InitializeComponent();
            InitializeControls();
            LoadCLB();
        }

        private void InitializeComponent()
        {
            this.Text = "Truy vấn: Cầu thủ theo Câu lạc bộ";
            this.Size = new Size(800, 500);
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        private void InitializeControls()
        {
            // Panel tìm kiếm
            Panel pnlSearch = new Panel { Dock = DockStyle.Top, Height = 80, Padding = new Padding(10) };

            Label lblCLB = new Label { Text = "Chọn CLB:", Location = new Point(20, 25), AutoSize = true };
            cboCLB = new ComboBox 
            { 
                Location = new Point(120, 22), 
                Width = 300,
                DropDownStyle = ComboBoxStyle.DropDownList
            };

            btnTimKiem = new Button 
            { 
                Text = "Tìm kiếm", 
                Location = new Point(430, 20), 
                Width = 120,
                Height = 30
            };
            btnTimKiem.Click += BtnTimKiem_Click;

            pnlSearch.Controls.AddRange(new Control[] { lblCLB, cboCLB, btnTimKiem });

            // DataGridView kết quả
            dgvResult = new DataGridView
            {
                Dock = DockStyle.Fill,
                AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                MultiSelect = false,
                ReadOnly = true,
                AllowUserToAddRows = false
            };

            this.Controls.Add(dgvResult);
            this.Controls.Add(pnlSearch);
        }

        private void LoadCLB()
        {
            List<string> clbList = doiBongDAO.GetAllCLB();
            cboCLB.DataSource = clbList;
        }

        private void BtnTimKiem_Click(object? sender, EventArgs e)
        {
            if (cboCLB.SelectedItem == null)
            {
                MessageBox.Show("Vui lòng chọn CLB!", "Cảnh báo", 
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            string clb = cboCLB.SelectedItem.ToString() ?? "";
            var result = queryDAO.GetCauThuTheoCLB(clb);
            
            dgvResult.DataSource = result;

            if (dgvResult.Columns.Count > 0)
            {
                dgvResult.Columns["MaCT"].HeaderText = "Mã Cầu Thủ";
                dgvResult.Columns["HoTen"].HeaderText = "Họ Tên";
                dgvResult.Columns["TenDB"].HeaderText = "Tên Đội";
                dgvResult.Columns["CLB"].HeaderText = "Câu Lạc Bộ";
            }

            MessageBox.Show($"Tìm thấy {result.Rows.Count} cầu thủ thuộc CLB {clb}", 
                "Kết quả", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
    }
}
