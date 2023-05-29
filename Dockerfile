# Start with the appropriate base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory inside the container
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the remaining source code
COPY . ./

# Build the application
RUN dotnet publish -c Release -o /app/out

# Start a new stage with a lightweight base image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

# Set the working directory inside the container
WORKDIR /app

# Copy the published output from the previous stage
COPY --from=build-env /app/out .

# Expose the port your application listens on
EXPOSE 80

# Start the application when the container starts
ENTRYPOINT ["dotnet", "WebApplication3.dll"]
