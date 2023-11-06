*** Settings ***
Documentation                               Scripts cancelar Chamado Tecnico.

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot




*** Keywords ***
Cancelando Chamado Tecnico
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para iniciar a API, permitindo assim fazer as requests via POST com o objetivo retornar sucesso no cancelamento  
    ...                                     do troubleTicket. 
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. |``https://apitrg.vtal.com.br/api/troubleTicket/v1//cancelTroubleTicket/${TroubleTicket}``.|

    Retornar Token Vtal
    Cancelar Chamado Tecnico
#===================================================================================================================================================================
Cancelar Chamado Tecnico
    [Documentation]                         Realização de cancelamento de troubleTicket
    ...                                     \n Função usada para iniciar a API, permitindo assim fazer as requests via POST com o objetivo retornar sucesso no cancelamento  
    ...                                     do troubleTicket.
    ...                                     | ``URL_API`` | A URL base para a criação das requisições. |``https://apitrg.vtal.com.br/api/troubleTicket/v1//cancelTroubleTicket/${TroubleTicket}``.|

    [Tags]                                  CancelarChamadoTecnico
    
    ${TroubleTicket}=                       Ler Variavel na Planilha                troubleTicketId                         Global
    Set Global Variable                     ${TroubleTicket}
        
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global 
    ${associatedDocument}=                  Ler Variavel na Planilha                associatedDocument                      Global
    ${type}=                                Ler Variavel na Planilha                Type                                    Global                      

    ${Response}=                            POST_API                                ${API_BASECANCELTROUBLETICKET}/cancelTroubleTicket/${TroubleTicket}             "troubleTicket": {"type": "${type}","associatedDocument": "${associatedDocument}","customer": {"subscriberId": "${subscriberId}"}}
    
    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code
    
    IF  "${returnedCode[0]}" != "200"
        Log to console     ${Response}
        Fatal Error    Código retornado não é igual a 200.
    END  
#===================================================================================================================================================================
     