using Microsoft.AspNetCore.Identity;

namespace GenericTemplateSolution.API
{
    public class Program(IConfiguration configuration)
    {
        public IConfiguration Configuration { get; } = configuration;
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            if (Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") == "Development")
            {
                builder.Configuration.AddJsonFile("appsettings.Development.json", optional: true, reloadOnChange: true);
            }

            ConfigurationManager configuration = builder.Configuration;

            builder.Services.AddLogging(builder =>
            {
                builder.AddDebug();
                builder.AddConsole();
            });

            builder.Services.AddControllers()
                .AddNewtonsoftJson(options =>
                {
                    options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;

                });
            builder.Services.AddEndpointsApiExplorer();

            builder.Services.AddSwaggerGen();



            // Connect to a SQL Server database
            //builder.Services.AddEntityFrameworkSqlServer()
            //  .AddDbContext<AppDbContext>(options =>
            //  {
            //      options.UseSqlServer(configuration.GetConnectionString("Database"))
            //          //options.UseSqlServer(configuration.GetConnectionString("ServidorStartup"))
            //          .LogTo(Console.WriteLine, LogLevel.Information);

            //  }, ServiceLifetime.Scoped);

            builder.Services.AddCors(options =>
            {
                options.AddPolicy("CorsPolicy",
                    builder => builder
                        .AllowAnyOrigin()
                        .AllowAnyHeader()
                        .AllowAnyMethod()
                        .WithMethods("GET", "PUT", "DELETE", "POST", "PATCH")
                );
            });

            // For Identity
            builder.Services.AddIdentity<ApplicationUser, IdentityRole>(options =>
            {
                // Configurações padrão do Identity

                options.Password.RequireDigit = false;
                options.Password.RequireLowercase = false;
                options.Password.RequireUppercase = false;
                options.Password.RequireNonAlphanumeric = false;
                options.Password.RequiredLength = 1; // Defina o comprimento mínimo da senha desejado
            })
                .AddEntityFrameworkStores<AppDbContext>()
                .AddDefaultTokenProviders();

        }

    }

}
