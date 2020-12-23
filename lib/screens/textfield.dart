// TextFormField(
//                             controller: _textController,
//                             onTap: ()async{
//                               Prediction p = await PlacesAutocomplete
//                               .show(
//                                 context: context,
//                                 apiKey: googleKey,
//                                 language: "en",
//                                 components: [
//                                   Component(
//                                     Component.country,
//                                     "ng"
//                                     )
//                                   ]
//                               );
//                               String res =p.description;
//                               if (p!=null) {
//                                 changeV(1, res);
//                               }
//                             },
//                             style: TextStyle(fontSize: widget.fontsize * 20),
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(
//                                 Icons.home,
//                                 color: Colors.blueAccent,
//                               ),
//                               labelText: 'Pick Up Address',
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10)),
//                                 borderSide: BorderSide(color: Colors.red),
//                               ),
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10)),
//                                 borderSide: BorderSide(color: Colors.red),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10)),
//                                   borderSide: BorderSide(
//                                       color: Theme.of(context).primaryColor)),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10)),
//                                 borderSide:
//                                     BorderSide(color: Colors.blueAccent),
//                               ),
//                             ),
//                             validator: (v) {
//                               if (v.isEmpty) {
//                                 return "An address can't be empty";
//                               } else if (v.length < 5) {
//                                 return "An address can't be lesser than 5 characters";
//                               }
//                             },
//                             onSaved: (v) {
//                               _addresses['pickup'] = v;
//                             },
//                           ),
