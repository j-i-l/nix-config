{ pkgs, lib, ... }:
let
  pulse-cookie = pkgs.python3.pkgs.buildPythonApplication rec {
    pname = "pulse-cookie";
    version = "1.0";
    pyproject = true;

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-ZURSXfChq2k8ktKO6nc6AuVaAMS3eOcFkiKahpq4ebU=";
    };

    propagatedBuildInputs = [
      pkgs.python3.pkgs.pyqt6
      pkgs.python3.pkgs.pyqt6-webengine
      pkgs.python3.pkgs.setuptools
      pkgs.python3.pkgs.setuptools_scm
    ];
    build-system = [
      pkgs.python3.pkgs.setuptools
    ];

    preBuild = ''
      cat > setup.py << EOF
      from setuptools import setup

      # with open('requirements.txt') as f:
      #     install_requires = f.read().splitlines()

      setup(
        name='pulse-cookie',
        packages=['pulse_cookie'],
        package_dir={"": 'src'},
        version='1.0',
        author='Raj Magesh Gauthaman',
        description='wrapper around openconnect allowing user to log in through a webkit window for mfa',
        install_requires=[
          'PyQt6-WebEngine',
        ],
        entry_points={
          'console_scripts': ['get-pulse-cookie=pulse_cookie._cli:main']
        },
      )
      EOF
    '';

    meta = with lib; {
      homepage = "https://pypi.org/project/pulse-cookie/";
      description = "wrapper around openconnect allowing user to log in through a webkit window for mfa";
      license = licenses.gpl3;
    };
  };
  pulse-cookie-wrapper = pkgs.runCommand "pulse-cookie-wrapper" {
    buildInputs = [ pkgs.makeWrapper ];
  } ''
    makeWrapper ${pulse-cookie}/bin/get-pulse-cookie $out/bin/get-pulse-cookie \
      --set QT_PLUGIN_PATH "${pkgs.lib.getLib pkgs.qt6.qtbase}/lib/qt-6.2/plugins" \
      --set QML2_IMPORT_PATH "${pkgs.qt6.qtbase}/qml"
  '';
  start-uzh-vpn = pkgs.writeShellScriptBin "start-uzh-vpn" ''
    export QTWEBENGINE_CHROMIUM_FLAGS="--disable-logging"
    HOST=https://remoteaccess.uzh.ch/vpn
    DSID=$(${pulse-cookie}/bin/get-pulse-cookie -n DSID $HOST)
    sudo ${pkgs.openconnect}/bin/openconnect --protocol nc -C DSID=$DSID $HOST
  '';
in
{
  environment.systemPackages = with pkgs; [
    qt6.qtwayland
    openconnect
    start-uzh-vpn
  ];
}
