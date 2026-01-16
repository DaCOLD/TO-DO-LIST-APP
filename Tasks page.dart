void displayTaskPop(){
    showDialog(
        context: context, builder:(BuildContext _context){
      return AlertDialog(
        title: const Text("Add a Task Luis"),
        content: TextField(
          onSubmitted: (value){

            if(content != null){
              var task = Task(
                  todo: content!,
                  timeStamp: DateTime.now(),
                  done: false);
              _box!.add(task.toMap());

              setState(() {
                print(value);
                Navigator.pop(context);
              });
            }

          },

          onChanged: (value){
            setState(() {
              content = value;
              print(value);
            });
          },
        ),
      );
    });
  }
}
