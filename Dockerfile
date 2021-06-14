# Set the base image as the .NET 5.0 SDK (this includes the runtime)
FROM mcr.microsoft.com/dotnet/sdk:5.0 as build
WORKDIR /src
# Copy everything and publish the release (publish implicitly restores and builds)
COPY . .
RUN dotnet publish -c release -o /out --no-self-contained

# Label the container
LABEL maintainer="Nikolai E. Damm <nikolai.damm@gmail.com> & Niels Faurskov <jazerixthegreat@gmail.com>"
LABEL repository="https://github.com/HexUML/hexuml"

# Label as GitHub action
LABEL com.github.actions.name="HexUML"
# Limit to 160 characters
LABEL com.github.actions.description="A Github action that allows you to convert code in your repository to a supported generation format."
# See branding:
# https://docs.github.com/actions/creating-actions/metadata-syntax-for-github-actions#branding
LABEL com.github.actions.icon="code"
LABEL com.github.actions.color="orange"

# Relayer the .NET SDK, anew with the build output
FROM mcr.microsoft.com/dotnet/sdk:5.0
WORKDIR /out
COPY --from=build /out ./
# Intentional dir change — the GitHub Action runner does not support relative paths in ENTRYPOINT...
WORKDIR /
ENTRYPOINT ["dotnet", "/out/HexUML.Presentation.GitHubAction.dll"]

