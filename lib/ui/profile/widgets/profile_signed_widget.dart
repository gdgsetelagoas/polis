import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:res_publica/model/user_entity.dart';
import 'package:res_publica/ui/feed/bloc/feed_event.dart';
import 'package:res_publica/ui/feed/feed_page.dart';
import 'package:res_publica/ui/profile/bloc/profile_bloc.dart';
import 'package:res_publica/ui/profile/bloc/profile_events.dart';
import 'package:res_publica/ui/profile/bloc/profile_states.dart';
import 'package:res_publica/ui/publication/widgets/dialog_select_source.dart';
import 'package:res_publica/ui/widgets/app_circular_imagem.dart';

class ProfileSignedWidget extends StatefulWidget {
  final ProfileBloc bloc;
  final UserEntity user;

  const ProfileSignedWidget({Key key, @required this.bloc, @required this.user})
      : super(key: key);

  @override
  _ProfileSignedWidgetState createState() => _ProfileSignedWidgetState();
}

class _ProfileSignedWidgetState extends State<ProfileSignedWidget> {
  final TextEditingController _nameController = TextEditingController();
  NumberFormat _numberFormat = NumberFormat.compact(locale: "pt_BR");
  UserEntity _user;

  @override
  void initState() {
    _user = widget.user;
    _nameController.text = _user?.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: widget.bloc,
      condition: (oldState, newState) {
        if (newState is ProfileSigned) {
          _user = newState.user;
          _nameController.text = _user?.name;
        }
        return newState is ProfileEditingName || newState is ProfileSigned;
      },
      builder: (context, state) => Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: "Editar Perfil",
          mini: true,
          onPressed: state is ProfileEditingName
              ? () => widget.bloc
                  .dispatch(ProfileUpdateName(name: _nameController.text))
              : () => widget.bloc.dispatch(ProfileUpdatingName(editing: true)),
          child: state is ProfileEditingName
              ? Icon(Icons.done, color: Colors.black)
              : Icon(Icons.edit, color: Colors.black),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: GestureDetector(
                        onTap: state is ProfileEditingName
                            ? () async {
                                var source = await showDialog<ImageSource>(
                                    context: context, builder: dialogImage);
                                if (source == null) return;
                                var file =
                                    await ImagePicker.pickImage(source: source);
                                if (file == null) return;
                                File croppedFile = await ImageCropper.cropImage(
                                  sourcePath: file.path,
                                  ratioX: 1.0,
                                  ratioY: 1.0,
                                  maxWidth: 512,
                                  maxHeight: 512,
                                );
                                if (croppedFile == null) return;
                                widget.bloc.dispatch(
                                    ProfileUpdatePhoto(path: croppedFile.path));
                              }
                            : null,
                        child: AppCircularImage(
                          _user?.photo ?? "",
                          borderSide:
                              BorderSide(color: Colors.white, width: 6.0),
                          size: 150.0,
                          shadows: [
                            BoxShadow(
                                color: Colors.black38,
                                offset: Offset(0, 6),
                                blurRadius: 3.5)
                          ],
                        ),
                      ),
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      controller: _nameController,
                      decoration: InputDecoration.collapsed(
                        hintText: "Seu Nome",
                        border: state is ProfileEditingName
                            ? OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                    width: 20.0))
                            : InputBorder.none,
                        enabled: state is ProfileEditingName,
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 24.0),
                      onSubmitted: (name) {
                        widget.bloc.dispatch(
                            ProfileUpdateName(name: _nameController.text));
                      },
                    ),
                    Text(_user?.email ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 14.0)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Scaffold(
                                appBar: AppBar(title: Text("Suas Publicações")),
                                body: FeedPage(feedContext: FeedContext.MINE),
                              ))),
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text:
                                  "${_numberFormat.format(_user?.numPublications ?? 0)}",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Theme.of(context).primaryColor),
                              children: [
                                TextSpan(
                                    text: "\nPublicações",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12.0))
                              ])),
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade400,
                    width: 1.0,
                    height: 16.0,
                    child: Center(),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Scaffold(
                                appBar: AppBar(
                                    title: Text("Publicações Que Você Segue")),
                                body:
                                    FeedPage(feedContext: FeedContext.FOLLOWED),
                              ))),
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text:
                                  "${_numberFormat.format(_user?.numFollows ?? 0)}",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Theme.of(context).primaryColor),
                              children: [
                                TextSpan(
                                    text: "\nSeguindo",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12.0))
                              ])),
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade400,
                    width: 1.0,
                    height: 16.0,
                    child: Center(),
                  ),
                  Expanded(
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text:
                                "${_numberFormat.format(_user?.numFollowers ?? 0)}",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).primaryColor),
                            children: [
                              TextSpan(
                                  text: "\nSeguidores",
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12.0))
                            ])),
                  ),
                  Container(
                    color: Colors.grey.shade400,
                    width: 1.0,
                    height: 16.0,
                    child: Center(),
                  ),
                  Expanded(
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text:
                                "${_numberFormat.format(_user?.numReactions ?? 0)}",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).primaryColor),
                            children: [
                              TextSpan(
                                  text: "\nReações",
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12.0))
                            ])),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
