﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WindowsFormsApp.DAO
{
    class QuanLyNhanVien
    {
        private static QuanLyNhanVien instance;

        public QuanLyNhanVien()
        {
        }

        public static QuanLyNhanVien Intance
        {
            get { if (instance == null) instance = new QuanLyNhanVien(); return instance; }
            set => instance = value;
        }

        public bool Login(string userName, string passWord)
        {
            string query = "SELECT * FROM NhanVien WHERE TenDangNhap = N'" + userName + "' AND MatNVau = N'" + passWord + "' ";

            DataTable result = DataProvider.Instance.ExecuteQuery(query);

            return result.Rows.Count > 0;
        }

        public Models.NhanVien getNVByID(string id)
        {
            string query = "SELECT * FROM NhanVien WHERE TenDangNhap = N'" + id + "'";
            DataRow a = DataProvider.Instance.ExecuteQuery(query).Rows[0];
            return new Models.NhanVien(a);
        }

        public DataTable getListNV()
        {
            string query = "select * from NhanVien";
            return DataProvider.Instance.ExecuteQuery(query);
        }



        public bool suaNV(string maNV, string tenNV, string DiaChi, string SDT)
        {
            string query = String.Format("update NhanVien set TenHienThi = N'{0}', DiaChi = N'{1}', SDT = {2} where MaNV = '{3}'", tenNV, DiaChi, SDT, maNV);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }

        public bool xoaNV(string maNV)
        {
            string query = String.Format("delete from NhanVien where MaNV = '{0}'", maNV);
            int result = DataProvider.Instance.ExecuteNonQuery(query);
            return result > 0;
        }

        public DataTable TimKiemNV(string name)
        {
            string query = string.Format("SELECT MaNV,TenHienThi, DiaChi, SDT FROM NhanVien WHERE dbo.GetUnsignString(NhanVien.TenHienThi) LIKE N'%' + dbo.GetUnsignString(N'{0}') + '%'", name);
            DataTable data = DataProvider.Instance.ExecuteQuery(query);
            return data;
        }

        public string loadMaNV()
        {
            string maNVnext = "";
            string query = "select top 1 MaNV from NhanVien order by MaNV desc";
            DataRow data = DataProvider.Instance.ExecuteQuery(query).Rows[0];
            maNVnext = data["MaNV"].ToString();
            return maNVnext;
        }
    }
}
