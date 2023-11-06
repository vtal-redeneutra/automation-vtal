*** Settings ***
Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_API}/RES_API.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_ROBS}/ROB0028_AgendamentoDeRetirada/ROB0028_AgendamentoDeRetirada.robot
Resource                                    ${DIR_ROBS}/ROB0029_CriarOrdemDeRetirada/ROB0029_CriarOrdemDeRetirada.robot
Resource                                    ${DIR_ROBS}/ROB0046_TramitarOrdemSomEncerramento/ROB0046_TramitarOrdemSomEncerramento.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/181_RetiradaComEncerramentoExternoViaSOM.xlsx


*** Test Cases ***
181.01 - Gerar Token de Acesso 
    Retornar Token Vtal

181.02 - Realizar Consulta de Slots
    Retornar Slot Agendamento Retirada

181.03 - Realizar o Agendamento
    Realizando Agendamento Retirada

181.04 - Validar a Notificação do Agendamento
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

181.05 - Validar agendamento no FSL
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar a Criação do SA de Retirada
    Close Browser                           CURRENT

181.06 - Realizar a Criação de Ordem (OS)
    Criar Ordem de Retirada                 FTTH_ou_FTTP=FTTH                       VELOCIDADE=400

181.07 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='WorkOrderManagement.NotificationCreatedOrder'])[1]
    ...                                     RETORNO_ESPERADO=>200<

181.08 - Validar a Criação da OS de Retirada via SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    ${SOM_Numero_SA}                        

    @{RETORNO}=                             Create List                             associatedDocument                      workOrderId                           

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T063 - Retirar Equipamento
    ...                                     ORDER_TYPE=Vtal Fibra Retirada
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

181.09 - Validação FSL
    Validar a Criação do SA de Retirada
    Close Browser                           CURRENT

181.10 - Validar no Field Service
    Valida SA no Field Service

181.11 - Tramitar no SOM OS até o encerramento
    Tramitar ate encerramento da ordem via SOM

181.12 - Validar encerramento de OS no SOM
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Retirada
    ...                                     ORDER_STATE=Completed

181.13 - Validar encerramento do OS no FW
    Validar Evento FW                       VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     RETORNO_ESPERADO=>204<