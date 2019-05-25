import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:res_publica/ui/profile/bloc/profile_bloc.dart';
import 'package:res_publica/ui/profile/bloc/profile_events.dart';
import 'package:res_publica/ui/profile/bloc/profile_states.dart';
import 'package:res_publica/ui/publication/widgets/dialog_select_source.dart';
import 'package:res_publica/ui/widgets/app_circular_imagem.dart';

class ProfileSignedWidget extends StatefulWidget {
  final ProfileState state;

  const ProfileSignedWidget({Key key, this.state}) : super(key: key);

  @override
  _ProfileSignedWidgetState createState() => _ProfileSignedWidgetState();
}

class _ProfileSignedWidgetState extends State<ProfileSignedWidget> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.text = (widget.state as ProfileSigned).user?.name ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ProfileBloc>(context);
    return ListView(
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
                    onTap: widget.state is ProfileEditingName
                        ? () async {
                            var source = await showDialog<ImageSource>(
                                context: context, builder: dialogImage);
                            if (source == null) return;
                            var file = await ImagePicker.pickImage(
                                source: source);
                            if (file == null) return;
                            File croppedFile = await ImageCropper.cropImage(
                              sourcePath: file.path,
                              ratioX: 1.0,
                              ratioY: 1.0,
                              maxWidth: 512,
                              maxHeight: 512,
                            );
                            if (croppedFile == null) return;
                            bloc.dispatch(
                                ProfileUpdatePhoto(path: croppedFile.path));
                          }
                        : null,
                    child: AppCircularImage(
                      (widget.state as ProfileSigned).user?.photo ?? "",
                      borderSide: BorderSide(color: Colors.white, width: 6.0),
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: _nameController,
                          decoration: InputDecoration.collapsed(
                            hintText: "Seu Nome",
                            border: widget.state is ProfileEditingName
                                ? OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white,
                                        style: BorderStyle.solid,
                                        width: 20.0))
                                : InputBorder.none,
                            enabled: widget.state is ProfileEditingName,
                          ),
                          style: TextStyle(color: Colors.white, fontSize: 24.0),
                          onSubmitted: (name) {
                            bloc.dispatch(
                                ProfileUpdateName(name: _nameController.text));
                          },
                        ),
                      ),
                    ),
                    widget.state is ProfileEditingName
                        ? IconButton(
                            icon: Icon(Icons.done, color: Colors.white),
                            alignment: Alignment.centerLeft,
                            onPressed: () => bloc.dispatch(
                                ProfileUpdateName(name: _nameController.text)))
                        : IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            alignment: Alignment.centerLeft,
                            onPressed: () => bloc
                                .dispatch(ProfileUpdatingName(editing: true)))
                  ],
                ),
                Text((widget.state as ProfileSigned).user?.email ?? "",
                    style: TextStyle(color: Colors.white, fontSize: 14.0)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "0",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor),
                      children: [
                        TextSpan(
                            text: "\nPublicações",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12.0))
                      ])),
              Container(
                color: Colors.grey.shade400,
                width: 1.0,
                height: 16.0,
                child: Center(),
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "0",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor),
                      children: [
                        TextSpan(
                            text: "\nSeguindo",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12.0))
                      ])),
              Container(
                color: Colors.grey.shade400,
                width: 1.0,
                height: 16.0,
                child: Center(),
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "0",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColor),
                      children: [
                        TextSpan(
                            text: "\nReações",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12.0))
                      ]))
            ],
          ),
        )
      ],
    );
  }
}
