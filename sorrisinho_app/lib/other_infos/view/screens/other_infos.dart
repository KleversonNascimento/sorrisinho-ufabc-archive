import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sorrisinho_app/other_infos/vacation_countdown/view/screens/vacation_countdown.dart';
import 'package:sorrisinho_app/other_infos/view/widgets/other_infos_item.dart';
import 'package:sorrisinho_app/shared/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherInfosScreen extends StatefulWidget {
  const OtherInfosScreen({super.key});

  @override
  State<OtherInfosScreen> createState() => _OtherInfosScreenState();
}

class _OtherInfosScreenState extends State<OtherInfosScreen> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then(
      (packageInfo) => setState(
        () {
          appVersion = packageInfo.version;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SorrisinhoTheme.primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OtherInfosItemWidget(
              title: 'Contador de férias',
              icon: Icons.access_time,
              subtitle:
                  'Acompanhe a contagem regressiva para o fim do quadrimestre',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VacationCountdownScreen(),
                  ),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
            ),
            OtherInfosItemWidget(
              title: 'Perguntas frequentes',
              icon: Icons.question_answer,
              subtitle:
                  'Senha do wi-fi, horários de funcionamento e outras infos '
                  'úteis',
              onTap: () {},
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
            ),
            OtherInfosItemWidget(
              title: 'Bugs e sugestões',
              icon: Icons.bug_report_outlined,
              subtitle:
                  'Algo de errado não parece certo no app? Tem uma ideia legal '
                  'de funcionalidade? Manda pra gente!',
              onTap: () => launchUrl(
                Uri.parse('https://api.whatsapp.com/send?phone=5511958956625'),
                mode: LaunchMode.externalApplication,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
            ),
            OtherInfosItemWidget(
              title: 'Nossos links',
              icon: Icons.insert_link,
              subtitle:
                  'Compartilhe o app com seus amigos e nos siga nas redes '
                  'sociais, somos biscoiteiros',
              onTap: () => launchUrl(
                Uri.parse('https://linktr.ee/sorrisinhoufabc'),
                mode: LaunchMode.externalApplication,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
            ),
            Text(
              'Sorrisinho UFABC, versão $appVersion',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
