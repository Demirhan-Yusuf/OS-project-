class SJF extends ProcessScheduler {

  //Inputs

  //Outputs

  //Internal

  SJF(String c, String nm) {
    super(c, nm);
  }

  void initialise() {
    message = "SJF >> started search for process to run";
    os.interruptsEnabled = false;
    os.switchTo(this);
  }

  void execute() {
    int min =0;
    os.active=os.readyQueue.get(0);
    for (int i = 1; i < os.readyQueue.size(); i++){
      if(os.active.size>os.readyQueue.get(i).size){
        os.active = os.readyQueue.get(i);
        min =i;

      }
    }
    

    message = "SJF >> found process "+os.readyQueue.get(min).pid+", program: "+os.readyQueue.get(min).name;
    os.readyQueue.remove(min);
    this.state=READY;
    os.active.state=RUNNING;
    
    os.interruptsEnabled = true;
  }
 
}

//class SJF extends ProcessScheduler {

//  //Inputs

//  //Outputs

//  //Internal

//  SJF(String c, String nm) {
//    super(c, nm);
//  }

//  void initialise() {
//    message = "SJF >> started search for process to run";
//    os.interruptsEnabled = false;
//    os.switchTo(this);
//  }

//  void execute() {
//    os.active = os.readyQueue.get(0);
//    for(int i=1; i<os.readyQueue.size(); i++) {
//      if(os.active.size > os.readyQueue.get(i).size)
//        os.active = os.readyQueue.get(i);
//    }
//    message = "SJF >> found process "+os.readyQueue.get(0).pid+", program: "+os.readyQueue.get(0).name;
//    os.readyQueue.remove(0);
//    this.state=READY;
//    os.active.state=RUNNING;
//    os.interruptsEnabled = true;
//  }
//}
