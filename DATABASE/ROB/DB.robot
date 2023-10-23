*** Settings ***
Library                                     ..${/}endereco.py
Library                                     ..${/}dat.py
Library                                     ..${/}globals.py



*** Keywords ***

Inicia CT
    ${PORTAL}                       Run Keyword And Return Status       Variable Should Exist          ${PORTAL}
    ${check_step}                   Run Keyword And Return Status       Variable Should Exist          ${STEP}
    Set Global Variable             ${PORTAL}                           ${PORTAL}
    IF  ${PORTAL} 
        Log     ${CEP}
        Log     ${NUMERO}
        Run Keyword If                  ${check_step}                       Set Step                       ${STEP}
        Set Global Variable             ${RESPONSAVEL}                      ${RESPONSAVEL}
        Set Global Variable             ${AUTHENTICATION}                   ${AUTHENTICATION}
        ${DAT_DB}                       Buscar Dat Do Usuario               ${RESPONSAVEL}                 ${STEP}
        # IF  ${DAT_DB}
        #     Set Global Variable                 ${ADDRESS_ID}                   ${DAT_DB.addressId}
        # END
        Set Global Variable             ${DAT_DB}                           ${DAT_DB}
    END

    
Fecha CT
    [Arguments]     ${SYSTEM}       ${NEW_STEP}     
    IF  ${PORTAL}                      
        Log     ${DAT_DB}
        Atualizar Steps Dat                 ${DAT_DB}                   ${RESPONSAVEL}      ${SYSTEM}       ${NEW_STEP}
    END

Set Step
    [Arguments]   ${STEP}
    Set Global Variable     ${STEP}           ${STEP}


Criar Tabela Execucao
    [Arguments]                             ${RESPONSAVEL}
    ${DAT_DB}=                              Criar Dat                               ${RESPONSAVEL}
    Set Global Variable                     ${DAT_DB}