FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["embedApp/rasp-embed/rasp-embed.csproj", "."]
RUN dotnet restore "rasp-embed.csproj"
COPY . .
RUN dotnet build "rasp-embed.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "rasp-embed.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "rasp-embed.dll"]