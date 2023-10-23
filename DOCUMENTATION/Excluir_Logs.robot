*** Settings ***

Library                                     OperatingSystem



*** Test Cases ***


Excluir Logs
    Excluir Logs                            FTTH
    Excluir Logs                            FTTP
    Excluir Logs                            NETWIN



*** Keywords ***


Excluir Logs
    [Arguments]                             ${Pasta}
    @{Arquivos}=    List Directory            C:/IBM_VTAL/SCRIPTS/TRG/${Pasta}
    FOR    ${i}    IN    @{Arquivos}
        ${ExisteCaminho}=    Run Keyword and Return Status        Directory Should Exist        C:/IBM_VTAL/SCRIPTS/TRG/${Pasta}/${i}/RESULTS
        IF    ${ExisteCaminho}
            Empty Directory        C:/IBM_VTAL/SCRIPTS/TRG/${Pasta}/${i}/RESULTS
        END
    END
   