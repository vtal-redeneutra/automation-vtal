*** Settings ***

Suite Setup                                 Setup cenario                           Voip


Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0050_InclusaoVoip/ROB0050_InclusaoVoip.robot

*** Variables ***

${DAT_CENARIO}                              ${DIR_DAT}/252_RealizarModificacaoVoipComComp.xlsx



*** Test Cases ***
252.01 - Gerar Token de Acesso
    Retornar Token Vtal

252.02 - Realizar Modificação Voip (inclusão de voip)
    Realizar inclusão Voip

252.03 - Realizar Validação de Notificação de Modificação via FW Console
    Buscar OS Start XML                     associatedDocument                      (//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]

    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<

252.04 - Realizar Validação no SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    ${SOM_Header_OrderID}
                                   
    @{RETORNO}=                             Create List                             associatedDocument                      somOrderId

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Modificação
    ...                                     ORDER_STATE=Completed
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}