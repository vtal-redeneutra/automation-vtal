*** Settings ***
Documentation                               Script para encerramento via SOM.

Library                                     String

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_SOM}/PAGE_OBJECTS.robot


*** Keywords ***
Tramitar ate encerramento da ordem via SOM

    ${UsuarioSOM}=                          Ler Variavel Param Global               $.Logins.SOM.Usuario                             
    ${trUsuarioSOM}=                        Convert To Lower Case                   ${UsuarioSOM}
    ${Associated_Document}=                 Ler Variavel na Planilha                associatedDocument                      Global

    Login SOM

    Input Text Web Element Is Visible       ${SOM_Ref_Input}                        ${Associated_Document}
    Click Web Element Is Visible            ${SOM_btn_search}
    Click Web Element Is Visible            ${SOM_rb_Preview}  
    Right Click Web Element Is Visible      ${SOM_btn_tres_pontos}
    Click Web Element Is Visible            ${SOM_btn_change_taskState_status}
    Select Element is Visible               ${SOM_btn_assignedUser}                 ${trUsuarioSOM}
    Click Web Element Is Visible            ${SOM_btn_selectAssigned}
    Click Web Element Is Visible            ${SOM_btn_updateTaskName}

    Input Text Web Element Is Visible       ${SOM_Ref_Input}                        ${Associated_Document}
    Click Web Element Is Visible            ${SOM_btn_search}
    Sleep                                   5s
    Click Web Element Is Visible            ${SOM_btn_tres_pontos}

    Input Text Web Element Is Visible       ${SOM_Matricula_Tecnico}                TR724241
    Input Text Web Element Is Visible       ${SOM_Codigo_Encerramento}              00000
    Input Text Web Element Is Visible       ${SOM_BilheteAtividade_Observacoes}     Encerramento com Sucesso
    Sleep                                   5s
    Select Element is Visible               ${SOM_Equipamento_Extraviado}           Não
    Sleep                                   5s
    Click Web Element Is Visible            ${SOM_btn_AdicionarTecAuxiliar}
    Sleep                                   5s
    Input Text Web Element Is Visible       ${SOM_Nome_TecAuxiliar}                 Ana Luiza Cerqueira
    Input Text Web Element Is Visible       ${SOM_Matricula_TecAuxiliar}            TR343768
    Select Element is Visible               ${SOM_Select_pendencia}                 Sucesso
    Click Web Element Is Visible            ${SOM_btnUpdate}
    Sleep                                   5s
    Close Browser                           CURRENT