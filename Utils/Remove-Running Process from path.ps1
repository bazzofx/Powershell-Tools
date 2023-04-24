$_INSTALL_PATH = "C:\Users\Paulo.Bazzo\OneDrive - FitzRoy\Documents\FitzRoy"
get-process | foreach{
          $pName = $_
          if ( $pName.Path -like ( $INSTALL_PATH + '*') ) {
            Stop-Process $pName.id -Force -ErrorAction SilentlyContinue
          }
        }
       Remove-Item  -Force -Recurse $INSTALL_PATH