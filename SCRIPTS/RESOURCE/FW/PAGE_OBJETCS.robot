*** Settings ***
Documentation                               Objetos da página do FWConsole


*** Variables ***

#Login Page
${input_userFW}                             (//input[@name='id'])[1]
${input_passFW}                             (//input[@name='senha'])[1]
${login_button}                             //button[@type='submit'][contains(.,'Login')]

#Auditoria ELK
${btn_auditoria_ELK}                        //span[@class='menu-text'][contains(.,'Auditoria ELK')]
${service_filter}                           //input[contains(@id,'s2id_autogen1')]
${input_texto_consulta}                     //input[@placeholder='Texto de Consulta...']
${document_filter}                          //input[@placeholder='Texto de Consulta...']  
${refresh_button}                           //button[contains(.,'Atualizar')]
${appointment_post}                         (//a[contains(.,'Appointment.PostAppointment')])[1]
${appointment_error}                        //div[@class='timeline-container']//div//div//h5[contains(.,'ERROR - Erro ocorrido no servico')]
${xml_retorno}                              (//div[contains(.,'END - Finalização do serviço')])[12]//div//div//div//textarea
${xml_start}                                //*[text()="START - Inicialização do serviço"]/../..//textarea
${CancelAppointment}                        (//a[contains(.,'Appointment.CancelAppointment')])[1]
${post_product_order}                       (//a[text()="ProductOrdering.PostProductOrder"])[1]
${post_product_orderV2}                     (//a[text()="ProductOrdering.PostProductOrder.v2"])[1]
${post_product_orderV25}                    (//a[text()="ProductOrdering.PostProductOrder.v2.5"])[1]
${select_number}                            //select[@name="sample-table-2_length"]
${GetSearchTimeSlot}                        //html/body/div[2]/div[2]/div/div[2]/div[2]/div/div[2]/div/div/table/tbody/tr[1]/td[4]/a
${GetAppointment}                           (//a[contains(.,'Appointment.GetAppointment')])[1]
${ConfirmarSlotAgendamento}                 (//a[contains(.,'ClienteOperacao.ConfirmarSlotAgendamentoFibra')])[1]
${ListenerProductOrder}                     (//a[contains(.,'ProductOrdering.ListenerProductOrderStateChangeEvent')])[1]
${PatchAppointment}                         (//a[contains(.,'Appointment.PatchAppointment')])[1]  
${ProductOrderCreateEvent}                  //td[contains(.,'ProductOrdering.ListenerProductOrderCreateEvent')]/a
${EncerramentoRetiradaComPendencia}         (//a[contains(.,'ProductOrdering.ListenerProductOrderInformationRequiredEvent')])[1]
${PatchProductOrder}                        (//a[contains(.,'ProductOrdering.PatchProductOrder')])[1]
${PatchAppointment}                         (//a[contains(.,'Appointment.PatchAppointment')])[1]
${WorkOrderValueChange}                     //a[text()="WorkOrderManagement.ListenerWorkOrderAttributeValueChangeEvent"]
${WorkOrderTextInvoke}                      //h5[contains(text(),"INVOKE - Request enviado à fila do SOA")]/../..//textarea
${ClienteOperacaoTextInvoke}                //*[text()="INVOKE - Request enviado para o ClienteOperacao.ConfirmarSlotAgendamento"]/../..//textarea
${WorkOrderStateChange}                     //h5[contains(text(),"INVOKE - Request enviado ao API Gateway")]/../..//textarea

${xml_retorna}                              (//textarea[contains(text(),"<msg:type>200<")])
