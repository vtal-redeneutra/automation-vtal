*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number, Customer_Name, Phone_Number, Reference, 
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,


Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/012_AgendamentoRetiradaComSlotExpirado.xlsx


*** Test Cases ***
12.01 - Gerar Token de Acesso
    Retornar Token Vtal

12.02-3 - Realizar Consulta de Logradouro
    Consulta Id Logradouro

12.04 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos

12.05 - Realizar Consulta de Slots
    Retornar Slot Agendamento Vazio Retirada

12.06 - Realizar Validação no FW
    Validar Evento FW                       VALOR_BUSCA=addressId
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.GetSearchTimeSlot'])[1]
    ...                                     RETORNO_ESPERADO=>404<