*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario


Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/006_AtivacaoComSlotExpirado.xlsx


*** Test Cases ***

06.01 - Gerar Token de Acesso
    Retornar Token Vtal

06.02-03 - Realizar Consulta de Logradouro
    Consulta Id Logradouro

06.4 - Realizar Consulta de Viabilidade 
    Retorna Viabilidade dos Produtos

06.5 - Realizar Consulta de Slots
    Retornar Slot Agendamento Vazio
    
06.6 - Realizar Validação no FW
    Validar Evento FW                       VALOR_BUSCA=addressId    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.GetSearchTimeSlot'])[1]    
    ...                                     RETORNO_ESPERADO=>404<