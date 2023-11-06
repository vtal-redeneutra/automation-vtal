*** Settings ***
Documentation                               Validar Tasks de Ordem SOM
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/SOM/UTILS.robot

Resource                                    ../../RESOURCE/SOM/PAGE_OBJECTS.robot

Library                                     Browser
Library                                     String


*** Variables ***
# ${DAT_CENARIO}                            C:/IBM_VTAL/DATA/DAT013_RealizarAtivacaoCanceladaAntesAtividadeCampo.xlsx
${APPOINTMENTSTART}


# *** Test Cases ***
# cenario OS
#     Valida Campo OS

*** Keywords ***
Validar Tasks Ordem SOM
    [Documentation]                         Valida Tasks da Ordem no SOM.
    [Tags]                                  ValidaTasksSOM

    Login SOM
    Altera Filtro Consulta Order ID
    Valida Campo OS

#===================================================================================================================================================================