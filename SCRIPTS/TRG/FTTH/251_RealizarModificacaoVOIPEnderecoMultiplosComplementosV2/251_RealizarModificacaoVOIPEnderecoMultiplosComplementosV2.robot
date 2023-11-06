*** Settings ***

Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0044_ModificacaoVoip/ROB0044_ModificacaoVoip.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/251_RealizarModificacaoVOIPEnderecoMultiplosComplementosV2.xlsx


*** Test Cases ***
251.01 - Gerar Token de Acesso 
    Retornar Token Vtal

251.02 - Realizar Modificação Voip
    Realizar Modificacao BL + Voip

251.03 - Validar o Recebimento da Notificação de Modificação via Auditoria - SOA 
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<

    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     XPATH_XML=//*[text()="Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>Ordem Encerrada com Sucesso<

251.04 - Realizar Validação no SOM 
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}               ${SOM_Cliente_idContrato}               

    @{RETORNO}=                             Create List                             associatedDocument                      subscriberId                            

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Modificação	
    ...                                     ORDER_STATE=Completed
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
