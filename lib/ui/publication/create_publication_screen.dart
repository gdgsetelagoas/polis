import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:res_publica/model/publication_entity.dart';
import 'package:res_publica/ui/publication/bloc/publication_bloc.dart';
import 'package:res_publica/ui/publication/widgets/dialog_select_source.dart';
import 'package:res_publica/ui/publication/widgets/publication_resource_tile.dart';
import 'package:res_publica/ui/widgets/app_circular_imagem.dart';
import 'package:res_publica/ui/widgets/app_errors_dialog.dart';
import 'package:res_publica/ui/widgets/app_text_form_field.dart';

import 'bloc/bloc.dart';

class CreatePublicationScreen extends StatefulWidget {
  @override
  _CreatePublicationScreenState createState() =>
      _CreatePublicationScreenState();
}

class _CreatePublicationScreenState extends State<CreatePublicationScreen> {
  PublicationBloc _bloc;
  final TextEditingController _body = TextEditingController();
  final List<PublicationResource> _resources = [];

  @override
  void initState() {
    _bloc = BlocProvider.of<PublicationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PublicationEvent, PublicationState>(
      child: BlocBuilder<PublicationEvent, PublicationState>(
        bloc: _bloc,
        builder: (BuildContext context, PublicationState state) {
          if (state is PublicationProcessing)
            return Scaffold(
              appBar: AppBar(
                title: Text("Carregando.."),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  state is PublicationCreate ? "Criar publicação" : "Editar"),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.cancel),
                    tooltip: "Cancelar",
                    onPressed: () {
                      _bloc.dispatch(PublicationCancelButtonPressed());
                    }),
                IconButton(
                    icon: Icon(FontAwesomeIcons.checkCircle),
                    tooltip: "Publicar",
                    onPressed: () {
                      _bloc.dispatch(
                          PublicationPublishButtonPressed(PublicationEntity(
                        subtitle: _body.text,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        resources: _resources,
                      )));
                    })
              ],
            ),
            body: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate(<Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AppCircularImage(
                                  (state as PublicationCreate).user?.photo ??
                                      "",
                                  size: 48.0,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  (state as PublicationCreate).user?.name ??
                                      "Usuário não autenticado",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              )
                            ],
                          ),
                          AppTextFormField(
                            textHint: "Descreva aqui o problema encontrado",
                            maxLines: 6,
                            textInputAction: TextInputAction.done,
                            controller: _body,
                          ),
                        ]),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.only(top: 16.0),
                        sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate((con, index) {
                              return PublicationResourceTile(
                                  resource: _resources[index],
                                  onPressed: () {
                                    _resources.removeAt(index);
                                    setState(() {});
                                  });
                            }, childCount: _resources.length),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2)),
                      )
                    ],
                  ),
                ),
                Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.only(
                              topStart: Radius.circular(16.0),
                              topEnd: Radius.circular(16.0))),
                      margin: EdgeInsets.all(0.0),
                      elevation: 3.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("Adicionar:"),
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.photo),
                                  tooltip: "Selecionar Imagens",
                                  onPressed: () async {
                                    var source = await showDialog<ImageSource>(
                                        context: context, builder: dialogImage);
                                    if (source == null) return;
                                    var file = await ImagePicker.pickImage(
                                        source: source,
                                        maxHeight: 1024,
                                        maxWidth: 1024);
                                    if (file == null) return;
                                    _resources.add(PublicationResource(
                                        type: PublicationResourceType.IMAGE,
                                        resource: file.path));
                                    setState(() {});
                                  }),
                              IconButton(
                                  icon: Icon(Icons.video_library),
                                  tooltip: "Selecionar Videos",
                                  onPressed: () async {
                                    var source = await showDialog<ImageSource>(
                                        context: context, builder: dialogVideo);
                                    if (source == null) return;
                                    var file = await ImagePicker.pickVideo(
                                        source: source);
                                    if (file == null) return;
                                    _resources.add(PublicationResource(
                                        resource: file.path,
                                        type: PublicationResourceType.VIDEO));
                                    setState(() {});
                                  })
                            ],
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          );
        },
      ),
      bloc: _bloc,
      listener: (con, state) {
        // Show Errors
        if (state is PublicationErrors) AppErrorsDialog(errors: state.errors);
        // Successful
        if (state is PublicationSuccessful)
          Navigator.of(context).pop(state.publication);
        // Cancel and close screen
        if (state is PublicationCancel && state.isCancel)
          Navigator.of(context).pop();
        // Ask to user if to discard publication
        if (state is PublicationCancel && !state.isCancel)
          showDialog<bool>(context: context, builder: dialogConfirmCancel)
              .then((cancel) {
            if (cancel ?? false) Navigator.of(context).pop();
          });
      },
    );
  }
}
