*** Settings ***
Library                                     RPA.Excel.Files
Library                                     RPA.Excel.Application             

*** Variable ***
${DAT_CENARIO}                                                                      #Dat usada para o cenário
${PARAM_GLOBAL}                             C:/IBM_VTAL/DATA/Param_Global.xlsx      #Planilha Global
${MAX_COLUNAS}                              60                                      #Numero máximo de colunas da tabela de parametro + 1
${MAX_LINHAS}                               20                                      #Numero máximo de colunas da tabela de parametro + 1
${NumLinha}                                 2

***Keywords***
Escrever Variavel na Planilha
    [Documentation]                         Keyword responsável por realizar a escrita de valores em determinada coluna na planilha de parâmetros.                   
    ...                                     \nRetorna erro caso a coluna não exista.
    [Arguments]                             ${Valor}                                ${NomeColuna}                          ${NomeAba}

    IF  ${PORTAL}
            # Set Global Variable   ${ADDRESS_ID}    ${Valor} 

            #atualizar o endereco como utilizado na tabela de endereços
            # ${check_end}                    Run Keyword And Return Status       Variable Should Exist          ${end}
            # IF  ${check_end}                      
            #     Atualizar Endereco  ${end}
            # END

            # ${DAT_DB}=                         Criar Dat       ${Valor}    ${RESPONSAVEL}
            # Set Global Variable             ${DAT_DB}   ${DAT_DB}

            #Caso o valor seja None, salva empty no banco
            IF  '${Valor}' == "None"
                Set Global Variable   ${Valor}    ${EMPTY} 
            END

            ${DAT_DB}=                      Atualizar Dados Dat By Id       ${DAT_DB}   ${NomeColuna}  ${Valor}

    #Normal para excel
    ELSE
        RPA.Excel.Files.Open Workbook           ${DAT_CENARIO}                          data_only=True                         

        FOR    ${i}    IN RANGE    ${1}    ${MAX_COLUNAS}
            ${Coluna}                           Get Cell Value                          row=1                                   column=${i}                             name=${NomeAba}
            ${Passed}                           Run Keyword And Return Status           Should Be Equal                         ${Coluna}                               ${NomeColuna}
            Exit For Loop If                    ${Passed}
        END

        Run Keyword If                          ${Passed} == False                      Fail                                    Função percorreu ${MAX_COLUNAS} colunas e não encontrou a coluna ${NomeColuna} desejada

        Set Cell Value                          row=${NumLinha}                         column=${i}                             value=${Valor}                          name=${NomeAba}
        
        Save Workbook
        [Teardown]                              Close Workbook
    END
#===================================================================================================================================================================
Ler Variavel na Planilha
    [Documentation]                         Keyword responsável por realizar a leitura de valores de determinada coluna da planilha
    ...                                     \nRetorna erro caso a coluna não exista.
    [Arguments]                             ${NomeColuna}                           ${NomeAba}
     IF  ${PORTAL}
    
        IF  '${DAT_DB}' != '${EMPTY}'
            ${Query}=                       Buscar Campo Dat Id                     ${DAT_DB}                            
            Log     ${Query}
            ${Valor}=                       Set Variable                            ${Query.${NomeColuna}}
        END

        # Set Global Variable                  ${Valor}                                ${DAT_DB.${NomeColuna}}

        IF  '${Valor}' == '${EMPTY}'
            Set Global Variable                     ${Valor}                            None
        END 
    ELSE
        RPA.Excel.Files.Open Workbook           ${DAT_CENARIO}                          data_only=True                         

        FOR    ${i}    IN RANGE    ${1}    ${MAX_COLUNAS}
            ${Coluna}                           Get Cell Value                          row=1                                   column=${i}                             name=${NomeAba}
            ${Passed}                           Run Keyword And Return Status           Should Be Equal                         ${Coluna}                               ${NomeColuna}
            Exit For Loop If                    ${Passed}
        END

        Run Keyword If                          ${Passed} == False                      Fail                                    Função percorreu ${MAX_COLUNAS} colunas e não encontrou a coluna ${NomeColuna} desejada

        ${Valor}                                Get Worksheet Value                     row=${NumLinha}                         column=${i}                             name=${NomeAba}

        [Teardown]                              Close Workbook
    END
    [Return]                                ${Valor}
#===================================================================================================================================================================
Ler Variavel Param Global
    [Documentation]                         Keyword responsável por realizar a leitura de valores de determinada coluna da planilha PARAN GLOBAL
    ...                                     \nRetorna erro caso a coluna não exista.
    [Arguments]                             ${NomeColuna}                           ${NomeAba}
    IF  ${PORTAL}
        ${Data}                             Ler Global DB                           ${AUTHENTICATION}    
        ${Valor}=                           Set Variable                            ${Data.${NomeColuna}}
    ELSE
        RPA.Excel.Files.Open Workbook           ${PARAM_GLOBAL}                         data_only=True                         

        FOR    ${i}    IN RANGE    ${1}    ${MAX_COLUNAS}
            ${Coluna}                           Get Cell Value                          row=1                                   column=${i}                             name=${NomeAba}
            ${Passed}                           Run Keyword And Return Status           Should Be Equal  ${Coluna}  ${NomeColuna}
            Exit For Loop If                    ${Passed}
        END

        Run Keyword If                          ${Passed} == False                      Fail                                    Função percorreu ${MAX_COLUNAS} colunas e não encontrou a coluna ${NomeColuna} desejada
        ${Valor}                                Get Worksheet Value                     row=2                                   column=${i}                             name=${nome_aba}
        
        [Teardown]                              Close Workbook
    END
    [Return]                                ${Valor}
#===================================================================================================================================================================
Salvar Crendencial na Planilha
    [Arguments]                             ${Valor}                           

    RPA.Excel.Application.Open Application                                          False
    RPA.Excel.Application.Open Workbook                                             ${PARAM_GLOBAL}                                   

    FOR    ${i}    IN RANGE    ${1}    ${MAX_COLUNAS}
        ${Coluna}                           Read From Cells                         worksheet=Global                        row=1                                   column=${i}                           
        ${Passed}                           Run Keyword And Return Status           Should Be Equal  ${Coluna}  Credencial
        Exit For Loop If                    ${Passed}
    END

    Run Keyword If                          ${Passed} == False                      Fail                                    Função percorreu ${MAX_COLUNAS} colunas e não encontrou a coluna Credencial desejada

    Write To Cells                          worksheet=Global                        row=2                                   column=${i}                             value=${Valor}      
    Save excel
    Sleep                                   2s
    [Teardown]                              RPA.Excel.Application.Quit Application

#===================================================================================================================================================================