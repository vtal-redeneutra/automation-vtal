*** Settings ***
Documentation  arquivo de variaveis do App CE_MOBILE


*** Variables ***
#====================================================================================================================================
#VARIABLES
#====================================================================================================================================
${REMOTE_URL}                               http://localhost:4723/wd/hub
${platformName}                             Android
${cemobile:deviceName}                      127.0.0.1:5555
${cemobile:udid}                            127.0.0.1:5555
${cemobile:appPackage}                      pt.ptinovacao.nwosp.cemobilea
${cemobile:appActivity}                     pt.ptinovacao.nwosp.cemobilea.CEMobileASplashScreen
${TIMEOUT}  60
#====================================================================================================================================
#END VARIABLES
#====================================================================================================================================
