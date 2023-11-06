*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
    ...                                     INPUT: Address, Number, Customer_Name, Phone_Number, Reference, 
    ...                                     OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,


Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/SOM/UTILS.robot
Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_MS}/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0028_AgendamentoDeRetirada/ROB0028_AgendamentoDeRetirada.robot
Resource                                    ${DIR_ROBS}/ROB0029_CriarOrdemDeRetirada/ROB0029_CriarOrdemDeRetirada.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/171_ModificacaoVoipMultiplosComp.xlsx


*** Test Cases ***

171.01 - Gerar Token de Acesso 
    Retornar Token Vtal

171.02 - Realizar Consulta de Slots Para Atividade de Retirada
    Retornar Slot Agendamento Retirada

171.03 - Realizar Agendamento de Retirada
    Realizar Agendamento de Retirada 

171.04 - Validar Notificação do Agendamento no Microserviços
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por Appointment.PostAppointment referente ao associatedDocument
    Validar texto do Bloco com o Argumento    INVOKE - Request enviado para o ClienteOperacao.ConfirmarSlotAgendamento      <tns:tipoAtividade>407</tns:tipoAtividade>                 Sucesso

171.05 - Validar Criação de Agendamento no FSL
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar a Criação do SA de Retirada

171.06 - Realizar Abertura da Ordem de Retirada    
    Criar Ordem de Retirada VOIP
   
171.07 - Validar Notificação de Criação da Ordem no Microserviços
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderCreateEvent referente ao associatedDocument
    Extrair dado do Bloco                   START - Inicialização do serviço        id                                      somOrderId
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço     msg:Description                         Sucesso

171.08 - Realizar Validação no SOM
    @{Validacoes}=                          Create List                             ${SOM_Ordem_numeroPedido}                               

    @{Retorno}=                             Create List                             associatedDocument                                                           

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=Vtal Fibra Retirada order entry task	
    ...                                     ORDER_TYPE=Vtal Fibra Retirada
    ...                                     ORDER_STATE=Cancelled
    ...                                     RETORNO_ESPERADO=${Retorno}
    ...                                     XPATH_VALIDACOES=${Validacoes}

171.09 - Validar Notificação de Cancelamento da Ordem no Microserviços
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por SingleNotificationManagement.SOM referente ao associatedDocument
    Validar texto do Bloco com o Argumento    Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]       <notification_type>Cancelamento</notification_type>
