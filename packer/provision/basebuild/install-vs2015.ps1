echo "Installing Visual Studio 2015"

#choco install -y VisualStudio2015Community
#choco install -y VisualStudio2015Professional
#choco install -y visualstudio2015-update

#choco install -y vcredist2015

choco install -y vcbuildtools -ia "/Full"

# TODO: check $PATH for expected utilities

echo "Visual Studio 2015 Installed"