*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           FTTP


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/NETQ/UTILS.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0016_RealizarMudancaVelocidade/ROB0016_RealizarMudancaVelocidade.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/048_MudancaVelocidadeComSucessoSemPendenciaEnderecoMultiplosComplementos.xlsx


*** Test Cases ***

48.01 - Gerar token de acesso
    Retornar Token Vtal

48.02/03 - Realizar abertura de OS de Mudança de Velocidade
    Mudar Velocidade                        true                                    CatalogADD=400                          CatalogREMOVE=1000

48.04 - Validar Conclusão da OS de Mudança de Velocidade via SOM
    Valida Mudanca Velocidade SOM           400                                     1000

48.05 - Valida Notificação de Mundaça de Velocidade no FW Console 
    Verificar mudanca de Velocidade

    
    
   