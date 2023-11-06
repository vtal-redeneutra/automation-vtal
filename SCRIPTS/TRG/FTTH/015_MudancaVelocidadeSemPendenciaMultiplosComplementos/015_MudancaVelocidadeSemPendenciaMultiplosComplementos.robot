*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number, CancelAppointmentReason, CancelAppointmentComments
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3, SOM_Order_Id

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/MS/UTILS.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0016_RealizarMudancaVelocidade/ROB0016_RealizarMudancaVelocidade.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/015_MudancaVelocidadeSemPendenciaMultiplosComplementos.xlsx


*** Test Cases ***
15.01 - Gerar Token de Acesso 
    Retornar Token Vtal

15.02 - Realizar a abertura de uma OS de Mudança de Velocidade
    Mudar Velocidade                        Complements_true_false=true             CatalogADD=BL_1000MB                    CatalogREMOVE=BL_400MB

15.03 - Validar Conclusão da OS de Mudança de Velocidade via SOM
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}               ${SOM_infraType}                                              
    ...                                     ${SOM_Ordem_tipo}                       ${SOM_Cliente_idContrato}                                                                                                            
                                                                                                           
    @{RETORNO}=                             Create List                             associatedDocument                      infraType                                
    ...                                     Type                                    subscriberId                                                      

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_STATE=Completed	
    ...                                     ORDER_TYPE=Vtal Fibra Modificacao de Velocidade	
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

15.04 - Validar o Recebimento da Notificação de Mudança de Velocidade via Microserviços
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderStateChangeEvent referente ao associatedDocument
    Validar texto do Bloco com o Argumento    END - Finalização do serviço      204