import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo_list/colors/my_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isChecked = false;
  var createTodoController = TextEditingController();
  final GlobalKey<FormState> _createTodoFormKey = GlobalKey<FormState>();

  List<String> todos = [];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todos = prefs.getStringList('todos') ?? [];
    });
  }

  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('todos', todos);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    void createTodo(BuildContext context) {
      if (_createTodoFormKey.currentState!.validate()) {
        setState(() {
          todos.add(createTodoController.text);
          createTodoController.clear();
          _saveData();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item added successfully!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 220,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'assets/images/todos.webp',
                        ),
                        alignment: Alignment.topCenter,
                        colorFilter: ColorFilter.mode(
                          Color.fromARGB(122, 0, 0, 0),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Text(
                                'TO DO LIST',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'Still to do: 0',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                            ),
                            child: Form(
                              key: _createTodoFormKey,
                              child: TextFormField(
                                controller: createTodoController,
                                decoration: InputDecoration(
                                  errorStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Create a new todo ...',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: () => createTodo(context),
                                    icon: const Icon(Icons.add, size: 30),
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            surfaceTintColor: Colors.white,
                            child: SizedBox(
                              width: size.width,
                              height: size.height / 1.3,
                              // child: ListView(
                              //   children: [
                              //     ListTile(
                              //       leading: Checkbox(
                              //         checkColor: Colors.white,
                              //         value: isChecked,
                              //         onChanged: (bool? value) {
                              //           setState(() {
                              //             isChecked = value!;
                              //           });
                              //         },
                              //       ),
                              //       title: const Text(
                              //         'My to do ...',
                              //         style: TextStyle(
                              //           fontSize: 14,
                              //         ),
                              //       ),
                              //       trailing: Wrap(
                              //         children: [
                              //           IconButton(
                              //             icon: const Icon(
                              //               Icons.edit,
                              //               color: MyColors.c1,
                              //             ),
                              //             tooltip: 'Edit',
                              //             onPressed: () {},
                              //           ),
                              //           IconButton(
                              //             icon: const Icon(
                              //               Icons.delete,
                              //               color: MyColors.c2,
                              //             ),
                              //             tooltip: 'Delete',
                              //             onPressed: () {},
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //     const Divider(height: 0),
                              //   ],
                              // ),
                              child: ListView.builder(
                                itemCount: todos.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: Checkbox(
                                          checkColor: Colors.white,
                                          value: isChecked,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isChecked = value!;
                                            });
                                          },
                                        ),
                                        title: Text(
                                          todos[index],
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        trailing: Wrap(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: MyColors.c1,
                                              ),
                                              tooltip: 'Edit',
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: MyColors.c2,
                                              ),
                                              tooltip: 'Delete',
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(height: 0),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
