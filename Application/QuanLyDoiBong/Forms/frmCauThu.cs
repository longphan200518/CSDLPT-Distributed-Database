using QuanLyDoiBong.DataAccess;
using QuanLyDoiBong.Models;

namespace QuanLyDoiBong.Forms
{
    public partial class frmCauThu : Form
    {
        private CauThuDAO dao = new CauThuDAO();
        private DoiBongDAO doiBongDAO = new DoiBongDAO();
        private DataGridView dgvCauThu;
        private TextBox txtMaCT, txtHoTen;
        private ComboBox cboMaDB;
        private Button btnThem, btnSua, btnXoa, btnLamMoi;

        public frmCauThu()
        {
            InitializeComponent();
            InitializeControls();
            LoadComboBox();
            LoadData();
        }

        private void InitializeComponent()
        {
            this.Text = "Quản Lý Cầu Thủ";
            this.Size = new Size(900, 600);
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        private void InitializeControls()
        {
            Panel pnlInfo = new Panel { Dock = DockStyle.Top, Height = 150, Padding = new Padding(10) };

            Label lblMaCT = new Label { Text = "Mã cầu thủ:", Location = new Point(20, 20), AutoSize = true };
            txtMaCT = new TextBox { Location = new Point(120, 17), Width = 200 };

            Label lblHoTen = new Label { Text = "Họ tên:", Location = new Point(20, 60), AutoSize = true };
            txtHoTen = new TextBox { Location = new Point(120, 57), Width = 400 };

            Label lblMaDB = new Label { Text = "Đội bóng:", Location = new Point(20, 100), AutoSize = true };
            cboMaDB = new ComboBox { Location = new Point(120, 97), Width = 300, DropDownStyle = ComboBoxStyle.DropDownList };

            pnlInfo.Controls.AddRange(new Control[] { lblMaCT, txtMaCT, lblHoTen, txtHoTen, lblMaDB, cboMaDB });

            Panel pnlButtons = new Panel { Dock = DockStyle.Top, Height = 60 };
            btnThem = new Button { Text = "Thêm", Location = new Point(20, 15), Width = 100 };
            btnSua = new Button { Text = "Sửa", Location = new Point(130, 15), Width = 100 };
            btnXoa = new Button { Text = "Xóa", Location = new Point(240, 15), Width = 100 };
            btnLamMoi = new Button { Text = "Làm mới", Location = new Point(350, 15), Width = 100 };

            btnThem.Click += BtnThem_Click;
            btnSua.Click += BtnSua_Click;
            btnXoa.Click += BtnXoa_Click;
            btnLamMoi.Click += (s, e) => { ClearInputs(); LoadData(); };

            pnlButtons.Controls.AddRange(new Control[] { btnThem, btnSua, btnXoa, btnLamMoi });

            dgvCauThu = new DataGridView
            {
                Dock = DockStyle.Fill,
                AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                MultiSelect = false,
                ReadOnly = true,
                AllowUserToAddRows = false
            };
            dgvCauThu.CellClick += DgvCauThu_CellClick;

            this.Controls.Add(dgvCauThu);
            this.Controls.Add(pnlButtons);
            this.Controls.Add(pnlInfo);
        }

        private void LoadComboBox()
        {
            cboMaDB.DataSource = doiBongDAO.GetAll();
            cboMaDB.DisplayMember = "TenDB";
            cboMaDB.ValueMember = "MaDB";
        }

        private void LoadData()
        {
            dgvCauThu.DataSource = null;
            dgvCauThu.DataSource = dao.GetAll();
            if (dgvCauThu.Columns.Count > 0)
            {
                dgvCauThu.Columns["MaCT"].HeaderText = "Mã Cầu Thủ";
                dgvCauThu.Columns["HoTen"].HeaderText = "Họ Tên";
                dgvCauThu.Columns["MaDB"].HeaderText = "Mã Đội";
            }
        }

        private void DgvCauThu_CellClick(object? sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = dgvCauThu.Rows[e.RowIndex];
                txtMaCT.Text = row.Cells["MaCT"].Value?.ToString() ?? "";
                txtHoTen.Text = row.Cells["HoTen"].Value?.ToString() ?? "";
                cboMaDB.SelectedValue = row.Cells["MaDB"].Value?.ToString() ?? "";
                txtMaCT.ReadOnly = true;
            }
        }

        private void BtnThem_Click(object? sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaCT.Text) || string.IsNullOrWhiteSpace(txtHoTen.Text) || cboMaDB.SelectedValue == null)
            {
                MessageBox.Show("Vui lòng nhập đầy đủ thông tin!", "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            CauThu ct = new CauThu
            {
                MaCT = txtMaCT.Text.Trim(),
                HoTen = txtHoTen.Text.Trim(),
                MaDB = cboMaDB.SelectedValue.ToString() ?? ""
            };

            if (dao.Insert(ct))
            {
                MessageBox.Show("Thêm thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                ClearInputs();
                LoadData();
            }
            else
            {
                MessageBox.Show("Thêm thất bại!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void BtnSua_Click(object? sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaCT.Text))
            {
                MessageBox.Show("Vui lòng chọn cầu thủ cần sửa!", "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            CauThu ct = new CauThu
            {
                MaCT = txtMaCT.Text.Trim(),
                HoTen = txtHoTen.Text.Trim(),
                MaDB = cboMaDB.SelectedValue?.ToString() ?? ""
            };

            if (dao.Update(ct))
            {
                MessageBox.Show("Cập nhật thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                ClearInputs();
                LoadData();
            }
            else
            {
                MessageBox.Show("Cập nhật thất bại!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void BtnXoa_Click(object? sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaCT.Text))
            {
                MessageBox.Show("Vui lòng chọn cầu thủ cần xóa!", "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (MessageBox.Show($"Bạn có chắc muốn xóa cầu thủ {txtMaCT.Text}?", "Xác nhận",
                MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                if (dao.Delete(txtMaCT.Text))
                {
                    MessageBox.Show("Xóa thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    ClearInputs();
                    LoadData();
                }
                else
                {
                    MessageBox.Show("Xóa thất bại!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }

        private void ClearInputs()
        {
            txtMaCT.Clear();
            txtHoTen.Clear();
            cboMaDB.SelectedIndex = -1;
            txtMaCT.ReadOnly = false;
            txtMaCT.Focus();
        }
    }
}
