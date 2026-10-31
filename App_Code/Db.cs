using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

// Small helper so pages can run SQL in one line. Parameters are passed as name, value pairs.
public static class Db
{
    static string Cs { get { return ConfigurationManager.ConnectionStrings["TeamBoardDB"].ConnectionString; } }

    static SqlCommand Build(SqlConnection con, string sql, object[] p)
    {
        var cmd = new SqlCommand(sql, con);
        for (int i = 0; i + 1 < p.Length; i += 2)
            cmd.Parameters.AddWithValue((string)p[i], p[i + 1] ?? DBNull.Value);
        return cmd;
    }

    public static DataTable Table(string sql, params object[] p)
    {
        using (var con = new SqlConnection(Cs))
        using (var da = new SqlDataAdapter(Build(con, sql, p)))
        {
            var dt = new DataTable();
            da.Fill(dt);
            return dt;
        }
    }

    public static int Exec(string sql, params object[] p)
    {
        using (var con = new SqlConnection(Cs))
        using (var cmd = Build(con, sql, p))
        {
            con.Open();
            return cmd.ExecuteNonQuery();
        }
    }

    public static object Scalar(string sql, params object[] p)
    {
        using (var con = new SqlConnection(Cs))
        using (var cmd = Build(con, sql, p))
        {
            con.Open();
            return cmd.ExecuteScalar();
        }
    }
}
