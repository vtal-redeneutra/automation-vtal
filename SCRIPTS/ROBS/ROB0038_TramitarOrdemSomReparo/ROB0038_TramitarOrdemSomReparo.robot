*** Settings ***
Documentation                               Scripts Abertura de Chamado Tecnico.

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot

Resource                                    ${DIR_SOM}/UTILS.robot


*** Keywords ***
Resolver a abertura do chamado tecnico
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para logar no SOM, irá ler na planilha o troubleTicket_id e resolver o reparo conforme número do troubleTicket_id 
    ...                                     retornado anteriormente, após irá aparecer como finalizado no SOM.
    
    Login SOM
    Resolver o Chamado Tecnico

#===================================================================================================================================================================
Resolver o Chamado Tecnico
    [Documentation]                         Realização de abertura de troubleTicket
    ...                                     \n Função usada para logar no SOM, irá ler na planilha o troubleTicket_id e resolver o reparo conforme número do troubleTicket_id 
    ...                                     retornado anteriormente, após irá aparecer como finalizado no SOM.
    
    [Tags]                                  AberturaChamadoTecnico

    ${troubleTicket_id}=                    Ler Variavel na Planilha                troubleTicketId                        Global
    
    Input Text Web Element Is Visible       ${SOM_order_input}                      ${troubleTicket_id}
    Click Web Element Is Visible            ${SOM_btn_search}
    Click Web Element Is Visible            ${SOM_rb_Preview}
    Click Web Element Is Visible            ${SOM_btn_tres_pontos}

    Wait for Elements State                 ${SOM_Ordem_numeroPedido}               Visible

    Click Web Element Is Visible            ${SOM_btn_edit_order}
    Select Element is Visible               ${SOM_Select_pendencia}                 Resolver reparo

    Input Text Web Element Is Visible       ${SOM_resultadoAnalise}                 ONT - Desconfigurada/Divergente
    Input Text Web Element Is Visible       ${SOM_observacao}                       Teste VTAL
    Select Options By                       ${SOM_Select_Motivo_Pendencia}          value                                   Resolução do Reparo
    Input Text Web Element Is Visible       ${SOM_input_Motivo}                     Acao interna realizada na Vtal: Efetuado reset de Fabrica da ONT. | Acao a ser realizada pela Tenant: Reconfigurar rede cliente e realizar novo teste. Certificar que nao ha qualquer tipo de restricao/bloqueio no dispositivo do cliente ou no servidor game.

    Click Web Element Is Visible            ${SOM_btnUpdate}

    Sleep                                   5s
    Close Browser                           CURRENT
#===================================================================================================================================================================