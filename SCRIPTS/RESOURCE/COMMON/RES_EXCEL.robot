*** Settings ***
Library                                     RPA.Excel.Files
Library                                     RPA.Excel.Application             
Library                                     OperatingSystem        
Library                                     JSONLibrary


*** Variable ***
${DAT_CENARIO}                                                                      #Dat usada para o cenário
${MAX_COLUNAS}                              60                                      #Numero máximo de colunas da tabela de parametro + 1
${MAX_LINHAS}                               20                                      #Numero máximo de colunas da tabela de parametro + 1
${NumLinha}                                 2

***Keywords***
Escrever Variavel na Planilha
    [Documentation]                         Keyword responsável por realizar a escrita de valores em determinada coluna na planilha de parâmetros.                   
    ...                                     \nRetorna erro caso a coluna não exista.
    [Arguments]                             ${Valor}                                ${NomeColuna}                          ${NomeAba}

    ${Extensao}=                            Split String                            ${DAT_CENARIO}                          .

    IF  "${Extensao[1]}" == "json"
        ${Json}=    	                    Load Json from file	                    ${DAT_CENARIO}                          UTF-8                  
        ${Json}=                            Update value to Json                    ${Json}                                 $.Dados[${NumLinha}]..${NomeColuna}     ${Valor}
        Dump Json To File                   ${DAT_CENARIO}                          ${Json}                                 UTF-8  
    ELSE 
        RPA.Excel.Files.Open Workbook       ${DAT_CENARIO}                          data_only=True                         

        FOR    ${i}    IN RANGE    ${1}    ${MAX_COLUNAS}
            ${Coluna}                       Get Cell Value                          row=1                                   column=${i}                             name=${NomeAba}
            ${Passed}                       Run Keyword And Return Status           Should Be Equal                         ${Coluna}                               ${NomeColuna}
            Exit For Loop If                ${Passed}
        END

        Run Keyword If                      ${Passed} == False                      Fail                                    Função percorreu ${MAX_COLUNAS} colunas e não encontrou a coluna ${NomeColuna} desejada
        Set Cell Value                      row=${NumLinha}                         column=${i}                             value=${Valor}                          name=${NomeAba}
        Save Workbook
        Close Workbook
    END                           

#===================================================================================================================================================================
Ler Variavel na Planilha
    [Documentation]                         Keyword responsável por realizar a leitura de valores de determinada coluna da planilha
    ...                                     \nRetorna erro caso a coluna não exista.
    [Arguments]                             ${NomeColuna}                           ${NomeAba}=Global

    ${Extensao}=                            Split String                            ${DAT_CENARIO}                          .

    IF  "${Extensao[1]}" == "json"
        ${Json}=    	                    Load Json from file	                    ${DAT_CENARIO}                                                
        ${Valor}=                           Get Value From Json                     ${Json}                                 $.Dados[${NumLinha}]..${NomeColuna}
        IF      "${Valor[0]}" == ""       
            ${Valor[0]}=                    Set Variable                            None
        END
        ${Valor}=                           Set Variable                            ${Valor[0]}
    ELSE    
        RPA.Excel.Files.Open Workbook           ${DAT_CENARIO}                          data_only=True                         

        FOR    ${i}    IN RANGE    ${1}    ${MAX_COLUNAS}
            ${Coluna}                       Get Cell Value                          row=1                                   column=${i}                             name=${NomeAba}
            ${Passed}                       Run Keyword And Return Status           Should Be Equal                         ${Coluna}                               ${NomeColuna}
            Exit For Loop If                ${Passed}
        END

        Run Keyword If                      ${Passed} == False                      Fail                                    Função percorreu ${MAX_COLUNAS} colunas e não encontrou a coluna ${NomeColuna} desejada
        ${Valor}                            Get Worksheet Value                     row=${NumLinha}                         column=${i}                             name=${NomeAba}
        Close Workbook
    END
    [Return]                                ${Valor}

#===================================================================================================================================================================
Ler Variavel Param Global
    [Documentation]                         Keyword responsável por realizar a leitura de valores do json PARAM GLOBAL
    [Arguments]                             ${Path}                      

    Set Log Level                           NONE
    ${Json}=    	                        Load Json from file	                    ${CURDIR}${/}..${/}..${/}..${/}DATA${/}Param_Global.json
    ${Valor}=                               Get Value From Json                     ${Json}                                 ${Path}
    Set Log Level                           TRACE
    [Return]                                ${Valor[0]}

#===================================================================================================================================================================
Escrever Variavel Param Global
    [Documentation]                         Keyword responsável por realizar a escrita de valores do json PARAM GLOBAL
    [Arguments]                             ${Path}                                 ${Valor}                    

    Set Log Level                           NONE
    ${Json}=    	                        Load Json from file	                    ${CURDIR}${/}..${/}..${/}..${/}DATA${/}Param_Global.json
    ${Json}=                                Update Value To Json                    ${Json}                                 ${Path}                                 ${Valor}
    Dump Json To File                       ${CURDIR}${/}..${/}..${/}..${/}DATA${/}param_global.json                        ${Json}                 
    Set Log Level                           TRACE
#===================================================================================================================================================================