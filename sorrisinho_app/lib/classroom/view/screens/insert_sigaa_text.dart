import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sorrisinho_app/classroom/view_model/classroom.dart';
import 'package:sorrisinho_app/shared/event_tracker.dart';
import 'package:sorrisinho_app/shared/theme.dart';
import 'package:sorrisinho_app/shared/widgets/screen_name.dart';
import 'package:url_launcher/url_launcher.dart';

class InsertSigaaTextScreen extends StatefulWidget {
  final String previousRa;
  const InsertSigaaTextScreen({
    super.key,
    required this.previousRa,
  });

  @override
  State<InsertSigaaTextScreen> createState() => _InsertSigaaTextScreenState();
}

class _InsertSigaaTextScreenState extends State<InsertSigaaTextScreen> {
  late TextEditingController _raTextFieldController;
  late TextEditingController _sigaaTextFieldController;

  @override
  void initState() {
    super.initState();
    EventTracker().sendEvent(eventName: 'insert_sigaa_text_page_viewed');
    _raTextFieldController = TextEditingController(text: widget.previousRa);
    _sigaaTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _raTextFieldController.dispose();
    _sigaaTextFieldController.dispose();
    super.dispose();
  }

  Future<void> _launchSigaa() async {
    if (!await launchUrl(
      Uri.parse('https://sig.ufabc.edu.br/sigaa/mobile/touch/menu.jsf'),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception(
        'Could not launch https://sig.ufabc.edu.br/sigaa/mobile/touch/menu.jsf',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SorrisinhoTheme.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenNameWidget(
                screenName: 'Aulas',
              ),
              Container(
                margin: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                child: const Text(
                  'Oi, bixo/bixete. Infelizmente o núcleo de tecnologia da '
                  'UFABC não nos ajuda a te ajudar e a matrícula de vocês é '
                  'feita de forma diferente dos veteranos. Por isso você vai '
                  'precisar fazer um passo a mais para adicionar suas aulas: ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                child: const Text(
                  'Acesse o SIGAA UFABC, faça o login, selecione a opção '
                  '"Atestado de matrícula", copie todo o conteúdo da primeira '
                  'tabela abaixo do número de turmas matriculadas e volte aqui '
                  'no app para colar o conteúdo no campo abaixo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    EventTracker().sendEvent(eventName: 'launch_sigaa_clicked');
                    await _launchSigaa();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 8,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero),
                    ),
                  ),
                  child: Text(
                    'Acessar SIGAA',
                    style: TextStyle(
                      color: SorrisinhoTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.fromSTEB(16, 32, 16, 0),
                child: const Text(
                  'Confirme seu RA: ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: TextField(
                  controller: _raTextFieldController,
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  maxLines: 1,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    helperStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: const Text(
                  'Cole aqui o conteúdo do SIGAA: ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: TextField(
                  controller: _sigaaTextFieldController,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    helperStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      EventTracker().sendEvent(
                        eventName: 'send_sigaa_text_clicked',
                        eventProps: {
                          'ra': _raTextFieldController.text,
                        },
                      );
                      final response = await context
                          .read<ClassRoomViewModel>()
                          .insertSigaaText(
                            _raTextFieldController.text,
                            _sigaaTextFieldController.text,
                          );

                      if (response && context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 8,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                    ),
                    child: Text(
                      'Enviar',
                      style: TextStyle(
                        color: SorrisinhoTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      EventTracker().sendEvent(
                        eventName: 'cancel_send_sigaa_text_clicked',
                        eventProps: {
                          'ra': _raTextFieldController.text,
                        },
                      );

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SorrisinhoTheme.primaryColor,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
