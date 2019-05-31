import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Markdown(
        onTapLink: (link) async {
          if (await canLaunch(link)) launch(link);
        },
        data: """
## Links Úteis

 - Site Câmara Vereadores Sete Lagoas: [http://www.camarasete.mg.gov.br/Default1.aspx](http://www.camarasete.mg.gov.br/Default1.aspx) 

- Link para o acesso ao Diário Oficial do Legislativo de Sete Lagoas (MG): [http://www.camarasete.mg.gov.br/publicacoes_painel.aspx?id=1](http://www.camarasete.mg.gov.br/publicacoes_painel.aspx?id=1) 

- Link para o acesso ao Sistema de Apoio ao Processo Legislativo (SAPL) de Sete Lagoas (MG): [https://sapl.setelagoas.mg.leg.br/](https://sapl.setelagoas.mg.leg.br/)

- Link para o acesso à Ouvidoria Parlamentar da Câmara de Vereadores de Sete Lagoas (MG): [http://www.camarasete.mg.gov.br/ouvidoria.aspx](http://www.camarasete.mg.gov.br/ouvidoria.aspx)

- Link para o acesso ao e-SIC da Câmara de Vereadores de Sete Lagoas (MG): [http://www.camarasete.mg.gov.br/esic.aspx](http://www.camarasete.mg.gov.br/esic.aspx)

- Link para o acesso à Lei Orgânica do Município de Sete Lagoas (MG): [http://www.camarasete.mg.gov.br/links/lei_organica.pdf](http://www.camarasete.mg.gov.br/links/lei_organica.pdf)

- Link para o acesso ao Regimento Interno da Câmara dos Vereadores de Sete Lagoas (MG): [http://www.camarasete.mg.gov.br/links/regimento_interno_2018.pdf](http://www.camarasete.mg.gov.br/links/regimento_interno_2018.pdf)

- Link para o acesso ao Portal da Transparência da Prefeitura Municipal de Sete Lagoas (MG): [http://transparencia.setelagoas.mg.gov.br/](http://transparencia.setelagoas.mg.gov.br/)

- Site Transparência Internacional – Brasil: [https://transparenciainternacional.org.br/home/destaques](https://transparenciainternacional.org.br/home/destaques)

- Link para o acesso ao Plano Plurianual do Município de Sete Lagoas (MG) 2018-2021: [https://leismunicipais.com.br/a1/mg/s/sete-lagoas/lei-ordinaria/2017/872/8727/leiordinaria-n-8727-2017-institui-o-plano-plurianual-do-municipio-de-sete-lagoas-para-oquadrienio-2018-a-2021](https://leismunicipais.com.br/a1/mg/s/sete-lagoas/lei-ordinaria/2017/872/8727/leiordinaria-n-8727-2017-institui-o-plano-plurianual-do-municipio-de-sete-lagoas-para-oquadrienio-2018-a-2021)

- Link para o acesso ao Plano Diretor do Município de Sete Lagoas (MG): [https://leismunicipais.com.br/a/mg/s/sete-lagoas/lei-complementar/2006/10/109/leicomplementar-n-109-2006-promove-a-revisao-do-plano-diretor-do-municipio-desete-lagoas-aprovado-pela-lei-complementar-06-de-23-de-setembro-de-1991-nostermos-do-capitulo-iii-da-lei-10257-de-10-de-julho-de-2001-estatuto-da-cidade](https://leismunicipais.com.br/a/mg/s/sete-lagoas/lei-complementar/2006/10/109/leicomplementar-n-109-2006-promove-a-revisao-do-plano-diretor-do-municipio-desete-lagoas-aprovado-pela-lei-complementar-06-de-23-de-setembro-de-1991-nostermos-do-capitulo-iii-da-lei-10257-de-10-de-julho-de-2001-estatuto-da-cidade)""",
      ),
    );
  }
}
