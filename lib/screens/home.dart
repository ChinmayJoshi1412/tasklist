import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklist/services/Task.dart';
class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  SharedPreferences sharedPreferences;
  String new_task;
  List <Task> task = List<Task>();
  List <Task> foundtask = [];
  @override
  void initState() {
    initsharedpreferences();
    super.initState();
  }
  initsharedpreferences() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey('task'))
      {
      loadData();
      }
    else
      {
        foundtask = task;
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300] ,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Task list',style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                onChanged: (val) => runfilter(val),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,
                  color: Colors.grey[600],),
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 20
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Container(
              alignment: Alignment.topLeft,
                child: Text('Tasks to do',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 30),)),
            SizedBox(height: 20,),
            Expanded(
              child:  ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.grey,Colors.grey.withOpacity(0),Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.transparent, Colors.grey],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: Material(
                  elevation: 0,
                  color: Colors.grey[300],
                  child: foundtask.isEmpty ?
                      Center(
                        child:Text('No Tasks',style: TextStyle(fontSize: 30,color: Colors.grey[600])))
                      : ListView.builder(
                        shrinkWrap: true,
                          scrollDirection:Axis.vertical,
                          physics: ScrollPhysics(),
                          itemCount: foundtask.length,
                          itemBuilder: (context,index){
                        return Container(
                            padding: EdgeInsets.symmetric(vertical:15),
                            child: ListTile(
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              leading: Icon(foundtask[index].pressed ? Icons.check_box : Icons.check_box_outline_blank,
                              color: Colors.blueAccent[400],),
                              title: Text(foundtask[index].task_name,style: TextStyle(
                                fontSize: 20,
                                decoration: task[index].pressed ? TextDecoration.lineThrough : TextDecoration.none
                              ),),
                              trailing:IconButton(
                                    color: Colors.redAccent[400],
                                    onPressed: (){
                                      deleteitem(foundtask[index].id);
                                      setState(() {
                                      });
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                              onTap: (){
                                setState(() {
                                  foundtask[index].pressed = !foundtask[index].pressed;
                                  saveData();
                                });
                              },
                            )
                        );
                      })
                  ),
                  ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder: (context){
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)
              ),
              backgroundColor: Colors.grey[300],
              elevation: 20,
              child: SingleChildScrollView(
                child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'New Task',
                                hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 20
                                ),
                              ),
                              onChanged: (val)
                              {
                                new_task = val;
                              },
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          primary: Colors.redAccent[400]
                        ),
                          onPressed: (){
                          setState(() {
                            additem(new_task);
                          });
                          Navigator.of(context, rootNavigator: true).pop('dialog');
                          FocusManager.instance.primaryFocus?.unfocus();
                      }, child: Text('Add'),),
                    )
                    ],
                  ),
              ),
            );
          });
        },
        backgroundColor: Colors.redAccent[400],
        child: Icon(Icons.add),
      ),
    );
  }
  void deleteitem(String id)
  {
    task.removeWhere((element) => element.id == id);
    saveData();
  }
  void additem(String task_name)
  {
    task.add(Task(DateTime.now().millisecondsSinceEpoch.toString(),task_name,false));
    saveData();
    setState(() {
    });
  }
  void runfilter(String keyword)
  {
    List <Task> results = [];
    if(keyword.isEmpty)
      {
        results = task;
      }
    else
      {
        results = task.where((element) => element.task_name.toLowerCase().contains(keyword.toLowerCase())).toList();
      }
    setState(() {
      foundtask = results;
    });
  }
  void saveData()
  {
    List <String> spList = task.map((e) => jsonEncode(e.toMap())).toList();
    sharedPreferences.setStringList('task',spList);
  }
  void loadData()
  {
    List<String> spList = sharedPreferences.getStringList('task');
    task = spList.map((e) => Task.fromMap(jsonDecode(e))).toList();
    foundtask = task;
    setState(() {});
  }

}

