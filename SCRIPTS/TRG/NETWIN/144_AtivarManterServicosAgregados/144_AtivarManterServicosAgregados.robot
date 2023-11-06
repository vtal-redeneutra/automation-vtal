*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/NETWIN/UTILS.robot
Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/144_AtivarManterServicosAgregados.xlsx


*** Test Cases ***

144.01-6 - Ativar Serviço Agregado Ethernet
    Logar Netwin
    Ativar Serviço Agregado Ethernet

144.07-12 - Consultar Serviço Agregado Ethernet 
    Consultar Serviço Agregado Ethernet
    
144.13-19 - Alterar Serviço Agregado Ethernet                          
    Alterar Serviço Agregado Ethernet

144.20-26 - Cessar Serviço Agregado Ethernet
    Cessar Servico Agregado Ethernet