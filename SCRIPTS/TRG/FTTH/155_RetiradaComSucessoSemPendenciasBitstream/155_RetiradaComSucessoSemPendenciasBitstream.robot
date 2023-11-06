*** Settings ***
Documentation                                   Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Work_Order_Id - Associated_Document_Date - Associated_Document - MaxBandWidth - LyfeCycleStatus - Customer_Name  - CorrelationOrder - InfraType - InventoryId - Reference - Action
...                                         OUTPUT: 

Suite Setup                                 Setup cenario                           Bitstream

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/SOM/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0029_CriarOrdemDeRetirada/ROB0029_CriarOrdemDeRetirada.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/155_RetiradaComSucessoSemPendenciasBitstream.xlsx


*** Test Cases ***
155.1 - Gerar Token de Acesso
    Retornar Token Vtal

155.2 - Realizar abertura da Ordem de Retirada
    Criar Ordem de Retirada                 VELOCIDADE=400                          bit_true_false=true    

155.3 - Realizar Validação de Notificação FW
    Validar Criação da Ordem                                                        order_type=Retirada 
    
155.4 - Realização Validação no SOM
    Validar Ordem SOM Retirada Completa     FTTH                                    400                                     true