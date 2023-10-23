*** Settings ***
Documentation                               Script para troca de CDOE via SOM.

Library                                     String

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/COMMON/RES_LOG.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_SOM}/PAGE_OBJECTS.robot


*** Keywords ***
Trocar CDOE via SOM
    [Documentation]                         Realizar a troca de CDOE via SOM.
    [Arguments]                             ${TENTATIVAS_FOR}=15
    ...                                     ${TENTATIVAS_FOR2}=50

    Login SOM

    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global

    Click Web Element Is Visible            ${SOM_rb_Editor}
    Input Text Web Element Is Visible       ${SOM_Ref_Input}                        ${associatedDocument}
    Sleep                                   3s
    Click Web Element Is Visible            ${SOM_btn_refresh}

    Wait For Elements State                 (//input[contains(@name,'move')])[1]    visible                                 timeout=${TIMEOUT}

    #VALIDA A ATIVIDADE IN PROGRESS
    FOR    ${x}      IN RANGE     ${TENTATIVAS_FOR}
        ${EXIST}=  Run Keyword And Return Status    Wait for Elements State    (//*[normalize-space()="In Progress"])[1]    Visible    10
            IF    ${EXIST} == True

                #VALIDANDO ORDER TYPE "Vtal Fibra Instalação"
                ${ORDER_TYPE_SOM}=          Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Order Type"                            1
                ${ORDER_TYPE_SOM}=          Browser.Get Text                        ${ORDER_TYPE_SOM}
                ${ORDER_TYPE_SOM}=          Strip String                            ${ORDER_TYPE_SOM}
                
                IF    "${ORDER_TYPE_SOM}" != "Vtal Fibra Instalação"
                    IF  ${x} == ${TENTATIVAS_FOR}-1
                        Fatal Error     \nOrder Type não é Vtal Fibra Instalação.
                    END
                    Sleep               10s
                    Click Web Element Is Visible                                ${SOM_btn_refresh}
                ELSE                       
                    BREAK
                END
                
                #VALIDANDO TASK NAME "T037 - Solicitar Troca de CDOE"
                ${TASK_NAME_SOM}=           Get Table Cell Element                  //tr[@class="context-menu-target"]/../..                                        "Task Name"                             1
                ${TASK_NAME_SOM}=           Browser.Get Text                        ${TASK_NAME_SOM}
                ${TASK_NAME_SOM}=           Strip String                            ${TASK_NAME_SOM}

                IF    "${TASK_NAME_SOM}" == "T037 - Solicitar Troca de CDOE"
                    BREAK
                ELSE IF    "${TASK_NAME_SOM}" != "T037 - Solicitar Troca de CDOE"
                    IF    ${x} == ${TENTATIVAS_FOR}-1
                        Fatal Error             \nT037 - Solicitar Troca de CDOE não foi encontrado no SOM
                    END
                    Sleep               10s
                    Click Web Element Is Visible                                ${SOM_btn_refresh}
                END
                

            ELSE
                Click Web Element Is Visible            ${SOM_btn_refresh}
                IF    ${x} == ${TENTATIVAS_FOR}-1
                    Fatal Error             \nAtividade In Progress não foi encontrada no SOM
                END
            END
    END


    Click Web Element Is Visible            (//input[contains(@name,'move')])[1]
    Sleep                                   3s

    # VALIDANDO SOM ORDER ID E SA
    ${OrderExiste}    Run Keyword And Return Status    Ler Variavel na Planilha     somOrderId                              Global
    IF    "${OrderExiste}" == "True"
        ${OrderId}                              Ler Variavel na Planilha                somOrderId                            Global
        IF    "${OrderId}" == "None"
            ${OrderId}                          Browser.Get Text                        ${ValorOrderId}
            Escrever Variavel na Planilha       ${OrderId}                              somOrderId                            Global
        END
    END
    
    ${xpathSAExiste}    Run Keyword And Return Status    Wait for Elements State    ${SOM_Numero_BA}                        Visible                                 timeout=5
    IF    "${xpathSAExiste}" == "True"
        ${SAExiste}         Run Keyword And Return Status    Ler Variavel na Planilha        workOrderId                           Global
        IF    "${SAExiste}" == "True"
            ${NumeroSA}                             Ler Variavel na Planilha                workOrderId                           Global
            IF    "${NumeroSA}" == "None"
                Scroll To Element                   ${SOM_Numero_BA}
                ${NumeroSA}                         Browser.Get Text                        ${SOM_Numero_BA}
                Escrever Variavel na Planilha       ${NumeroSA}                             workOrderId                           Global
            END
        END
    END

    #TROCA CDOE
    ${numero_CDOE_Nova}=                    Set Variable                            1234
    ${TR_tecnico}                           Ler Variavel na Planilha                TRtecnico                               Global

    Input Text Web Element Is Visible       ${SOM_CDOE_Nova}                        ${numero_CDOE_Nova}
    Sleep                                   3s
    Input Text Web Element Is Visible       ${SOM_MatriculaTecnicoSolicitante}      ${TR_tecnico}
    
    Click Web Element Is Visible            ${selectStatus}
    Click Web Element Is Visible            ${btnUpdate}

    Sleep                                   5s
    Click Web Element Is Visible            ${SOM_btn_refresh}


    #VALIDA A ATIVIDADE COMPLETED
    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_from}                       *${associatedDocument}*
    Sleep                                   3s
    Click Web Element Is Visible            ${SOM_btn_search}

    Wait For Elements State                 (//input[contains(@name,'move')])[1]    visible                                 timeout=${TIMEOUT}
    
    FOR    ${x}      IN RANGE     ${TENTATIVAS_FOR2}
        ${EXIST}=  Run Keyword And Return Status    Wait for Elements State    (//*[normalize-space()="Completed"])[1]    Visible    10
            IF    ${EXIST} == True

                #VALIDANDO ORDER TYPE "Vtal Fibra Troca de CDOE"
                ${ORDER_TYPE_SOM}=  Run Keyword And Return Status    Wait for Elements State    //tr[@class="context-menu-target"]/../..//*[normalize-space()="Vtal Fibra Troca de CDOE"]   Visible    10
                
                IF    "${ORDER_TYPE_SOM}" != "True"
                    IF  ${x} == ${TENTATIVAS_FOR2}-1
                        Fatal Error     \nOrder Type não é Vtal Fibra Troca de CDOE.
                    END
                    Sleep               10s
                    Click Web Element Is Visible                                ${SOM_btn_refresh}
                ELSE                       
                    BREAK
                END

            ELSE
                Click Web Element Is Visible            ${SOM_btn_refresh}
                IF    ${x} == ${TENTATIVAS_FOR2}-1
                    Fatal Error             \nAtividade Completed não foi encontrada no SOM
                END
            END
    END


    #VALIDA A TASK "TA - Desconfigurar VoIP IMS (SP - Desconfigurar VoIP IMS)"
    Click Web Element Is Visible            ${SOM_rb_ProcessHistory}
    Click Web Element Is Visible            (//input[contains(@name,'move')])[2]
    Sleep                                   3s

    Click Web Element Is Visible            ${SOM_Detailed_Table}
    Scroll To Element                       ${SOM_Task_DesconfigVoipIMS}
    Take Screenshot Web Element is visible                                          ${SOM_Task_DesconfigVoipIMS}

    Close Browser                           CURRENT
