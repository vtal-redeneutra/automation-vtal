*** Settings ***
Documentation                               Resource geral para criação dos LOGS
Library                                     OperatingSystem
Library                                     DateTime
Library                                     String

# Library                                     ./LIB/lib_geral.py
Library                                     ./LIB/KeywordName.py


*** Variables ***
${PATH}
${VARIAVEL}
${RESPONSE}

*** Keywords ***
Criar Documento LOG
    [Documentation]                         Função usada para criar o Arquivo de Word e PDF no caminho do Resultado da execução para gerar o LOG simplificado.
    ${dt}=                                  Get Current Date       	                exclude_millis=yes                      result_format=%Y%m%d_%H%M%S
    ${Data_Desc}                            Get Current Date                        exclude_millis=yes                      result_format=timestamp
    ${PATH_DOC}=                            Set Variable                            ${PATH_RESULTS}/log_${dt}
    Set Global Variable                     ${PATH_DOC}
    Write Doc File Evidencia                Log da Execução do Cenário ${SUITE_NAME}
    Write Doc File Evidencia                Data de execução: ${Data_Desc}
    Criar Descricao Evidencia

#===================================================================================================================================================================
Criar Descricao Evidencia
    [Documentation]                         Função usada para criar a Descrição com detalhes sobre o cenário para para a evidencia.
    ${Email}=                               Ler Variavel Param Global               Usuario_FSL                             Global
    Write Doc File Evidencia                Fluxo de Teste: ${SUITE_NAME}\n
    Write Doc File Evidencia                Dados de Entrada:
    Write Doc File Evidencia                E-mail do Usuario: ${Email}

#===================================================================================================================================================================
Criar Descricao Defect
    [Documentation]                         Função usada para criar a Descrição com detalhes sobre o cenário para para o defeito.
    ${Email}=                               Ler Variavel Param Global               Usuario_FSL                             Global
    ${Andress_ID}=                          Ler Variavel na Planilha                addressId                               Global
    ${Data_Desc}=                           Get Current Date       	                exclude_millis=yes                      result_format=%Hhrs %Mmin %Ssec
    ${Keyword_Cenario}=                     keyword name
    Write Doc File Defect                   Log da Defeito do Cenário ${SUITE_NAME}
    Write Doc File Defect                   Data de execução: ${Data_Desc}
    Write Doc File Defect                   Fluxo de Teste: ${SUITE_NAME}
    Write Doc File Defect                   E-mail do Usuario: ${Email}

#===================================================================================================================================================================
Salvar Documento Evidencia
    [Documentation]                         Função usada para salvar o arquivo de LOG da evidencia.
    Close Doc File Evidencia                ${PATH_DOC}

#===================================================================================================================================================================
Salvar Documento Defect
    [Documentation]                         Função usada para salvar o arquivo de LOG do defeito.
    ${dt}=                                  Get Current Date       	                exclude_millis=yes                      result_format=%Y%m%d_%H%M%S
    ${Data_Desc}                            Get Current Date                        exclude_millis=yes                      result_format=timestamp
    ${PATH_DOC}=                            Set Variable                            ${PATH_RESULTS}/defect_${dt}
    Set Global Variable                     ${PATH_DOC}
    Close Doc File Defect                   ${PATH_DOC}

#===================================================================================================================================================================
Inserir no Documento Evidencia
    [Documentation]                         Função usada para inserir uma informação no Documento de evidencia juntamente com o horário de execução.
    ...                                     Ex de chamada: 'INSERIR_DOCUMENTO_TXT   Nome: Luiz'
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``INFORMACAO`` | Informação a ser inserida no LOG. exemplo: ``Status Code: ${RESPONSE.status_code}\n``. |
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | Inserir no Documento Evidencia        Status Code: ${RESPONSE.status_code}\n
    [Arguments]                             ${INFORMACAO}
    
    ${Data_Desc}=                           Get Current Date       	                exclude_millis=yes                      result_format=%Hhrs %Mmin %Ssec
    ${VARIAVEL}=                            Set Variable                            \n${INFORMACAO}
    Write Doc File Evidencia                ${VARIAVEL}

 #==================================================================================================================================================================
 Inserir no Documento Defect
    [Documentation]                         Função usada para inserir uma informação no Documento de evidencia juntamente com o horário de execução.
    ...                                     Ex de chamada: 'INSERIR_DOCUMENTO_TXT   Nome: Luiz'
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``INFORMACAO`` | Informação a ser inserida no LOG. exemplo: ``Status Code: ${RESPONSE.status_code}\n``. |
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | Inserir no Documento Evidencia        Status Code: ${RESPONSE.status_code}\n

    #Cria a Descrição do arquivo
    IF  "${Counter_API}" == "0"
        Criar Descricao Defect
    END

    ${INFORMACAO}=                          Set Variable                            ${RESPONSE.json()}
    ${Data_Desc}=                           Get Current Date       	                exclude_millis=yes                      result_format=%Hhrs %Mmin %Ssec
    ${VARIAVEL}=                            Set Variable                            \n${INFORMACAO}\n
    Break page Defect
    Write Doc File Defect                   \n========================================================================================
    Write Doc File Defect                   ${VARIAVEL}
    Write Doc File Defect                   Status Code: ${RESPONSE.status_code}

#===================================================================================================================================================================
Inserir Print OPM no DOC
    [Documentation]                         Função usada para pegar os prints gerados pelo OPM e inserir no LOG.
    Rename and move File OPM                 ${PATH_RESULTS}
    Write OPM Image in Doc File Evidencia    ${PATH_RESULTS}

#===================================================================================================================================================================
Inserir Print CE_MOBILE no DOC
    [Documentation]                         Função usada para pegar os prints gerados pelo CE_MOBILE e inserir no LOG.
    Rename and move File CE_MOBILE                                                  ${PATH_RESULTS}
    Write CE_MOBILE Image in Doc File Evidencia                                     ${PATH_RESULTS}