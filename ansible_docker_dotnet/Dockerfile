FROM mcr.microsoft.com/dotnet/sdk:8.0

WORKDIR /opt/dotnet_app

COPY HelloDotnet/ .

RUN dotnet restore
RUN dotnet build

CMD ["dotnet", "run"]