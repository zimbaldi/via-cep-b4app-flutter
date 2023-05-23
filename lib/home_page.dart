import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:via_cep/models/back4app_model.dart';
import 'package:via_cep/models/via_cep_model.dart';

import 'package:via_cep/repositories/back4app_repository.dart';
import 'package:via_cep/repositories/via_cep_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Back4appRepository b4aRepository;

  var cepController = TextEditingController(text: '');

  var viaCepRepository = ViaCepRepository();
  var viaCepModel = ViaCepModel();

  var b4aModel = Back4appModel();
  //var b4aRepository = Back4appRepository();

  var maskFormatter = MaskTextInputFormatter(
      mask: '#####-###',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    b4aRepository = Back4appRepository();
    loadDbList();
    super.initState();
  }

  loadDbList() async {
    b4aModel = await b4aRepository.getDbCep();
    setState(() {});
  }

  @override
  void dispose() {
    cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text(
                  'Consultar CEP',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                content: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        inputFormatters: [maskFormatter],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'CEP',
                        ),
                        maxLength: 9,
                        keyboardType: TextInputType.number,
                        controller: cepController,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          var cep = cepController.text;
                          viaCepModel = await viaCepRepository.getCep(cep);
                          var rua = viaCepModel.logradouro!;
                          Navigator.pop(_);

                          //TODO verificar se já existe no DB
                          var address = AddressModel(cep: cep, rua: rua);
                          var response = await b4aRepository.addCep(address);
                          if (response == null) return;
                          debugPrint('success on save to DB');
                          loadDbList();
                          setState(() {});
                        },
                        child: const Text('Buscar'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Consultar CEP',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     inputFormatters: [maskFormatter],
              //     decoration: const InputDecoration(
              //       border: OutlineInputBorder(),
              //       hintText: 'CEP',
              //     ),
              //     maxLength: 9,
              //     keyboardType: TextInputType.number,
              //     controller: cepController,
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              viaCepModel.logradouro == null
                  ? const Text('')
                  : Text('${viaCepModel.logradouro}'),
              // const SizedBox(
              //   height: 20,
              // ),
              // SizedBox(
              //   width: double.infinity,
              //   height: 40,
              //   child: ElevatedButton(
              //     onPressed: () async {
              //       var cep = cepController.text;
              //       viaCepModel = await viaCepRepository.getCep(cep);
              //       var rua = viaCepModel.logradouro!;

              //       //TODO verificar se já existe no DB
              //       var address = AddressModel(cep: cep, rua: rua);
              //       var response = await b4aRepository.addCep(address);
              //       if (response == null) return;
              //       debugPrint('success on save to DB');
              //       setState(() {});
              //     },
              //     child: const Text('Buscar'),
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    //Colocar no initstate
                    loadDbList();
                    //print(b4aModel.results![0].rua);

                    setState(() {});
                  },
                  child: const Text('Buscar DB'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //Testes de lista do DB
              // b4aModel.results == null
              //     ? const Text('')
              //     : Text(b4aModel.results![1].rua),

              // const SizedBox(
              //   height: 20,
              // ),
              // Text('${b4aModel.results?.length}'),

              Expanded(
                child: b4aModel.results == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: b4aModel.results?.length,
                        itemBuilder: (context, index) {
                          //print(addresses.length);
                          var addressList = b4aModel.results?[index];
                          return Card(
                            child: Column(
                              children: [
                                Text(addressList!.rua),
                                Text(addressList.cep),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
