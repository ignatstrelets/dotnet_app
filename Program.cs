using System;
using System.IO;
using System.Text;
using System.Net;
using System.Threading.Tasks;
using Npgsql;

class Program
{


    public static HttpListener listener;
    public static string url = "http://*:8000/";
    public static int pageViews = 0;
    public static int requestCount = 0;
    public static string pageData = 
        "<!DOCTYPE>" +
        "<html>" +
        "  <head>" +
        "    <title>HttpListener Example</title>" +
        "  </head>" +
        "  <body>" +
        "    <p>Welcome to .NET Server (c) Ignat Strelets</p>" +
        "  </body>" +
        "</html>";

    public static async Task HandleIncomingConnections()
    {
	bool runServer = true;
        while (runServer)
	{
	    HttpListenerContext ctx = await listener.GetContextAsync();
            HttpListenerRequest req = ctx.Request;
            HttpListenerResponse resp = ctx.Response;	    
            Console.WriteLine("Request #: {0}", ++requestCount);
            Console.WriteLine(req.Url.ToString());
            Console.WriteLine(req.HttpMethod);
            Console.WriteLine(req.UserHostName);
            Console.WriteLine(req.UserAgent);
            Console.WriteLine();
            if (req.Url.AbsolutePath != "/favicon.ico")
                    pageViews += 1;

            string disableSubmit = !runServer ? "disabled" : "";
	    byte[] data = Encoding.UTF8.GetBytes(String.Format(pageData, pageViews, disableSubmit));
	    resp.ContentType = "text/html";
	    resp.ContentEncoding = Encoding.UTF8;
	    resp.ContentLength64 = data.LongLength;
       

	    await resp.OutputStream.WriteAsync(data, 0, data.Length);


	    resp.Close();
	}    
    }

    static void Main(string[] args)
    {   
	string dbHost = "localhost";
	string dbUsername = Environment.GetEnvironmentVariable("DB_USERNAME");
        string dbPassword = Environment.GetEnvironmentVariable("DB_PASSWORD");
	string dbName = Environment.GetEnvironmentVariable("DB_NAME");

	//set db host as rds endpoint url

	string connectionString = string.Format("Host={0};Port=5432;Username={1};Password={2};Database={3};",dbHost,dbUsername,dbPassword,dbName);
        NpgsqlConnection connection = new NpgsqlConnection(connectionString);

        var sql = "SELECT version()";
        using var cmd = new NpgsqlCommand(sql, connection);

        try
        {
            connection.Open();
            Console.WriteLine("Connected to PostgreSQL!");

            Console.WriteLine("Postgres Version:");
            Console.WriteLine(connection.PostgreSqlVersion);

        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error: {ex.Message}");
        }
        finally
        {
            connection.Close();
        }

	listener = new HttpListener();
        listener.Prefixes.Add(url);
        listener.Start();
        Console.WriteLine("Listening for connections on {0}", url);

        Task listenTask = HandleIncomingConnections();
	listenTask.GetAwaiter().GetResult();

    }
}

