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

////////////////////////////////////
class BestFit extends MemoryManager {

  BestFit(String c, String nm) {
    super(c, nm);
  }

  void initialise(String fn) {
    filename = fn;
    initialise();
  }

  void initialise() {
    message = "BestFit >> Starting search of partition for program ("+filename+")";
    os.interruptsEnabled = false;
    os.switchTo(this);
  }

  void execute() {
    result = null;
    int requestedSize = myPC.HDD.get(filename).length()+os.processAppendix.length();
    for (PartitionInfo partition : os.partitionTable) {
      if (partition.isFree && partition.size>=requestedSize) {
        
        //one that checks if the partition in i is larger than or equal to the requestedSize
        //and the other one checking if that partition is smaller than the original partition
        int bestPartition =0;
        for (int i = 1; i < os.partitionTable.size(); i++){
          
          
          if(partition.isFree && os.partitionTable.get(i).size>=requestedSize){
            
            if(os.partitionTable.get(i).size<partition.size){
              bestPartition = os.partitionTable.indexOf(i);
              
              
            }
            //insert a new partition after this one 
            
            
          }
        }
        int secondPartBA = partition.baseAddress + requestedSize;
        int secondPartSize = partition.size - requestedSize;
        int fistPartSize = requestedSize;
        int partIndex = bestPartition;
         //int secondPartBA = partition.baseAddress + requestedSize;
         //int secondPartSize = partition.size - requestedSize;
         //int fistPartSize = requestedSize;
         //int partIndex = os.partitionTable.indexOf(partition);
         //int minpartition = os.partitionTable.get(0);
         os.partitionTable.add(partIndex+1, new PartitionInfo(secondPartSize, secondPartBA));
         partition.size = fistPartSize;
         result = partition;
         break;
        
        
        //if (partition.size>requestedSize) {
        //  os.partitionTable.add(partIndex+1, new PartitionInfo(secondPartSize, secondPartBA));
        //}
        //partition.size = fistPartSize;
        //result = partition;
        //break;
      }
    }
    if (result==null) {
      message = "BestFit >> No partition for "+filename+" was found. Will try again in 100 ticks";
      os.loadProgram(myPC.clock+100, filename);
    }else message = "BestFit >> Partition created at base address "+result.baseAddress+" ("+filename+")";
    os.interruptsEnabled = false;
  }
}
