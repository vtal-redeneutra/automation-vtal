*** Settings ***
Documentation                               MOB Initial

Resource                                    ../../RESOURCE/OPM/UTILS.robot

*** Variables ***

# TESTE CASE APLICA-SE SOMENTE PARA ARQUIVO AGR
*** Test Cases ***
Example MOB INITIAL
    [Documentation]                         Arquivo de examplo para criação de cenários Mobile
    [TAGS]                                  example_mob
    Keyword Example



*** Keywords ***
Keyword Example
    Abrir Aplicativo
