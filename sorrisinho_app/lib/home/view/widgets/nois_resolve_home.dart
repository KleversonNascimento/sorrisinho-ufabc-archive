import 'package:flutter/material.dart';
import 'package:sorrisinho_app/classroom/models/nois_resolve.dart';
import 'package:sorrisinho_app/shared/event_tracker.dart';
import 'package:url_launcher/url_launcher.dart';

class NoisResolveWidget extends StatefulWidget {
  final NoisResolve noisResolve;
  const NoisResolveWidget({
    super.key,
    required this.noisResolve,
  });

  @override
  State<NoisResolveWidget> createState() => _NoisResolveWidgetState();
}

class _NoisResolveWidgetState extends State<NoisResolveWidget> {
  @override
  void initState() {
    super.initState();
    EventTracker().sendEvent(eventName: 'nois_resolve_page_viewed');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: GestureDetector(
        onTap: () async {
          EventTracker().sendEvent(
            eventName: 'nois_resolve_click',
            eventProps: {
              'link': widget.noisResolve.link,
              'text': widget.noisResolve.text,
            },
          );
          await launchUrl(
            Uri.parse(widget.noisResolve.link),
            mode: LaunchMode.externalApplication,
          );
        },
        child: Material(
          elevation: 8,
          color: const Color(0xFF2664D6),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          child: Row(
            children: [
              Flexible(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Column(
                    children: [
                      Text(
                        '${widget.noisResolve.text} \n\n👨‍🏫 Aulas particulares e em grupo\n📝 Auxílio em listas de exercícios\n✍🏻 Resolução de provas antigas\n🕗 Ajuda imediata: Disponível 24/7 pra te ajudar!\n✅ E outros serviços personalizados!\n\nToque aqui para entrar em contato',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
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
