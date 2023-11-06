*** Settings ***
Documentation                               Validação de pendência FWConsole
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot

Resource                                    ../../RESOURCE/FW/UTILS.robot


          

*** Variables ***

${date}
${correlationOrder}
${associatedDocument}
${observation}
${action}
${userId}


*** Keywords ***
Validando PendênciaFW
    [Documentation]                         Keyword encadeador TRG 
    ...                                     \n Função usada para validar se existe alguma pendência no sistema FWConsole, através do ``productOrdering.PatchProductOrder`` 
    ...                                     e associatedDocument.
    [Tags]                                  ValidarPendênciaFW

    Retornar Token Vtal
    Validação da PendênciaFW

#===================================================================================================================================================================
Validação da PendênciaFW
    [Documentation]                         Função usada para validar se existe alguma pendência no sistema FWConsole, através do ``productOrdering.PatchProductOrder`` 
    ...                                     e associatedDocument.



    [Tags]                                  ValidaPedenciaFW

    ${associatedDocument}=                  Ler Variavel na Planilha                Associated_Document                     Global


    Login FWConsole

    Wait For Elements State                 xpath=//a[@href='auditoriav2'][contains(.,'Auditoria ELK')]                     visible
    Click                                   xpath=//a[@href='auditoriav2'][contains(.,'Auditoria ELK')]    
    
    Wait For Elements State                 xpath=//div[@id='sample-table-2_length']                                        visible
    Fill Text                               xpath=${service_filter}                                                         ProductOrdering.PatchProductOrder    
    Keyboard Key                            press                                   Enter
    Fill Text                               xpath=${document_filter}                ${associatedDocument}
    Sleep    2
    Click                                   xpath=${refresh_button}  

    Wait For Elements State                 xpath=//a[contains(.,'ProductOrdering.PatchProductOrder')]                      visible
    Click                                   xpath=//a[contains(.,'ProductOrdering.PatchProductOrder')]

    Close Page                              CURRENT                                 CURRENT                                 CURRENT

    Sleep    2

    Wait For Elements State                 xpath=(//i[contains(@class,'ace-icon fa fa-chevron-down')])[5]                  visible
    Click                                   xpath=(//i[contains(@class,'ace-icon fa fa-chevron-down')])[5]

    ${xmlInvoke_SOM}=                       Get Text                                xpath=//textarea[@id='xml_text3']
    
    Should Contain                          ${xmlInvoke_SOM}                        <com_order_service>${associatedDocument}</com_order_service>
    Should Contain                          ${xmlInvoke_SOM}                        <crm_solicitation>${associatedDocument}</crm_solicitation>
    Should Contain                          ${xmlInvoke_SOM}                        <observation>Resolu��o de pend�ncia de agendamento</observation>              Provável erro nos caracteres "ç"/"ã"/"ê"
    Should Contain                          ${xmlInvoke_SOM}                        <notification_action>fechar</notification_action>

    Click                                   xpath=(//i[contains(@class,'ace-icon fa fa-chevron-down')])[4]

    ${xmlEndService}=                       Get Text                                xpath=//textarea[@id='xml_text7']

    Should Contain                          ${xmlEndService}                        <tns:code>200</tns:code>
    Should Contain                          ${xmlEndService}                        <tns:message>Ok</tns:message>

    Close Browser                           CURRENT

#===================================================================================================================================================================

    




    
    
